%% ODDBALL ANALYSIS
%% Settings

clear all
close all
dbstop if error

% choose factor of interest
S.factcon = 'Odd';

S.runname = '';

% time window to create temporal region of interest, e.g. decided from
% group statistics. Should be kept broad to accomodate all subjects
S.timewin = [53 53]%[33 73]; 
% central EEG channel to create spatial region of interest on scalp, e.g. decided from
% group statistics
S.centrechan= 'E93'; 
% number of neighbours to include in spatial region
S.nbr_levels= 2; 
% masking threshold to apply to individual subject ERP contrasts         
mask_thresh=0.2; % e.g. if 0.2 = 20%



%% SPECIFY DATA

addpath('C:\Data\Matlab\fieldtrip-20170113')

% path of EEGLAB .set files after preprocessing, path of SPM outputs, and
% prefix of output files
S.data_path = 'C:\Data\CORE\Preprocessed_100Hz'; 
S.outpath = 'C:\Data\CORE\ERPs';

% prefix, middle part, or suffix of files to load (or leave empty) to select a subset of files in
% the folder
S.fpref = '';
S.fmid = '';
S.fsuff_bal = '4_cleaned_tm.set'; % use balanced data to analyse ERP contrasts
S.fsuff = '4_merged_cleaned.set'; % use unbalanced data to extract single-trials

% load .xlsx file containing 'Participant_ID', 'Group', and covariates
S.pdatfile = 'C:\Data\CORE\Participant_data.xlsx';
% names of headers in the above xls file:
    S.subhead = 'Subject';
    S.grphead = 'Group';
    S.inchead = 'Include';
% which codes to analyse in 'Include' columns in participant data file?
S.include_codes = [1];

% conditions and factors
S.conds = 1:24;
S.useconds = 1:24;
S.flipside = 2;
S.factors = {'CP', 'Side', 'Odd', 'DC'}; % oly need to label those that 
S.factlev={{};{};{'Odd','Stan'};{}}; % label those that will be analyses
S.factor_matrix = [
              1 1 1 1
              1 1 1 2
              1 1 2 1
              1 1 2 2
              1 2 1 1
              1 2 1 2
              1 2 2 1
              1 2 2 2
              2 1 1 1
              2 1 1 2
              2 1 2 1
              2 1 2 2
              2 2 1 1
              2 2 1 2
              2 2 2 1
              2 2 2 2
              3 1 1 1
              3 1 1 2
              3 1 2 1
              3 1 2 2
              3 2 1 1
              3 2 1 2
              3 2 2 1
              3 2 2 2
              ];
          

%% get timelock data

% find data
files_bal = dir(fullfile(S.data_path,[S.fpref '*' S.fmid  '*' S.fsuff_bal]));
files = dir(fullfile(S.data_path,[S.fpref '*' S.fmid  '*' S.fsuff]));
cd(S.outpath)

% CREATE FT CHANNEL LAYOUT STRUCTURE
% only need to ever run this once per experiment, and only if using ACSTP
if 0 
    % create FT channel layout
    cfglayout = 'C:\Data\Matlab\Matlab_files\CORE\cosmo\modified functions\GSN92.sfp';
    cfgoutput = 'C:\Data\Matlab\Matlab_files\CORE\cosmo\modified functions\GSN92.lay';
    cfg.layout = cfglayout;
    cfg.output = cfgoutput;
    layout = ft_prepare_layout(cfg);
    % define the neighborhood for channels
    cfg.senstype ='EEG';
    cfg.method = 'triangulation';
    cfg.elecfile=cfglayout;
    cfg.layout=cfgoutput;
    ft_nbrs = ft_prepare_neighbours(cfg);
    save(fullfile(S.outpath,'ft_nbrs.mat'), 'ft_nbrs');
end

