%Analyze Behavioral Test Data
%import TESTLearnFcatVSL data
%columns:
%1) First target image (ID from imagetex, will be 1:32 for cat images or
%   49:80 for nback images in all cases)
%2) First target image pair ID (matches column 4)
%3) Second target image (imagetex)
%4) Second target image pair ID (matches column 2)
%5) First foil image (imagetex)
%6) First foil image pair ID (does NOT match 8)
%7) Second foil image (imagetex)
%8) Second foil image pair Id (does NOT match 6)
%9) Which pair was the target pair; 1 = first pair, 2 = 2nd pair
%10) Response; 1 = first pair, 2 = 2nd pair
%11) ACC; 1 = correct, 0 = incorrect
%12) RT
%13) target pairs 1 = cat, 2 = nback
%14) same-response catgeory = 1; dif response catgegroy = 2; nback = 0


%notes:
%Each target/foil pair appears twice during testing...Once where the target
%appears first and once where the foil appears first.




  a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; catRT = []; samerespRT = []; difrespRT = []; nbackRT = [];
for n =  1:length(FrameLog)
    
    %first compute whether the target pair is cat or nback
    if FrameLog(n,1) < 33
        FrameLog(n,13) = 1; %it's a cat trial
        if FrameLog(n,1) > 24 || FrameLog(n,1) < 9 %if it's a same-response category
            FrameLog(n,14) = 1;
        elseif FrameLog(n,1) < 25 || FrameLog(n,1) > 8 %if it's a different-response catgeory
            FrameLog(n,14) = 2;
            
        end
    elseif FrameLog(n,1) > 48
        FrameLog(n,13) = 2; %it's an nback trial
        FrameLog(n,14) = 0;
    end
    
    if FrameLog(n,11) == 1 %if they got it correct
        e = e+1; %sanity check
        if FrameLog(n,13) == 1 %if it was a cat trial
            a = a + 1;
            catRT(length(catRT)+1) = FrameLog(n,12);
            if FrameLog(n,14) == 1 %if it's a same-response catgeory
                b = b + 1;
                samerespRT(length(samerespRT)+1) = FrameLog(n,12);
            elseif FrameLog(n,14) == 2 %if it's a different response catgeory
                c = c + 1;
                difrespRT(length(difrespRT)+1) = FrameLog(n,12);
            end
        elseif FrameLog(n,13) == 2 %if it was an nback trial
            d = d + 1;
            nbackRT(length(nbackRT)+1) = FrameLog(n,12);
        end
    elseif FrameLog(n,11) == 0 %if incorrect
        f = f+1; %sanity check
        if FrameLog(n,13) == 1 %if it was a cat trial
            catRT(length(catRT)+1) = FrameLog(n,12);
            if FrameLog(n,14) == 1 %if it's a same-response catgeory
                samerespRT(length(samerespRT)+1) = FrameLog(n,12);
            elseif FrameLog(n,14) == 2 %if it's a different response catgeory
                difrespRT(length(difrespRT)+1) = FrameLog(n,12);
            end
        elseif FrameLog(n,13) == 2 %if it was an nback trial
            nbackRT(length(nbackRT)+1) = FrameLog(n,12);
        end
    end
    
    
    
end
a = a/32;
b = b/16;
c = c/16;
d = d/32;
catRT = mean(catRT);
samerespRT = mean(samerespRT);
difrespRT = mean(difrespRT);
nbackRT = mean(nbackRT);

    xyz(i,:) = [sid a b c d catRT samerespRT difrespRT nbackRT]
% % % %   check = num2str(e+f);
% % % %  [check  '=64? everything is good'] %sanity chck
i = i+1;
 
 