clear all;
cd('W:\Data\CRPS_Digit_Perception\Results\SPM sensor stats\Regression - indCond\flipped\Acc\subject effect');
load cov
clear fnames;
grplist = [33 34 31 32]; %unflipped
%grplist = [35 36 37 38]; %unflipped
%grplist = [1 2 29 30]; 
%grplist = [39 40 41 42]; %unflipped
%grplist = [41]; %unflipped
no_cond = 5;
epeaks = [1];
no_peaks = length(epeaks);

use_flipped = 1;
cdir = pwd;

if isunix
    filepath = '/scratch/cb802/Data/CRPS_Digit_Perception/SPM image files/Sensorspace_images';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath = 'W:\Data\CRPS_Digit_Perception\SPM image files\Sensorspace_images';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end

subjects = subjlists(grplist);

%cd(filepath)
%grplist = [33 34 31 32]; %unflipped



Ns=0;
subjnmes = cell(1,1);
for s = 1:length(subjects)
    for s2 = 1:length(subjects{s,1}) 
        Ns=Ns+1;
        tmp_nme = subjects{s,1}{s2,1};
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
        
        %tmp_nme = strrep(tmp_nme, 'left', 'left_meansub');
        %tmp_nme = strrep(tmp_nme, 'right', 'right_meansub');
        
        Cs = strsplit(tmp_nme,'_');
         subjnme = Cs{1};
         subjnmes{Ns,1} = subjnme;

         if ~exist(subjnme,'dir')
             mkdir(subjnme);
              copyfile('job_template.mat',fullfile(pwd,subjnme,'job.mat'));
         end
        

        %tmp_nme = ['maspm8_' tmp_nme];
        
        %if strfind(tmp_nme, 'left')
        %    trials = [1:5];
        %elseif strfind(tmp_nme, 'right')
        %    trials = [6:10];
        %end
            
        %for i = 1:no_cond
        %    for j = 1:no_peaks
        %        ind = (Ns-1)*no_cond*no_peaks + (j-1)*no_cond + i;
        %        if use_flipped==1
        %            if strfind(tmp_nme, 'right')
        %                nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*flip_reorient.img'));
        %            else
        %                nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
        %            end
        %        else
        %            nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
        %        end
        %        fnames{ind,1} = fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],nme(1).name);
        %    end
        %end
        
        if use_flipped==1
            if strfind(tmp_nme, 'left')
                tmp_nme = ['maspm8_' tmp_nme];
                trials = [1:5];
            elseif strfind(tmp_nme, 'right')
                tmp_nme = ['maspm8_' tmp_nme];
                trials = [6:10];
            end
        else
            tmp_nme = ['maspm8_' tmp_nme];
        end
            
        for i = 1:no_cond
            for j = 1:no_peaks
                ind = (Ns-1)*no_cond*no_peaks + (j-1)*no_cond + i;
                if strfind(tmp_nme,'right') 
                    nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*flip_reorient.img'));
                else
                    nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
                end
                fnames{ind,1} = fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],nme(1).name);
            end
        end
    end
end

subjnmes = unique(subjnmes);
for s = 1:length(subjnmes)
    if isempty(cov)
        errordlg('cov cannot be empty');
    end
    %C = [C{:}];   % [EDITED] Most likely this is not useful
    IndexC = strfind(fnames, subjnmes{s});
    Index = find(not(cellfun('isempty', IndexC)));
    cd(fullfile(cdir,subjnmes{s}));
    load job.mat
    matlabbatch{1,1}.spm.stats.factorial_design.dir = {pwd};
    matlabbatch{1,1}.spm.stats.factorial_design.des.mreg.scans = fnames(Index);
    matlabbatch{1,1}.spm.stats.factorial_design.des.mreg.mcov.c = cov(Index);
    save job.mat matlabbatch
    
    spm('defaults','eeg');
    spm_jobman('initcfg');
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(pwd,'spm.mat')};
    spm_jobman('run',matlabbatch);
end
 
for s = 1:length(subjnmes)
    cd(fullfile(cdir,subjnmes{s}));
    load(fullfile(cdir,'job_contrast_template.mat'));
    spm('defaults','eeg');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.stats.con.spmmat = {fullfile(pwd,'spm.mat')};
    spm_jobman('run',matlabbatch);
end

fnmes = cell(1,1);
cons = {'con_0001.img'};
nf = 0;
for s = 1:length(subjnmes)
    for c = 1:length(cons)
        nf = nf+1;
        fnmes{nf,1} = fullfile(cdir,subjnmes{s},cons{c});
    end
end
cd(cdir);
load('job.mat');
matlabbatch{1,1}.spm.stats.factorial_design.dir = {pwd};
matlabbatch{1,1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans = fnmes;
save job.mat matlabbatch
spm('defaults','eeg');
spm_jobman('initcfg');
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(pwd,'spm.mat')};
spm_jobman('run',matlabbatch);
load(fullfile(cdir,'job_grpcontrast_template.mat'));
matlabbatch{1}.spm.stats.con.spmmat = {fullfile(pwd,'spm.mat')};
spm_jobman('run',matlabbatch);


