
clear all


%data columns:
%1) pair/sing specific identity (see spreadsheet)
%2) 1 = z image ; 2 = m image
%3) 0 = singleton ; 1 = first image of pair ; 2 = second image of pair
%4) 1 = cat task; 2 = nback task
%5) randomized image number (1 - 96)--first half are cat images
%6) Actual image number (matches up with the images' names in the folder).
%7) 1 = repeated image, 2 = non-repeated image


% Famailirization task
% remove:
Screen('Preference', 'SkipSyncTests', 1);

KEY = 1;
BUTTON = 2;

answer = questdlg('fMRI button box (Cedrus) or keyboard?', 'Input type', 'Button box', 'Keyboard','Button box');
if strcmp(answer, 'Button box')
    buttonorkey = BUTTON;
else
    buttonorkey = KEY;
end

prompt = {'Subject identifier', '# of subject in this experiment', 'Age:', 'Sex (m/f):', 'runnum'};
name = 'Input parameters for this run';
defaultanswer={'99','0','x','x','x'};
answer = inputdlg(prompt, name, 1, defaultanswer);
[substr, snum, age, sex, runnum] = deal(answer{:});
sub = str2num(substr);
runcount = str2num(runnum);
datafname = ['data/trainingLearnFcatVSL-' substr '-' runnum '.mat'];
textfname = ['data/trainingLearnFcatVSL-' substr '-' runnum '.txt'];




cd data
load(['data/LearnFcatVSL-' substr '-' snum '.mat'])
cd ..



datafname = ['data/trainingLearnFcatVSL-' substr '-' runnum '.mat'];
textfname = ['data/trainingLearnFcatVSL-' substr '-' runnum '.txt'];





trainingversion = data{1,1}(1,4); %what task are we starting with? 1 = cat, 0 = nback



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


SINGLETON = 0; IMPAIR1 = 1; IMPAIR2 = 2;

% key assignment
KbName('UnifyKeyNames');

key1 = KbName('1!');
key2 = KbName('2@');
trigger = KbName('5%');
quitKeys = KbName('9(');
spaceKey = KbName('space');


HideCursor; commandwindow;


%% Begin run
if trainingversion == 1
    DrawFormattedText(w,'Starting learning scan... \nAwaiting trigger from scanner...\nRemember: LEFT button for category one \nRIGHT button for category two \n \n 5 for manual trigger \n 9 to quit \n 1 and 2 for keyboard','center','center',[255 255 255], 80, [], [], 1.5);
else
    DrawFormattedText(w,'Starting learning scan... \nAwaiting trigger from scanner...\nRemember: LEFT button for REPEATED IMAGE \nRIGHT button for NEW IMAGE \n \n 5 for manual trigger \n 9 to quit \n 1 and 2 for keyboard','center','center',[255 255 255], 80, [], [], 1.5);
end
Screen('Flip',w);
% trigger code goes here
% wait for trigger
if buttonorkey == BUTTON
    while 1
        % first check trigger from button relay
        [keyDown, keyTime, keyCodes] = KbCheck(-1);
        if keyDown
            if keyCodes(trigger)
                break;
            elseif keyCodes(quitKeys)
                save(dataYname);
                sca; ShowCursor; fclose(fp); return;
            end
        end
    end
else
    while 1
        [keyDown, keyTime, keyCodes] = KbCheck(-1);
        if keyDown
            if keyCodes(trigger)
                break;
            elseif keyCodes(quitKeys)
                save(dataYname);
                sca; ShowCursor; fclose(fp); return;
            end
        end
    end
end

% triggered time
DrawFormattedText(w,'Trigger recieved.','center','center',[255 255 255], 80, [], [], 1.5);
triggertime= Screen('Flip', w);




for block = 1:6


trainingversion = data{runcount,block}(1,4);
    



if trainingversion == 1
    DrawFormattedText(w,'CATEGORIZE \n LEFT button for category one \nRIGHT button for category two \n \n 1 and 2 for keyboard','center','center',[255 255 255], 80, [], [], 1.5);
else
    DrawFormattedText(w,'NEW OR REPEAT \n LEFT button for REPEATED IMAGE \nRIGHT button for NEW IMAGE \n \n 1 and 2 for keyboard','center','center',[255 255 255], 80, [], [], 1.5);
end
 %flip instructions on screen 9 seconds before first image of the block
Screen('Flip', w, triggertime + data{runcount,block}(1,37) - .005 - 9);

%flip fixation on screen 1 second before first image of block
Screen('FrameOval', w, fixColor, fixRect);
Screen('Flip', w, triggertime + data{runcount,block}(1,37) - .005 - 1);


for trial = 1:64
    
    
    if trainingversion == 1 %if it's cat
        corResp = data{runcount,block}(trial,2); %2) 1 = z image ; 2 = m image
    else %if it's nback
        corResp = data{runcount,block}(trial,7);%7) 1 = repeated image, 2 = non-repeated image
    end
    
    Screen('DrawTexture', w, imagetex(data{runcount,block}(trial,5)),[],imRect);
    Screen('FrameOval', w, fixColor, fixRect);
    data{runcount,block}(trial,35) = Screen('Flip', w, triggertime + data{runcount,block}(trial,37) - .005);
    imFlip = data{runcount,block}(trial,35);
    
    % check for response
    resp = -1; rt = -1; acc = 0;
    while (GetSecs - imFlip) < (imDur - .005)
        [keyDown, secs, keyCodes] = KbCheck(-1);
        if keyDown
            if keyCodes(key1)
                resp = 1;
                rt = secs - imFlip;
                acc = (corResp == resp);
                %break;
            elseif keyCodes(key2)
                resp = 2;
                rt = secs - imFlip;
                acc = (corResp == resp);
                %break;
            elseif all(keyCodes(quitKeys))
                Screen('Close', imagetex(:)); sca; return;
            end
        end
    end
    
    
    if acc
        Screen('FillOval', w, fixCorrectColor, fixRect);
    else
        Screen('FillOval', w, fixErrorColor, fixRect);
    end
    data{runcount,block}(trial,36) = Screen('Flip', w, triggertime + data{runcount,block}(trial,38) - .005);
    
%     % start blank interval
%     Screen('FrameOval', w, fixColor, fixRect);
%     fliptimes{runcountnum}(trial,3) = Screen('Flip', w, triggertime + event_times{runcountnum}(trial,3) - .005);
%     
 
%     log data
    data{runcount,block}(trial,20:22) = [acc rt resp];
    
end

end 

  data{runcount,block}(trial,36) = Screen('Flip', w, triggertime + data{runcount,block}(trial,38) - .005);
%flip the fixation on screen 1 second after last fixation
%flip the fixation on screen 1 second after last fixation
Screen('FrameOval', w, fixColor, fixRect);
WaitSecs(1)
Screen('Flip', w);

%and leave it on for 9 additional seconds
WaitSecs(9)
Screen('Flip', w);






save(datafname);



sca;


