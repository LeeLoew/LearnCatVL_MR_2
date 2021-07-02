
%data columns:
%1) pair/sing specific identity (see spreadsheet)
%2) 1 = z image ; 2 = m image
%3) 0 = singleton ; 1 = first image of pair ; 2 = second image of pair
%4) 1 = cat task; 2 = nback task
%5) randomized image number (1 - 96)--first half are cat images
%6) Actual image number (matches up with the images' names in the folder).
%7) 1 = repeated image, 2 = non-repeated image


Screen('Preference', 'SkipSyncTests', 1);

KEY = 1;
BUTTON = 2;

prompt = {'Subject identifier', '# of subject in this experiment', 'Age:', 'Sex (m/f):', 'runnum'};
name = 'Input parameters for this run';
defaultanswer={'99','0','x','x','x'};
answer = inputdlg(prompt, name, 1, defaultanswer);
[substr, snum, age, sex, runnum] = deal(answer{:});
sub = str2num(substr);
runcount = str2num(runnum);




cd data
load(['data/LearnFcatVSL-' substr '-' snum '.mat'])
cd ..
datafname = ['data/TESTLearnFcatVSL-' substr '-' runnum '.mat'];
textfname = ['data/TESTLearnFcatVSL-' substr '-' runnum '.txt'];
% open/set up screen
[w,wrect] = Screen('OpenWindow', max(Screen('Screens')),[0 0 0]);
screenvalue = Screen('Resolution',0);
realscreen_x = screenvalue.width;
realscreen_y = screenvalue.height;
cx=(realscreen_x/2);cy=(realscreen_y/2);
imRect = CenterRect([0 0 256 256], wrect);
ifi = Screen('GetFlipInterval', w);
fixRect = CenterRect([0 0 20 20],wrect);
fixColor = [255 255 0];
fixCorrectColor = [0 255 0];
fixErrorColor = [255 0 0];

for idx = 1:96
        imagetex(idx) = Screen('MakeTexture', w,  imread(['Taskimages/' imagefiles(idx).name]));
end

Screen('PreloadTextures',w,imagetex(:));

% key assignment
KbName('UnifyKeyNames');

key1 = KbName('1!');
key2 = KbName('2@');
trigger = KbName('5%');
quitKeys = KbName('9(');
spaceKey = KbName('space');

imITI = 1;
imDur = 1;
HideCursor; commandwindow;


clear FrameLog

foilone = [25	13	28	13
27	14	30	13
29	15	32	13
31	16	74	13
73	45	76	13
75	46	78	13
77	47	80	13
79	48	26	13
];

Pos = randperm(length(foilone));
for x = 1:length(foilone)
    FrameLog(x,:) = foilone(Pos(x),:);
end
foilone = FrameLog;
clear Pos
clear Framelog

foiltwo = [17	9	20	10
19	10	22	11
21	11	24	12
23	12	66	41
65	41	68	42
67	42	70	43
69	43	72	44
71	44	18	9
];

Pos = randperm(length(foiltwo));
for x = 1:length(foiltwo)
    FrameLog(x,:) = foiltwo(Pos(x),:);
end
clear Pos
foiltwo = FrameLog;
clear FrameLog

foilthree = [9	5	12	6
11	6	14	7
13	7	16	8
15	8	58	37
57	37	60	38
59	38	62	39
61	39	64	40
63	40	10	5
];

Pos = randperm(length(foilthree));
for x = 1:length(foilthree)
    FrameLog(x,:) = foilthree(Pos(x),:);
end
clear Pos
foilthree = FrameLog
clear FrameLog

foilfour = [1	1	4	2
3	2	6	3
5	3	8	4
7	4	50	33
49	33	52	34
51	34	54	35
53	35	56	36
55	36	2	1
];
Pos = randperm(length(foilfour));
for x = 1:length(foilfour)
    FrameLog(x,:) = foilfour(Pos(x),:);
end
clear Pos
foilfour = FrameLog;
clear FrameLog

%we shuffled each condition of foils within itself so target-foil pairs
%dont always share an image
foils = [foilone
    foiltwo
    foilthree
    foilfour
    ];
%stackem back up

targets = [25	13	26	13
27	14	28	14
29	15	30	15
31	16	32	16
73	45	74	45
75	46	76	46
77	47	78	47
79	48	80	48
17	9	18	9
19	10	20	10
21	11	22	11
23	12	24	12
65	41	66	41
67	42	68	42
69	43	70	43
71	44	72	44
9	5	10	5
11	6	12	6
13	7	14	7
15	8	16	8
57	37	58	37
59	38	60	38
61	39	62	39
63	40	64	40
1	1	2	1
3	2	4	2
5	3	6	3
7	4	8	4
49	33	50	33
51	34	52	34
53	35	54	35
55	36	56	36
];



