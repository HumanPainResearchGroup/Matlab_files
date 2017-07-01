function eeglabcrossspec(basename)

if isunix
    filepath = '/scratch/cb802/Data/CRPS_resting/EEG';
else
    filepath = 'W:\Data\CRPS_resting\EEG';
end

EEG = pop_loadset('filename',[basename '.set'],'filepath',filepath);
load chancross;
freqlist = [0 4; 4 8; 8 13; 13 30; 30 40];

chanlocs = EEG.chanlocs;
matrix=zeros(size(freqlist,1),EEG.nbchan,EEG.nbchan); % size(freqlist,1) lines ; EEG.nbchan columns ; EEG.nbchan time this table
coh = zeros(EEG.nbchan,EEG.nbchan);
bootrep = 50;
cohboot = zeros(EEG.nbchan,EEG.nbchan);

%EEG = convertoft(EEG);
%cfg = [];
%cfg.output     = 'powandcsd';
%cfg.method     = 'mtmfft';
%cfg.foilim        = [0.1 40];
%cfg.taper = 'hanning';
% cfg.taper = 'dpss';
% cfg.tapsmofrq = 0.5;
%cfg.keeptrials = 'yes';
%cfg.precision = 'single';

EEG.data = single(EEG.data);

for cc = 1:size(chancross,1)
    chan1 = chancross{cc,1};
    chan2 = chancross{cc,2};
    chan1i = find(strcmp({chanlocs.labels},chan1));
    chan2i = find(strcmp({chanlocs.labels},chan2));
    [a,cohcc,b,c,freqsout] = ...
        evalc(['pop_newcrossf( EEG, 1, chan1i, chan2i, [EEG.xmin  EEG.xmax] * 1000, 0 ,' ...
        '''type'', ''crossspec'',''winsize'',EEG.pnts/2,''padratio'', 1,''plotamp'',''off'',''plotphase'',''off'')']);

    cros(cc,:,:) = mean(cohcc,2); % Channel x Channel x Frequency by averaging across time points in window
    cc*100/size(chancross,1)
end
cros = squeeze(mean(cros,3));

for f = 1:size(freqlist,1)
    [M, bstart] = min(abs(freqsout-freqlist(f,1)));
    [M, bend] = min(abs(freqsout-freqlist(f,2)));
    
    coh(:) = 0;
    coh(logical(tril(ones(size(coh)),-1))) = max(cros(:,bstart:bend),[],2);
    coh = tril(coh,1)+tril(coh,1)';
    matrix(f,:,:) = coh;
   
end

save(fullfile(filepath, 'eeglab_crossspec', [basename '_eeglabcrossspec.mat']),'matrix','chanlocs');
