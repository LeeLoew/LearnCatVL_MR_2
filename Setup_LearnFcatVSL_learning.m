%This file sets up everything that can be used for all runs

%data columns:
%1) pair/sing specific identity (see spreadsheet)
%2) 1 = z image ; 2 = m image
%3) 0 = singleton ; 1 = first image of pair ; 2 = second image of pair
%4) 1 = cat task; 2 = nback task
%5) randomized image number (1 - 96)--first half are cat images
%6) Actual image number (matches up with the images' names in the folder).
%7) 1 = repeated image, 2 = non-repeated image


nBlocks  = 6; %also runs

prompt = {'Subject identifier', '# of subject in this experiment', 'Age:', 'Sex (m/f):'};
name = 'Input parameters for this run';
defaultanswer={'99','0','x','x'};
answer = inputdlg(prompt, name, 1, defaultanswer);
[substr, snum, age, sex] = deal(answer{:});
sub = str2num(substr);
datafname = ['data/LearnFcatVSL-' substr '-' snum '.mat'];
textfname = ['data/LearnFcatVSL-' substr '-' snum '.txt'];

if (exist(datafname,'file') ~= 0) || (exist(textfname, 'file'))
    firstrun = 0;
    answer = questdlg(['Data file for 1 ' substr ' already exists, what should I do?'],'Filename conflict', 'Use different file name', 'Overwrite', 'Abort', 'Use different file name');
    switch(answer)
        case 'Use different file name'
            fileidx = 0;
            while (exist(datafname,'file')~=0) || (exist(textfname, 'file'))
                fileidx = fileidx + 1;
                datafname = ['data/LearnFcatVSL-' substr '-' num2str(idx) '.mat'];
                textfname = ['data/LearnFcatVSL-' substr '-' num2str(idx) '.txt'];
            end
        case 'Overwrite'
            % keep datafname
        case 'Abort'
            return;
    end
end

%% 1. CONFIGURATION a. Read image names from TaskImages directory
%FOR FIRST TASK%%%%%%%%%%%%%
randseed = rng('shuffle');

% load in the stimuli

tmplist1 = Shuffle(dir('TaskImages/*.jpg'));

tmp1 = length(tmplist1);
tmp1 = floor(tmp1/2);

imagefiles = tmplist1(1:96);
% imagefiles = cell(1,4);
% imagefiles{1} = tmplist1(1:32); %catigorization pair images
% imagefiles{2} = tmplist1(33:48); %catigorization singleton images
% imagefiles{3} = tmplist1(39:80); %detection pair images
% imagefiles{4} = tmplist1(81:96); %detection singleton images


itemsPaired = 64; % 1/2 of this number is the number of pairs
itemsUnpaired = 32; % doesn't have to be this...can be zero...if divisible by 4 then equal # of each type
nPairs = itemsPaired/2;

nRepsPerBlock = 1;
trialsPerBlock = nRepsPerBlock*(itemsPaired+itemsUnpaired);

imDur = 1;
responsefeedback = 1;
blankDur = 1;
numruns = 4;



%%%%%%%%%%%%%current problem
%
% pairTypes = zeros(16,2);
% for idx = 1:4
%     for jdx = 1:4
%         pairTypes((idx-1)*4+jdx,:) = [idx jdx];
%     end
% end
%
% imageTypes = zeros(itemsUnpaired + nPairs,4); % each unpaired image will get a unique ID, each paired image will get a shared ID
%
% faceFileIdx = zeros(1,4); % indexes into the imagefiles / imagetex
% for idx = 1:itemsUnpaired
%     imType = mod(idx-1,4)+1;
%     faceFileIdx(imType) = faceFileIdx(imType) + 1;
%     imageTypes(idx, :) = [imType, faceFileIdx(imType), -1, -1]; % last columns are imType / fileID for predicted image; paired images only
% end
% for idx = (itemsUnpaired+1):(itemsUnpaired + nPairs)
%     imType = pairTypes(mod(idx-1,16)+1,1);
%     faceFileIdx(imType) = faceFileIdx(imType) + 1;
%     imageTypes(idx, 1:2) = [imType, faceFileIdx(imType)];
%     imType = pairTypes(mod(idx-1,16)+1,2);
%     faceFileIdx(imType) = faceFileIdx(imType) + 1;
%     imageTypes(idx, 3:4) = [imType, faceFileIdx(imType)];
% end


