%This file will be used for every run
clear all



%data columns:
%1) pair/sing specific identity (see spreadsheet)
%2) 1 = z image ; 2 = m image
%3) 0 = singleton ; 1 = first image of pair ; 2 = second image of pair
%4) 1 = cat task; 2 = nback task
%5) randomized image number (1 - 96)--first half are cat images
%6) Actual image number (matches up with the images' names in the folder).
%7) 1 = repeated image, 2 = non-repeated image

%10) PV offset timing jitter
%11) PV onset times
%12) PV offset times


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
runscounted = str2num(runnum);
datafname = ['data/PASSIVELearnFcatVSL-' substr '-' runnum '.mat'];
textfname = ['data/PASSIVELearnFcatVSL-' substr '-' runnum '.txt'];

runnumber = runnum;

cd data
load(['data/LearnFcatVSL-' substr '-' snum '.mat'])
cd ..
datafname = ['data/PASSIVELearnFcatVSL-' substr '-' runnumber '.mat'];

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

    DrawFormattedText(w,'\nAwaiting trigger from scanner...','center','center',[255 255 255], 80, [], [], 1.5);

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











for trial = 1:96
    
    
    
    Screen('DrawTexture', w, imagetex(PV{runscounted}(trial,5)),[],imRect);
    Screen('FrameOval', w, fixColor, fixRect);
    PV{runscounted}(trial,35) = Screen('Flip', w, triggertime + PV{runscounted}(trial,11) - .005);
    imFlip = PV{runscounted}(trial,35);
    
    Screen('FrameOval', w, fixColor, fixRect);
    PV{runscounted}(trial,36) = Screen('Flip', w, triggertime + PV{runscounted}(trial,12) - .005);
    save(datafname);

end


%flip the fixation on screen 1 second after last fixation
Screen('FrameOval', w, fixColor, fixRect);
WaitSecs(1)
Screen('Flip', w);

%and leave it on for 9 additional seconds
WaitSecs(9)
Screen('Flip', w);






save(datafname);



sca;