%stick the foils and targets together, preserving condition within trials
%(e.g., same-cat targets are always paired with same-cat foils). 
testmx = [targets foils];
%1) target im 1 imagetex()
%2) target im 1 pair ID (matches 4)
%3) target im 2 imagetex()
%4) target im 1 pair ID (matches 2)
%5) foil im 1 imagetex ()
%6) foil im 2 pair ID (does not match 8)
%7) foil im 2 imagetex ()
%8) foil im 2 pair ID (does not match 6)

Pos = randperm(length(testmx));
for x = 1:length(testmx)
    FrameLog(x,:) = testmx(Pos(x),:);
end


%begin test phase


seqLabelDur = .5;




FrameLog(:,9) = Shuffle(repmat([1 2],1, 16))'; %1 = targ appears first, 2 = foil appears first


FrameLog(:,10) = Shuffle(repmat([0 0],1, 16))';
FrameLog(:,11) = Shuffle(repmat([0 0],1, 16))';
FrameLog(:,12) = Shuffle(repmat([0 0],1, 16))';
FrameLog(:,13) = Shuffle(repmat([0 0],1, 16))'; %I'm lazy, need to make record space
FrameLogtwo =  FrameLog; %double the number of test trials
for swap = 1:length(FrameLogtwo) %counterbalance what appears first with proper spacing between trials
    if FrameLogtwo(swap,9) == 1
        FrameLogtwo(swap,9) = 2;
    else
        FrameLogtwo(swap,9) = 1;
    end
    
end
FrameLog = [FrameLog
    FrameLogtwo];


for recTrial = 1:length(FrameLog) %times two because we have 2 sets of images now with nback and cat
    
   
    DrawFormattedText(w, 'Get ready! Which two images appeared TOGETHER in the FIRST PART of the experiment? \n \n Press space bar to start the next trial.', 'center', 'center', [255 255 255]);
    Screen('Flip', w); 
    
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if keyDown 
            if keyCodes(KbName('space'))
                break;
                elseif all(keyCodes(quitKeys))
                     Screen('Close', imagetex(:)); sca; return;
                
            end
        end
    end
    
    % show "Sequence 1"
    DrawFormattedText(w, 'Sequence 1', 'center', 'center', [255 255 255]);
    flipTime = Screen('Flip', w); 
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    if FrameLog(recTrial,9) == 1% if targ images appear first
        Screen('DrawTexture', w, imagetex(FrameLog(recTrial,1)),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(FrameLog(recTrial,5)),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2);
    
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imDur - ifi/2);
    
    
    
    Screen('FrameOval', w, fixColor, fixRect);
    if FrameLog(recTrial,9) == 1 %if targ images appear first
        Screen('DrawTexture', w, imagetex(FrameLog(recTrial,3)),[],imRect);
    else
        Screen('DrawTexture', w, imagetex(FrameLog(recTrial,7)),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    
    
    
    
    
    
    
    % show "Sequence 2"
    DrawFormattedText(w, 'Sequence 2', 'center', 'center', [255 255 255]);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2);
    
    Screen('FrameOval', w, fixColor, fixRect);
    
    
    if FrameLog(recTrial,9) == 1 %if targs went first then do foils, otherwise show targs.
         Screen('DrawTexture', w, imagetex(FrameLog(recTrial,5)),[],imRect);
       
    else
         Screen('DrawTexture', w, imagetex(FrameLog(recTrial,1)),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + seqLabelDur - ifi/2);
    
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imDur - ifi/2);
    
    
    
    Screen('FrameOval', w, fixColor, fixRect);
    if FrameLog(recTrial,9) == 1 %if targ images appear first
         Screen('DrawTexture', w, imagetex(FrameLog(recTrial,7)),[],imRect);
      
    else
         Screen('DrawTexture', w, imagetex(FrameLog(recTrial,3)),[],imRect);
    end
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 

    DrawFormattedText(w, 'Which was more familiar from the first stage of the experiment? \nPress 1 for the first sequence, 2 for the other sequence. \nIf unsure, go with your gut feeling.', 'center', 'center', [255 255 255]);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2); 
    
    while 1
        [keyDown, secs, keyCodes] = KbCheck(-1); 
        if keyDown
            if keyCodes(KbName('1!')) || keyCodes(KbName('1'))
                resp = 1; break;
            elseif keyCodes(KbName('2@')) || keyCodes(KbName('2'))
                resp = 2; break; 
                elseif all(keyCodes(quitKeys))
                 Screen('Close', imagetex(:)); sca; return;
                
            end
        end
    end
    acc = (resp == FrameLog(recTrial,9));
    rt = secs - flipTime;
    
    Screen('FrameOval', w, fixColor, fixRect);
    flipTime = Screen('Flip', w, flipTime + imITI - ifi/2);
    
    % record data
    FrameLog(recTrial,10:12) = [resp acc rt];
    save(datafname);
end






save(datafname);

DrawFormattedText(w,['Recognition 1 Complete. \n \n Thank you for participating.'],'center','center',[255 255 255]);
Screen('Flip',w);
WaitSecs(5)


Screen('Close', imagetex(:));
sca; 


































































