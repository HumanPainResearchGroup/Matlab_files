clear all
loadpaths
%filepath = 'W:\Data\CRPS_resting\EEG';
removechan
typerange = {'RHAN','LHAN','BELB','RELX'};
%typerange = {'RHAN_subcomp','LHAN_subcomp','BELB_subcomp','RELX_subcomp'};
typerange_lim = {[0 30],[0 30],[0 30],[0 30]};
epoch_dur = 4;
files = dir(fullfile(filepath,'*100Hz.Exp3.set'));
hicutoff = 45;

for f = 25%:length(files)
    filename = files(f).name;
    EEG = pop_loadset('filename',filename,'filepath',filepath);
    filtorder = 6*fix(EEG.srate/hicutoff);
    %EEG = pop_eegfilt(EEG,0,hicutoff,filtorder,0,0,0,'fir1',0);
    %EEG = pop_eegfilt(EEG,45,55,filtorder,1,0,0,'fir1',0); %Notch
    %EEG = pop_eegfilt(EEG,0,45,0,0);
    EEG = pop_eegfilt(EEG,45,55,filtorder,1);
    EEG = pop_eegfilt(EEG,0,45,filtorder,0);
    chanlocs = EEG.chanlocs;
    chans = struct2cell(chanlocs);
    chans = squeeze(chans(1,1,:));
    rchan = remchan{find(ismember(remchan(:,1),filename(1:3))),2};
    for r = 1:length(rchan)
        rchan_ind(r) = find(ismember(chans,rchan(r)));
    end
    EEG = pop_select(EEG, 'nochannel', rchan_ind);
    EEG = pop_interp(EEG, eeg_mergelocs(chanlocs), 'spherical');
    TOTEEG = EEG;
    clear EEG
    
    for e = 1:length(typerange)
        EEG = pop_epoch(TOTEEG, typerange(e),typerange_lim{e});
        EEG = eeg_epoch2continuous(EEG);
        EEG = segment_eeg(EEG,epoch_dur);
        EEG = pop_epoch(EEG, {'M'},[0 epoch_dur]);
        EEG = pop_rmbase(EEG,[],[]); % remove baseline
        ALLEEG(e) = EEG;
        %pop_saveset(EEG, efilename, filepath);
    end
    
    %ALLEEG = pop_runica(ALLEEG,'icatype','jader','concatenate','on','options',{35});
    ALLEEG = pop_runica(ALLEEG,'icatype','runica','concatenate','on');
    
    for e = 1:length(typerange)
        [pth nme ext] = fileparts(filename);
        efilename = [nme '_' typerange{e} ext];
        pop_saveset(ALLEEG(e), efilename, filepath);
    end
    
    clear TOTEEG EEG ALLEEG
end

