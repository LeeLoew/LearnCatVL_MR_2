%passive viewing!!!
%Creating EV files....

%data columns:
%1) pair/sing specific identity (see spreadsheet)
%2) 1 = z image ; 2 = m image
%3) 0 = singleton ; 1 = first image of pair ; 2 = second image of pair
%4) 1 = cat task; 0 = nback task
%5) randomized image number (1 - 96)--first half are cat images
%6) Actual image number (matches up with the images' names in the folder).
%7) 1 = repeated image, 2 = non-repeated image

%10) PV offset timing jitter
%11) PV onset times
%12) PV offset times



for SUBNUMM = 26 %subjno
    for RUNNUMM = 1:4 %runnum
        
        one_cat_same = [];
        one_cat_dif = [];
        one_nback_same = [];
        one_nback_dif = [];
        two_cat_same = [];
        two_cat_dif = [];
        two_nback_same = [];
        two_nback_dif = [];
        sing_cat = [];
        sing_nback = [];
        
        load(['PASSIVELearnFcatVSL-' num2str(SUBNUMM) '-' num2str(RUNNUMM) '.mat'])
        
        for trial = 1:96   
            if PV{RUNNUMM}(trial,3) == 0 %if it's a singleton
                if PV{RUNNUMM}(trial,4) == 1 %if it's a cat image
                    sing_cat(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                elseif PV{RUNNUMM}(trial,4) == 0 %if it's a nback image
                    sing_nback(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                end         
            elseif PV{RUNNUMM}(trial,3) == 1 %if it's the first image of a pair        
                if PV{RUNNUMM}(trial,4) == 1 %if it's a cat image
                    if PV{RUNNUMM}(trial,2) == PV{RUNNUMM}(trial+1,2) %if it's the same category as the 2nd image
                        one_cat_same(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    else %if it's a different category
                        one_cat_dif(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    end          
                elseif PV{RUNNUMM}(trial,4) == 0 %if it's a nback image
                    if PV{RUNNUMM}(trial,2) == PV{RUNNUMM}(trial+1,2) %if it's the same category as the 2nd image
                        one_nback_same(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    else %if it's a different category
                        one_nback_dif(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    end
                end        
            elseif  PV{RUNNUMM}(trial,3) == 2 %if it's the second image of a pair            
                if PV{RUNNUMM}(trial,4) == 1 %if it's a cat image
                    if PV{RUNNUMM}(trial,2) == PV{RUNNUMM}(trial-1,2) %if it's the same category as the 1st image
                        two_cat_same(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    else %if it's a different category
                        two_cat_dif(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    end      
                elseif PV{RUNNUMM}(trial,4) == 0 %if it's a nback image
                    if PV{RUNNUMM}(trial,2) == PV{RUNNUMM}(trial-1,2) %if it's the same category as the 1st image
                        two_nback_same(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    else %if it's a different category
                        two_nback_dif(end+1,1:3) = [PV{RUNNUMM}(trial,11) 1 1];
                    end
                end
            end
        end
        
        cd ..
        if RUNNUMM == 1
        mkdir(['sub' num2str(SUBNUMM) 'evs'])
        end
        
        cd (['sub' num2str(SUBNUMM) 'evs'])
        mkdir(['evpv' num2str(RUNNUMM)])
        cd (['evpv' num2str(RUNNUMM)])
        dlmwrite('one_cat_same',one_cat_same,'delimiter',' ');
        dlmwrite('one_cat_dif',one_cat_dif,'delimiter',' ');
        dlmwrite('one_nback_same',one_nback_same,'delimiter',' ');
        dlmwrite('one_nback_dif',one_nback_dif,'delimiter',' ');
        dlmwrite('two_cat_same',two_cat_same,'delimiter',' ');
        dlmwrite('two_cat_dif',two_cat_dif,'delimiter',' ');
        dlmwrite('two_nback_same',two_nback_same,'delimiter',' ');
        dlmwrite('two_nback_dif',two_nback_dif,'delimiter',' ');
        dlmwrite('sing_cat',sing_cat,'delimiter',' ');
        dlmwrite('sing_nback',sing_nback,'delimiter',' ');
        cd ..
        cd ..
        cd passiveviewing\
        
        
    end
end


% dlmwrite('one_cat_same',one_cat_same,'delimiter',' ');
% dlmwrite('one_cat_dif',one_cat_dif,'delimiter',' ');
% dlmwrite('one_nback_same',one_nback_same,'delimiter',' ');
% dlmwrite('one_nback_dif',one_nback_dif,'delimiter',' ');
% dlmwrite('two_cat_same',two_cat_same,'delimiter',' ');
% dlmwrite('two_cat_dif',two_cat_dif,'delimiter',' ');
% dlmwrite('two_nback_same',two_nback_same,'delimiter',' ');
% dlmwrite('two_nback_dif',two_nback_dif,'delimiter',' ');
% dlmwrite('sing_cat',sing_cat,'delimiter',' ');
% dlmwrite('sing_cat',sing_cat,'delimiter',' ');