rundir=fullfile(S.outpath,[S.runname '_timewin_' num2str(S.timewin(1)) '_' num2str(S.timewin(2)) '_centrechan_' S.centrechan '_nNeighbours_' num2str(S.nbr_levels)]);
if ~exist(rundir,'dir')
    mkdir(rundir)
end

for f = 1:length(files_bal)
    % load BALANCED data
    data=fullfile(S.data_path,files_bal(f).name);
    EEG=pop_loadset(data);
    sname = strsplit(EEG.filename,'_');
    
    % whole epoch used if timewin not specified
    if isempty(S.timewin)
        S.timewin = [EEG.xmin EEG.xmax]*1000;
    end
    
    % obtain trial indices
    [conds, tnums, fnums, bnums] = get_markers(EEG);
    
    % create flipped version for RHS stimulation trials
    if S.flipside
        EEGflip = flipchan(EEG);
        sideind = find(strcmp(S.factors,'Side'));
        flipind = find(S.factor_matrix(:,sideind)==S.flipside);
        flipcond = S.conds(flipind);
        for i = flipcond
            trialind = find(conds==i);
            EEG.data(:,:,trialind)= EEGflip.data(:,:,trialind);
        end
        clear EEGflip
    end
    
    % reduce conditions to factors of interest
    factind = find(strcmp(S.factors,S.factcon));
    condana = S.factor_matrix(S.useconds,factind);
    targ = unique(condana)';
    
    % identify target indices
    ti = nan(size(conds'));
    for i = targ
        factcon{i} = find(condana==i);
        for c = 1:length(factcon{i})
            ti(find(conds==factcon{i}(c)),1)=i;
        end
    end
    filter_cond=~any(isnan(ti),2);
    ti=ti(filter_cond,:);
    
    %% create spatio-temporal mask to apply to each subject's ERPs
    
    % spatial mask
    allchan = {EEG.chanlocs.labels};
    elec_centre = find(strcmp(S.centrechan,allchan));
    load(fullfile(S.outpath,'ft_nbrs.mat'));
    if S.nbr_levels==1
        elec = sort([elec_centre find(ismember({ft_nbrs(:).label},ft_nbrs(elec_centre).neighblabel))]);
    elseif S.nbr_levels==2
        temp = sort([elec_centre find(ismember({ft_nbrs(:).label},ft_nbrs(elec_centre).neighblabel))]);
        temp2=[];
        for e = 1:length(temp)
            temp2 = [temp2 find(ismember({ft_nbrs(:).label},ft_nbrs(temp(e)).neighblabel))];
        end
        elec = unique(temp2);
    end
    spatmask = zeros(size(EEG.data));
    spatmask(elec,:,:) = 1; 
    
    
    % temporal mask
    tempmask = zeros(size(EEG.data));
    timewin=dsearchn(EEG.times',S.timewin');
    tempmask(:,timewin(1):timewin(2),:) = 1; 

    % combine spatial and temporal
    erp_mask = tempmask .* spatmask;
    %figure
    %plot(mean(squeeze(mean(erp_mask,1)),3));
    %figure
    %topoplot(mean(squeeze(mean(erp_mask(:,timewin(1):timewin(2),:),2)),2),EEG.chanlocs)
    
    %% create ERP difference wave and baseline correct
    
    % individual waves
    for i = 1:length(targ)
        iw(:,:,targ(i)) = mean(EEG.data(:,:,ti==targ(i)),3);
    end
    
    % difference wave
    dw = iw(:,:,1)-iw(:,:,2);
    
    % plot
    %figure
    %plot(mean(iw(elec,:,1),1),'r'); hold on;
    %plot(mean(iw(elec,:,2),1),'b'); hold on;
    %plot(mean(dw(elec,:),1),'k');
    %figure
    %topoplot(mean(dw(:,timewin(1):timewin(2)),2),EEG.chanlocs)
    
    gdw(:,:,f) = dw;

end

topoplot(mean(mean(dw(:,timewin(1):timewin(2)),2),3),EEG.chanlocs)