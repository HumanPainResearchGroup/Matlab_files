clear all;
%grplist = [1 2 29 30]; %flipped
%clear fnames;
grplist2 = [33 34 31 32]; %unflipped Exp2
%grplist = [35 37 36 38]; %unflipped
grplist1 = [39 40 41 42]; %unflipped Exp1
%grplist = [47:50];
%grplist = [41]; %unflipped
no_cond = 5;
epeaks = [1];
no_peaks = length(epeaks);
use_flipped=1;
cdir = pwd;

if isunix
    filepath1 = '/scratch/cb802/Data/CRPS_Digit_Perception_exp1/SPM image files/Sensorspace_images';
    filepath2 = '/scratch/cb802/Data/CRPS_Digit_Perception/SPM image files/Sensorspace_images';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath1 = 'W:\Data\CRPS_Digit_Perception_exp1\SPM image files\Sensorspace_images';
    filepath2 = 'W:\Data\CRPS_Digit_Perception\SPM image files\Sensorspace_images';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end

subjects1 = subjlists(grplist1);
subjects2 = subjlists(grplist2);

cd(filepath1)

Ns=0;
for s = 1:length(subjects1)
    for s2 = 1:length(subjects1{s,1}) 
        Ns=Ns+1;
        tmp_nme = subjects1{s,1}{s2,1};
        tmp_nme = strrep(tmp_nme, '.left', '_left');
        tmp_nme = strrep(tmp_nme, '.Left', '_left');
        tmp_nme = strrep(tmp_nme, '.right', '_right');
        tmp_nme = strrep(tmp_nme, '.Right', '_right');
        tmp_nme = strrep(tmp_nme, '.flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '_Left', '_left');
        tmp_nme = strrep(tmp_nme, '_Right', '_right');
        tmp_nme = strrep(tmp_nme, '_Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '_Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '_Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.Exp1', '_Exp1');
       
        
        tmp_nme = ['maspm8_' tmp_nme];
        
        if strfind(tmp_nme, 'left')
            trials = [1:5];
        elseif strfind(tmp_nme, 'right')
            trials = [6:10];
        end
            
        for i = 1:no_cond
            for j = 1:no_peaks
                ind = (Ns-1)*no_cond*no_peaks + (j-1)*no_cond + i;
                if use_flipped==1
                    if strfind(tmp_nme, 'right')
                        nme = dir(fullfile(filepath1,tmp_nme,['type_' num2str(trials(i))],'strial*flip_reorient.img'));
                    else
                        nme = dir(fullfile(filepath1,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
                    end
                else
                    nme = dir(fullfile(filepath1,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
                end
                fnames1{ind,1} = fullfile(filepath1,tmp_nme,['type_' num2str(trials(i))],nme(1).name);
            end
        end
    end
end

Ns=0;
for s = 1:length(subjects2)
    for s2 = 1:length(subjects2{s,1}) 
        Ns=Ns+1;
        tmp_nme = subjects2{s,1}{s2,1};
        tmp_nme = strrep(tmp_nme, '.left', '_left');
        tmp_nme = strrep(tmp_nme, '.Left', '_left');
        tmp_nme = strrep(tmp_nme, '.right', '_right');
        tmp_nme = strrep(tmp_nme, '.Right', '_right');
        tmp_nme = strrep(tmp_nme, '.flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '_Left', '_left');
        tmp_nme = strrep(tmp_nme, '_Right', '_right');
        tmp_nme = strrep(tmp_nme, '_Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '_Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '_Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.Exp1', '_Exp1');
       
        
        tmp_nme = ['maspm8_' tmp_nme];
        
        if strfind(tmp_nme, 'left')
            trials = [1:5];
        elseif strfind(tmp_nme, 'right')
            trials = [6:10];
        end
            
        for i = 1:no_cond
            for j = 1:no_peaks
                ind = (Ns-1)*no_cond*no_peaks + (j-1)*no_cond + i;
                if use_flipped==1
                    if strfind(tmp_nme, 'right')
                        nme = dir(fullfile(filepath2,tmp_nme,['type_' num2str(trials(i))],'strial*flip_reorient.img'));
                    else
                        nme = dir(fullfile(filepath2,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
                    end
                else
                    nme = dir(fullfile(filepath2,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
                end
                fnames2{ind,1} = fullfile(filepath2,tmp_nme,['type_' num2str(trials(i))],nme(1).name);
            end
        end
    end
end

Ns=0;
for s = 1:length(subjects1)
    for s2 = 1:length(subjects1{s,1}) 
        Ns=Ns+1;
        tmp_nme = subjects1{s,1}{s2,1};
        tmp_nme = strrep(tmp_nme, '.left', '_left');
        tmp_nme = strrep(tmp_nme, '.Left', '_left');
        tmp_nme = strrep(tmp_nme, '.right', '_right');
        tmp_nme = strrep(tmp_nme, '.Right', '_right');
        tmp_nme = strrep(tmp_nme, '.flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '_Left', '_left');
        tmp_nme = strrep(tmp_nme, '_Right', '_right');
        tmp_nme = strrep(tmp_nme, '_Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '_Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '_Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.Exp1', '_Exp1');
      
        tmp_nme = ['maspm8_' tmp_nme];
        
        if strfind(tmp_nme, 'left')
            trials = [1:5];
        elseif strfind(tmp_nme, 'right')
            trials = [6:10];
        end
            
        for i = 1:no_cond
            for j = 1:no_peaks
                ind = (Ns-1)*no_cond*no_peaks + (j-1)*no_cond + i;
                nme_save = strrep(fnames1{ind}, '.img', '_Exp1-Exp2.img');
                innames = {fnames1{ind}; fnames2{ind}};
                Output = spm_imcalc_ui(innames,[nme_save],'i1-i2');
            end
        end 
    end
end
    