%
%
% targetPairs = imageTypes((itemsUnpaired+1):(itemsUnpaired + nPairs),:);
% foilPairs = targetPairs;
% foilperms = perms(1:4);
% for idx = 1:4
%     foilperms(find(foilperms(:,idx)==idx),:) = [];
% end
% foilidx = 0;
% for idx = 1:4
%     % randomly select a foilperm
%     thisperm = foilperms(randi(size(foilperms,1)),:);
%     for jdx = 1:4
%         foilidx = foilidx+1;
%         foilPairs(foilidx, 3:4) = targetPairs((idx-1)*4+thisperm(jdx),3:4);
%     end
% end
%
% block = 1;
%

subno = sub;

if mod(subno,2) == 1 %if its an odd SID
    trainingversion = 1; %start w categorization
elseif mod(subno,2) == 0 %if its an even SID
    trainingversion = 2; % start w nback
end

%preallocate data
data = cell(3,6); %3 = run number and 6 = number of blocks per run


task = trainingversion;









for run = 1:6
    
    for block = 1:6
        
        
        
        %create the order of trials
        if task == 1
            trialmatrixtemp = (Shuffle(1:32)); %cat images
            count = 1;
            for k = 1:32
                trialmatrix(count,1) = trialmatrixtemp(k);
                if trialmatrix(count,1) < 17
                    trialmatrix(count+1,1) = trialmatrixtemp(k);
                    count = count+1;
                end
                count = count+1;
                
            end
        elseif task == 2
            trialmatrixtemp = (Shuffle(33:64)); %cat images
            count = 1;
            for k = 1:32
                trialmatrix(count,1) = trialmatrixtemp(k);
                if trialmatrix(count,1) < 49
                    trialmatrix(count+1,1) = trialmatrixtemp(k);
                    count = count+1;
                end
                count = count+1;
                
            end
            
            
        end
        
        
        
        
        %This section doesn't actually matter and it's changed
        %later%%%%%%%%%%%%%%%%placeholder%%%%%%%%%%%%%%%%%%%%%%%%
        %fix~line345
        if task == 1
            
            for k = 1:48
                if trialmatrix(k,1) < 9 || (trialmatrix(k,1) > 16 && trialmatrix(k,1) < 25)
                    trialmatrix(k,2) = 1; %it's a z image
                else
                    trialmatrix(k,2) = 0; %it's an m image
                end
            end
            
        else
            
            for k = 1:48
                if trialmatrix(k,1) < 41 || (trialmatrix(k,1) > 48 && trialmatrix(k,1) < 57)
                    trialmatrix(k,2) = 1; %it's a z image
                else
                    trialmatrix(k,2) = 0; %it's an m image
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        trialmatrix(1:48,3) = zeros(48,1);
        for k = 1:48
            if k < 48
                if (trialmatrix(k,1) == trialmatrix(k+1,1)) %if its the same image as the upcoming image
                    trialmatrix(k,3) = 1; %first im of pair
                    trialmatrix(k+1,3) = 2; %second im of pair
                end
            end
        end
        
        if task == 1
            trialmatrix(:,4) = ones(48,1); %cat
        elseif task == 2
            trialmatrix(:,4) = zeros(48,1); %nback
        end
        
        indexims = [1	1
            2	1
            3	2
            4	2
            5	3
            6	3
            7	4
            8	4
            9	5
            10	5
            11	6
            12	6
            13	7
            14	7
            15	8
            16	8
            17	9
            18	9
            19	10
            20	10
            21	11
            22	11
            23	12
            24	12
            25	13
            26	13
            27	14
            28	14
            29	15
            30	15
            31	16
            32	16
            33	17
            34	18
            35	19
            36	20
            37	21
            38	22
            39	23
            40	24
            41	25
            42	26
            43	27
            44	28
            45	29
            46	30
            47	31
            48	32
            49	33
            50	33
            51	34
            52	34
            53	35
            54	35
            55	36
            56	36
            57	37
            58	37
            59	38
            60	38
            61	39
            62	39
            63	40
            64	40
            65	41
            66	41
            67	42
            68	42
            69	43
            70	43
            71	44
            72	44
            73	45
            74	45
            75	46
            76	46
            77	47
            78	47
            79	48
            80	48
            81	49
            82	50
            83	51
            84	52
            85	53
            86	54
            87	55
            88	56
            89	57
            90	58
            91	59
            92	60
            93	61
            94	62
            95	63
            96	64
            ];
        
        
        
        
        %look at the pair/singleton identity number and figure out the reference
        %number (1-96) to be used for imagefiles.
        for k = 1:48
            for n = 1:length(indexims)
                if trialmatrix(k,3) == 2
                elseif indexims(trialmatrix(k,1),1) == indexims(n,2)
                    trialmatrix(k,5) = indexims(n,1);
                    if trialmatrix(k,3) == 1
                        trialmatrix(k+1,5) = trialmatrix(k,5)+1;
                    end
                    break;
                end
            end
        end
        
        %put the actual name of the image in the 6th column (sanity check)
        for k = 1:48
            trialmatrix(k,6) = str2num(imagefiles(trialmatrix(k,5)).name(2:3));
        end
        if block < 2
            tm = zeros(64,40);
        end
        count = 0;
        
        
        
        % Now fix the category
        for k = 1:48
            if trialmatrix(k,5) < 9 ...
                    || trialmatrix(k,5) == 10 ...
                    || trialmatrix(k,5) == 12 ...
                    || trialmatrix(k,5) == 14 ...
                    || trialmatrix(k,5) == 16 ...
                    || trialmatrix(k,5) == 17 ...
                    || trialmatrix(k,5) == 19 ...
                    || trialmatrix(k,5) == 21 ...
                    || trialmatrix(k,5) == 23 ...
                    || trialmatrix(k,5) == 33 ...
                    || trialmatrix(k,5) == 34 ...
                    || trialmatrix(k,5) == 35 ...
                    || trialmatrix(k,5) == 36 ...
                    || trialmatrix(k,5) == 37 ...
                    || trialmatrix(k,5) == 38 ...
                    || trialmatrix(k,5) == 39 ...
                    || trialmatrix(k,5) == 40 ...
                    || trialmatrix(k,5) == 49 ...
                    || trialmatrix(k,5) == 50 ...
                    || trialmatrix(k,5) == 51 ...
                    || trialmatrix(k,5) == 52 ...
                    || trialmatrix(k,5) == 53 ...
                    || trialmatrix(k,5) == 54 ...
                    || trialmatrix(k,5) == 55 ...
                    || trialmatrix(k,5) == 56 ...
                    || trialmatrix(k,5) == 58 ...
                    || trialmatrix(k,5) == 60 ...
                    || trialmatrix(k,5) == 62 ...
                    || trialmatrix(k,5) == 64 ...
                    || trialmatrix(k,5) == 65 ...
                    || trialmatrix(k,5) == 67 ...
                    || trialmatrix(k,5) == 69 ...
                    || trialmatrix(k,5) == 71 ...
                    || trialmatrix(k,5) == 81 ...
                    || trialmatrix(k,5) == 82 ...
                    || trialmatrix(k,5) == 83 ...
                    || trialmatrix(k,5) == 84 ...
                    || trialmatrix(k,5) == 85 ...
                    || trialmatrix(k,5) == 86 ...
                    || trialmatrix(k,5) == 87 ...
                    || trialmatrix(k,5) == 88 ...
                    
                
                trialmatrix(k,2) = 1; %it's a z image
            else
                trialmatrix(k,2) = 0; %it's an m image
            end
        end
        
        
        
        
        
        
        
        
        
        
        % for k = 1:48
        % if trialmatrix(k,5) == 1 ...
        %     || trialmatrix(k,5) == 2 ...
        %     || trialmatrix(k,5) == 3 ...
        %     || trialmatrix(k,5) == 4 ...
        %     || trialmatrix(k,5) == 5 ...
        %     || trialmatrix(k,5) == 17 ...
        %     || trialmatrix(k,5) == 18 ...
        %     || trialmatrix(k,5) == 19 ...
        %     || trialmatrix(k,5) == 20 ...
        %     || trialmatrix(k,5) == 21 ...
        %     || trialmatrix(k,5) == 33 ...
        %     || trialmatrix(k,5) == 34 ...
        %     || trialmatrix(k,5) == 35 ...
        %     || trialmatrix(k,5) == 41 ...
        %     || trialmatrix(k,5) == 42 ...
        %     || trialmatrix(k,5) == 43 ...
        %     count = count+1
        % end
        % end
        %
        count = 1;
        for k = 1:64 %block size after addition of nbacks
            if block == 1 || block == 2
                if trialmatrix(1,5) == 3 ...
                        || trialmatrix(1,5) == 6 ...
                        || trialmatrix(1,5) == 7 ...
                        || trialmatrix(1,5) == 14 ...
                        || trialmatrix(1,5) == 15 ...
                        || trialmatrix(1,5) == 18 ...
                        || trialmatrix(1,5) == 20 ...
                        || trialmatrix(1,5) == 27 ...
                        || trialmatrix(1,5) == 29 ...
                        || trialmatrix(1,5) == 32 ...
                        || trialmatrix(1,5) == 33 ...
                        || trialmatrix(1,5) == 34 ...
                        || trialmatrix(1,5) == 35 ...
                        || trialmatrix(1,5) == 41 ...
                        || trialmatrix(1,5) == 42 ...
                        || trialmatrix(1,5) == 43 ...
                        || trialmatrix(1,5) == 51 ...
                        || trialmatrix(1,5) == 54 ...
                        || trialmatrix(1,5) == 55 ...
                        || trialmatrix(1,5) == 62 ...
                        || trialmatrix(1,5) == 63 ...
                        || trialmatrix(1,5) == 66 ...
                        || trialmatrix(1,5) == 68 ...
                        || trialmatrix(1,5) == 75 ...
                        || trialmatrix(1,5) == 77 ...
                        || trialmatrix(1,5) == 80 ...
                        || trialmatrix(1,5) == 81 ...
                        || trialmatrix(1,5) == 82 ...
                        || trialmatrix(1,5) == 83 ...
                        || trialmatrix(1,5) == 89 ...
                        || trialmatrix(1,5) == 90 ...
                        || trialmatrix(1,5) == 91 ...
                        tm(count,1:6) = trialmatrix(1,1:6);
                    
                    tm(count+1,1:6) = trialmatrix(1,1:6);
                    
                    count = count+2;
                    trialmatrix(1,:) = [];
                else
                    tm(count,1:6) = trialmatrix(1,1:6);
                    trialmatrix(1,:) = [];
                    count = count+1;
                end
                
            elseif block == 3 || block == 4
                if trialmatrix(1,5) == 1 ...
                        || trialmatrix(1,5) == 4 ...
                        || trialmatrix(1,5) == 8 ...
                        || trialmatrix(1,5) == 9 ...
                        || trialmatrix(1,5) == 11 ...
                        || trialmatrix(1,5) == 16 ...
                        || trialmatrix(1,5) == 21 ...
                        || trialmatrix(1,5) == 24 ...
                        || trialmatrix(1,5) == 25 ...
                        || trialmatrix(1,5) == 28 ...
                        || trialmatrix(1,5) == 30 ...
                        || trialmatrix(1,5) == 36 ...
                        || trialmatrix(1,5) == 37 ...
                        || trialmatrix(1,5) == 38 ...
                        || trialmatrix(1,5) == 44 ...
                        || trialmatrix(1,5) == 45 ...
                        || trialmatrix(1,5) == 49 ...
                        || trialmatrix(1,5) == 52 ...
                        || trialmatrix(1,5) == 56 ...
                        || trialmatrix(1,5) == 57 ...
                        || trialmatrix(1,5) == 59 ...
                        || trialmatrix(1,5) == 64 ...
                        || trialmatrix(1,5) == 69 ...
                        || trialmatrix(1,5) == 72 ...
                        || trialmatrix(1,5) == 73 ...
                        || trialmatrix(1,5) == 76 ...
                        || trialmatrix(1,5) == 78 ...
                        || trialmatrix(1,5) == 84 ...
                        || trialmatrix(1,5) == 85 ...
                        || trialmatrix(1,5) == 86 ...
                        || trialmatrix(1,5) == 92 ...
                        || trialmatrix(1,5) == 93 ...
                        tm(count,1:6) = trialmatrix(1,1:6);
                    
                    tm(count+1,1:6) = trialmatrix(1,1:6);
                    
                    count = count+2;
                    trialmatrix(1,:) = [];
                else
                    tm(count,1:6) = trialmatrix(1,1:6);
                    trialmatrix(1,:) = [];
                    count = count+1;
                end
                
            elseif block == 5 || block == 6
                if trialmatrix(1,5) == 2 ...
                        || trialmatrix(1,5) == 5 ...
                        || trialmatrix(1,5) == 10 ...
                        || trialmatrix(1,5) == 12 ...
                        || trialmatrix(1,5) == 13 ...
                        || trialmatrix(1,5) == 17 ...
                        || trialmatrix(1,5) == 19 ...
                        || trialmatrix(1,5) == 22 ...
                        || trialmatrix(1,5) == 23 ...
                        || trialmatrix(1,5) == 26 ...
                        || trialmatrix(1,5) == 31 ...
                        || trialmatrix(1,5) == 39 ...
                        || trialmatrix(1,5) == 40 ...
                        || trialmatrix(1,5) == 46 ...
                        || trialmatrix(1,5) == 47 ...
                        || trialmatrix(1,5) == 48 ...
                        || trialmatrix(1,5) == 50 ...
                        || trialmatrix(1,5) == 53 ...
                        || trialmatrix(1,5) == 58 ...
                        || trialmatrix(1,5) == 60 ...
                        || trialmatrix(1,5) == 61 ...
                        || trialmatrix(1,5) == 65 ...
                        || trialmatrix(1,5) == 67 ...
                        || trialmatrix(1,5) == 70 ...
                        || trialmatrix(1,5) == 71 ...
                        || trialmatrix(1,5) == 74 ...
                        || trialmatrix(1,5) == 79 ...
                        || trialmatrix(1,5) == 87 ...
                        || trialmatrix(1,5) == 88 ...
                        || trialmatrix(1,5) == 94 ...
                        || trialmatrix(1,5) == 95 ...
                        || trialmatrix(1,5) == 96 ...
                        tm(count,1:6) = trialmatrix(1,1:6);
                    
                    tm(count+1,1:6) = trialmatrix(1,1:6);
                    
                    count = count+2;
                    trialmatrix(1,:) = [];
                else
                    tm(count,1:6) = trialmatrix(1,1:6);
                    trialmatrix(1,:) = [];
                    count = count+1;
                end
                
            end
            if count == 65
                break
            end
        end
        
        data{run,block} = tm;
        
        if task == 1
            task = 2;
        elseif task == 2
            task = 1;
        end
        
    end
