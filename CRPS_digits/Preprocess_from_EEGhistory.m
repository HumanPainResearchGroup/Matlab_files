% 1. replicate original analysis to show this script works
% 2. need to split into left and right at the end - with a script?

clear all
if isunix
    filepath = '/scratch/cb802/Data';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath = 'W:\Data';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end
ana_path = fullfile(filepath,'CRPS_Digit_Perception');
raw_path = fullfile(filepath,'CRPS_raw');
cd(raw_path);
files = dir('*orig.set');

for f = 20%1:length(files)
    
    orig_file = files(f).name;
    [pth nme ext] = fileparts(orig_file); 
    C = strsplit(nme,'_');
    
    cd(ana_path)
    files_ana = dir('*.set');
    
    for fa = 1:length(files_ana)
    
        if strfind(files_ana(fa).name,'flip'); continue;
        elseif ~isempty(strfind(files_ana(fa).name,C{1})) && ~isempty(strfind(files_ana(fa).name,'Left'))
             EEGl = pop_loadset(files_ana(fa).name,ana_path);
            EEGl.filename = strrep(EEGl.filename, '.left', '_left');
            EEGl.filename = strrep(EEGl.filename, '.Left', '_left');
            EEGl.filename = strrep(EEGl.filename, '.right', '_right');
            EEGl.filename = strrep(EEGl.filename, '.Right', '_right');
            EEGl.filename = strrep(EEGl.filename, '.flip', '_flip');
            EEGl.filename = strrep(EEGl.filename, '.Flip', '_flip');
            EEGl.filename = strrep(EEGl.filename, '.aff', '_aff');
            EEGl.filename = strrep(EEGl.filename, '.Aff', '_aff');
            EEGl.filename = strrep(EEGl.filename, '.Unaff', '_unaff');
            EEGl.filename = strrep(EEGl.filename, '.unaff', '_unaff');
            EEGl.filename = strrep(EEGl.filename, '_Left', '_left');
            EEGl.filename = strrep(EEGl.filename, '_Right', '_right');
            EEGl.filename = strrep(EEGl.filename, '_Flip', '_flip');
            EEGl.filename = strrep(EEGl.filename, '_Aff', '_aff');
            EEGl.filename = strrep(EEGl.filename, '_Unaff', '_unaff');
            EEGl.filename = strrep(EEGl.filename, '.Exp1', '_Exp1');
        elseif ~isempty(strfind(files_ana(fa).name,C{1})) && ~isempty(strfind(files_ana(fa).name,'Right'))
             EEGr = pop_loadset(files_ana(fa).name,ana_path);
            EEGr.filename = strrep(EEGr.filename, '.left', '_left');
            EEGr.filename = strrep(EEGr.filename, '.Left', '_left');
            EEGr.filename = strrep(EEGr.filename, '.right', '_right');
            EEGr.filename = strrep(EEGr.filename, '.Right', '_right');
            EEGr.filename = strrep(EEGr.filename, '.flip', '_flip');
            EEGr.filename = strrep(EEGr.filename, '.Flip', '_flip');
            EEGr.filename = strrep(EEGr.filename, '.aff', '_aff');
            EEGr.filename = strrep(EEGr.filename, '.Aff', '_aff');
            EEGr.filename = strrep(EEGr.filename, '.Unaff', '_unaff');
            EEGr.filename = strrep(EEGr.filename, '.unaff', '_unaff');
            EEGr.filename = strrep(EEGr.filename, '_Left', '_left');
            EEGr.filename = strrep(EEGr.filename, '_Right', '_right');
            EEGr.filename = strrep(EEGr.filename, '_Flip', '_flip');
            EEGr.filename = strrep(EEGr.filename, '_Aff', '_aff');
            EEGr.filename = strrep(EEGr.filename, '_Unaff', '_unaff');
            EEGr.filename = strrep(EEGr.filename, '.Exp1', '_Exp1');
        end
    end
    
    
   
    
    hist = EEGl.history;
    hist = strrep(hist,'C:\\EEGdata\\', raw_path);
    hist = strrep(hist,'C:\\Documents and Settings\\cb802\\My Documents\\MATLAB\\Data\\CRPS Digit Perception\\', raw_path);
    hist = strrep(hist,'pop_eegfilt( EEG, 0, 30', 'pop_eegfilt( EEG, 0, 30');
    %x = regexp(hist,'([^;]*)','tokens');
    %x = [x{:}];
    %y = strfind(x,'loadset');
    %y = find(~cellfun(@isempty,y));
    %s = x(y);
    %s = unique(s);
    %for i = 1:length(s)
    %    st = s{i};
    %    stn = strrep(st,'loadset','saveset');
    %    stn = strrep(stn,'pop_saveset(','pop_saveset(EEG,');
    %    hist = strrep(hist,st,[stn ';' st]);
    %end
    hist = regexp(hist,'([^;]*)','tokens');
    hist = [hist{:}];
    %hist = hist(2:end)';
    
    final_save=0;
    EEG = pop_loadset('filename',orig_file,'filepath',raw_path);
    for h = 1:length(hist)
        if ~isempty(strfind(hist{h},'pop_eegplot')) ||  ~isempty(strfind(hist{h},'pop_selectcomps')) ||  ~isempty(strfind(hist{h},'eeg_checkset')) || ~isempty(strfind(hist{h},'timtopo')) || ~isempty(strfind(hist{h},'figure')) 
            continue
        elseif ~isempty(strfind(hist{h},'left')) ||  ~isempty(strfind(hist{h},'Left')) ||  ~isempty(strfind(hist{h},'right')) || ~isempty(strfind(hist{h},'Right'))
            continue
        elseif ~isempty(strfind(hist{h},'rejepoch'))
            continue
        elseif ~isempty(strfind(hist{h},'loadset')) || ~isempty(strfind(hist{h},'saveset'))
            continue
        elseif ~isempty(strfind(hist{h},'pop_repchan'))
            rejc = regexp(hist{h},'\[(.*?)\]','tokens');
            rejc = rejc{:};
            hist{h} = ['EEG = eeg_interp(EEG,[' rejc{:} '], ''spherical'' );'];
            eval(hist{h});
        elseif ~isempty(strfind(hist{h},'pop_runica')) || ~isempty(strfind(hist{h},'pop_subcomp'))
            continue
        else
            eval(hist{h});
        end
        %if ~isempty(strfind(hist{h},'save'))
        %    clear EEG ALLEEG
        %end
        %if ~isempty(strfind(hist{h},'RefAvg'))
        %    final_save==1;
        %end
    end
   %if final_save==0
       sname = [C{1} '_HLFilt.Exp2.epoch.clean.ICA.pruned.spline.RefAvg.set'];
       EEG = pop_saveset(EEG,'filename',sname,'filepath',raw_path);
   %end
   
   allE = [EEG.epoch.eventinit_index];
   keptEl = [EEGl.epoch.eventinit_index];
   keptEr = [EEGr.epoch.eventinit_index];
   keptE = sort([keptEl keptEr]);
   [inE iall ikept] = intersect(allE,keptE);
   EEG = pop_select(EEG,'trial',iall);
   
   EEG12=EEG;
   selectfnum =1:5;
   part2analysis;
   EEG2l=EEG;
   
   EEG=EEG12;
   selectfnum =6:10;
   part2analysis;
   EEG2r=EEG;
   
   
   ICAw = EEGl.etc.icaweights_beforerms;
   ICAs = EEGl.etc.icasphere_beforerms;
   dataL = reshape(EEGl.data,EEGl.nbchan,EEGl.trials*EEGl.pnts);
   ICAactL = (ICAw*ICAs)*dataL(EEGl.icachansind,:);
   
   ICAw = EEGr.etc.icaweights_beforerms;
   ICAs = EEGr.etc.icasphere_beforerms;
   dataR = reshape(EEGr.data,EEGr.nbchan,EEGr.trials*EEGr.pnts);
   ICAactR = (ICAw*ICAs)*dataR(EEGr.icachansind,:);
   
   
   EEG2l = pop_runica(EEG2l, 'extended',1,'interupt','on');
   EEG2r = pop_runica(EEG2r, 'extended',1,'interupt','on');
   
   icaweights = EEG2l.etc.icaweights_beforerms;
   icasphere = EEG2l.etc.icasphere_beforerms;
   data2l = reshape(EEG2l.data,EEG2l.nbchan,EEG2l.trials*EEG2l.pnts);
   icaactL = (icaweights*icasphere)*data2l(EEG2l.icachansind,:);
   
   icaweights = EEG2r.etc.icaweights_beforerms;
   icasphere = EEG2r.etc.icasphere_beforerms;
   data2r = reshape(EEG2r.data,EEG2r.nbchan,EEG2r.trials*EEG2r.pnts);
   icaactR = (icaweights*icasphere)*data2r(EEG2r.icachansind,:);
   
   cormat = [];
   nComp = size(ICAact,1);
   thresh=[-inf 0.08 0.1 0.12 0.14];
   datcorsL=[];
   datcorsR=[];
   for t=1:length(thresh)
       %cor2=nan(2,nComp);cor3=nan(3,nComp);cor4=nan(4,nComp);cor5=nan(5,nComp);
       corall=nan(EEG2l.nbchan,nComp);
       for i = 1:nComp
           cormat(:,i) = corr(ICAactR(i,:)',icaactR');
           [m ix] = sort(cormat(:,i),'descend');
           %cor2(1:length(find(m(1:2)>thresh)),i) = ix(find(m(1:2)>thresh));
           %cor3(1:length(find(m(1:3)>thresh)),i) = ix(find(m(1:3)>thresh));
           %cor4(1:length(find(m(1:4)>thresh)),i) = ix(find(m(1:4)>thresh));
           %cor5(1:length(find(m(1:5)>thresh)),i) = ix(find(m(1:5)>thresh));
           corall(1:length(find(m(:)>thresh(t))),i) = ix(find(m(:)>thresh(t)));
       end
       %[m maxcor] = max(cormat);
       %maxcor = sort(maxcor);
       %length(unique(cor2(~isnan(cor2))))
       %length(unique(cor3(~isnan(cor3))))
       %length(unique(cor4(~isnan(cor4))))
       %length(unique(cor5(~isnan(cor5))))
       retain=sort(unique(corall(~isnan(corall))));
       length(retain)

       rej = 1:size(icaact,1);
       rej(retain)=[];
       EEG2l_t = pop_subcomp( EEG2l, rej, 0);
       EEG2r_t = pop_subcomp( EEG2r, rej, 0);
       
       dataL = reshape(EEGl.data,EEGl.nbchan,EEGl.trials*EEGl.pnts);
       dataR = reshape(EEGr.data,EEGr.nbchan,EEGr.trials*EEGr.pnts);
       dataLn = reshape(EEG2l_t.data,EEG2l_t.nbchan,EEG2l_t.trials*EEG2l_t.pnts);
       dataRn = reshape(EEG2r_t.data,EEG2r_t.nbchan,EEG2r_t.trials*EEG2r_t.pnts);
       
       datcorL=[];
       datcorR=[];
       for i=1:EEGl.nbchan
           datcorL(i) = corr(dataL(i,:)',dataLn(i,:)');
           datcorR(i) = corr(dataR(i,:)',dataRn(i,:)');
       end
       datcorsL(t) = mean(datcorL)
       datcorsR(t) = mean(datcorR)
       
   end
   
   
end
