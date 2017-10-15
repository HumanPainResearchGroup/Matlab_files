function SW_connectivity_results(S)

% PREREQUISITES: 
% - An SPM.mat file containing a contrast on source-space ERP data 
% - Associated cluster data created from "Extract_clusters_source.m"

%% Requires input structure S containing fields as follows. See Cluster_processing script for examples.
%-------------------------------------------------------------
% S.data_path: root directory in which subject-specific folders are located
% S.spmstats_path: directory in which SPM analysis is saved 
% S.spm_dir: specific folder containing the SPM stats for this analysis
% S.contrasts: contrast name cell array - must match that in Matlabbatch (i.e. from design-batch script). Leave empty to proccess ALL contrasts in Matlabbatch
% S.clus_path: cell array of full paths to clusters to be analysed
%generic cluster data name
gdataname = 'cluster_data*.mat';
contypes = {'partialCorrelationRegularized','partialCorrelation','correlation'};
ptype = 'FDRp';

%% run

if isempty(S.spm_dir)
    S.spm_paths = dir(fullfile(S.spmstats_path,'*spm*'));
    S.spm_paths = {S.spm_paths(:).name};
elseif ~iscell(S.spm_dir)
    S.spm_paths = {S.spm_dir};
else
    S.spm_paths = S.spm_dir;
end

% For each analysis (time window)
last_tw=0;
for sp = 1:size(S.spm_paths,1)
    S.spm_path = fullfile(S.spmstats_path,S.spm_paths{sp,1});
    
    % run analysis on combined clusters?
    if strcmp(S.gclusname,'comb_clus.nii')
        anapath = fullfile(S.spmstats_path,['Timewin_' num2str(S.spm_paths{sp,2})]);
        S.contrasts = {'Combined'};
        % continue if this timewindow was just analysis
        if last_tw==S.spm_paths{sp,2}
            continue
        end
        last_tw = S.spm_paths{sp,2};
    else
        anapath = S.spm_path;
    end
    
    S.clus_path={};
    if isempty(S.contrasts)
        alldir=dir(fullfile(anapath,'*_clusters'));
        for c = 1:length(alldir)
            S.clus_path{c} = fullfile(anapath,alldir(c).name);
        end
    else
        for c = 1:length(S.contrasts)
            S.clus_path{c} = fullfile(anapath,[S.contrasts{c} '_clusters']);
        end
    end

    % For each contrast
    for cldir = 1:length(S.clus_path)
        S.cldir=cldir;

        cdata = dir(fullfile(S.clus_path{cldir},gdataname));

        % For each cluster
        for c = 1:length(cdata)
            disp(['*** Cluster = ' num2str(c) ' / ' num2str(length(cdata))])

            [~,cname,~] = fileparts(cdata(c).name);

            % load
            Sc = load(fullfile(S.clus_path{cldir},cdata(c).name));
            
            % update S with data from Sc
            f = fieldnames(Sc.S);
            for i = 1:length(f)
                if ~isfield(S,f{i})
                    S.(f{i}) = Sc.S.(f{i});
                end
            end
            
            % Get cluster names
            fnames = fieldnames(S.wf);
            
            % only analyse first one for now
            cmats = S.wf.(fnames{1}).correlationMats;
            
            % for each frequency
            nFreq = length(cMats);
            for ifreq = 1:nFreq
                % for each connectivity type
                nconn = length(contypes);
                for ct = 1:nconn
                    val = cmats{iFreq}.groupLevel.(contype{ct}).(ptype);
                    tv = cmats{iFreq}.groupLevel.(contype{ct}).T;
                    pu = cmats{iFreq}.groupLevel.(contype{ct}).p;
                    fdr = cmats{iFreq}.groupLevel.(contype{ct}).FDRp;
                    fwe = cmats{iFreq}.groupLevel.(contype{ct}).FWEp;
                    
                    % find significant p values
                    % identify connected ROIs and direction of the effect
                    % (i.e. for which condition it is stronger)
                    [r1,r2,pn] = ind2sub(size(val),find(val<0.05));
                    roi1 = [roi1 r1];
                    roi2 = [roi2 r2];
                    posneg = [posneg pn];
                    tval = [tval tv(r1,r2,pn)];
                    pval = [pval pu(r1,r2,pn)];
                    fweval = [fweval fwe(r1,r2,pn)];
                    fdrval = [fdrval fdr(r1,r2,pn)];
                end
            end
            
        end
           
    end
end

% save as excel
results = Table(roi1,roi2,posneg,tval,pval,fweval,fdrval);
next = datestr(now,30);
fname = fullfile(S.spmstats_path,['Connectivity_run_' next]);
xlswrite(fname,results);