end

%lets add the repeat corr resp

for k = 1:6 %run
    for w = 1:6 %block
        for lol = 2:64
            if data{k,w}(lol,6) == data{k,w}(lol-1,6) %if the current image == the next image
                data{k,w}(lol,7) = 1; %1 = repeat
            end
        end
    end
end

%change all 0 corresp to 2
for k = 1:6 %run
    for w = 1:6 %block
        for lol = 1:64
            if data{k,w}(lol,2) == 0 %if the current image == the next image
                data{k,w}(lol,2) = 2; %2 = m image
            end
            if data{k,w}(lol,7) == 0 %if the current image == the next image
                data{k,w}(lol,7) = 2; %2 = non-repeat image
            end
        end
    end
end
%set up the flip times

for k = 1:6 %run
    count = 0;
    for w = 1:6 %block
        count = count + 10;
        for lol = 1:64
            count = count + 1;
            data{k,w}(lol,37) = count; %onset
            count = count+1;
            data{k,w}(lol,38) = count; %offset
            
        end
    end
end


%create the passive viewing presentation order%%%%%%%%%%%%%%%%%%%%%%%%%%%
task = 1;

for k = 1:4
    
    PV{k} = [data{1,1} %all images of one task
        data{1,2}]; %all images of another task
    
    for pl = 2:128
        if PV{k}(pl,5) == PV{k}(pl-1,5) || PV{k}(pl,5) == PV{k}(pl+1,5) %if its a repeat EITHER DIRECTION
            PV{k}(pl,:) = []; %delete it
        end
        if length(PV{k}) == 96
            break;
        end
        
    end
    %that should leave us with all base images without repeats
    
    
    %set jitter 4-7
    if k == 1
        PV{k}(:,10) = repmat(Shuffle([4 5 6 7]),1,24)'; %random at first
    else
        for ww = 1:96 %add one and loop around
            if (PV{k-1}(ww,10)) == 4
                PV{k}(ww,10) = 5;
            elseif (PV{k-1}(ww,10)) == 5
                PV{k}(ww,10) = 6;
            elseif (PV{k-1}(ww,10)) == 6
                PV{k}(ww,10) = 7;
            elseif (PV{k-1}(ww,10)) == 7
                PV{k}(ww,10) = 4;
                
            end
        end
    end
    
    
end
















for k = 1:4
    
    
    
    x = PV{k};
    
    
    ncols = size(x,2);
    
    % make a new matrix that builds pairs into rows
    y = [];
    while ~isempty(x)
        % check the next row of x
        if x(1,3) == 1
            % the next row is the first item of a pair, put both pairs in the
            % next row of y
            y(end+1, :) = [x(1,:) x(2,:)];
            x(1:2,:) = [];
        else
            % otherwise, last 7 columns are just 0's
            y(end+1, :) = [x(1,:) zeros(1, ncols)];
            x(1,:) = [];
        end
    end
    
    % shuffle y
    y = y(Shuffle(1:size(y,1)), :);
    
    % reconstruct x
    x = [];
    xidx = 1;
    for idx = 1:size(y,1)
        if y(idx, 3) == 1
            % unpack two rows
            x(xidx,:) = y(idx,1:ncols);
            x(xidx+1, :) = y(idx, (ncols+1):end);
            xidx = xidx+2;
        else
            x(xidx,:) = y(idx,1:ncols);
            xidx=xidx+1;
        end
    end
    
    
    
    
    
    PV{k} = x;
    
    count = 1;
    for ww = 1:96
        if ww == 1
            PV{k}(ww,11) = 1; %onset of first image
            PV{k}(ww,12) = PV{k}(ww,11) + 1; %offset of first image (images on for 1 sec)
        else
            PV{k}(ww,11) = PV{k}(ww-1,12) + PV{k}(ww-1,10); %(next onset comes after the last offset plug the previous images' offset time (4-7 sec)
            PV{k}(ww,12) = PV{k}(ww,11) + 1;
            
            
        end
    end
    
end







clear('run')
save(datafname)
%&& (trialmatrix(k,3) < 1
%data{1,1}(1:48,2) = trialmatrix; %column 1 is trialnumber


%str2num(imagefiles(k).name(2:3)) to extract real image number
