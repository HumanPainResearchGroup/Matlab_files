
% seelcted participants for the analysis
nsubjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'OA1', 'OA2', 'OA4', 'OA5', 'OA6', 'OA7', 'OA8', 'OA9', 'OA10', 'OA11', 'OA12', 'OA13'};


for x=1:length(nsubjects)

    ns=nsubjects(x);
    ns = char(ns);

total_data=[];
stim_matrix=[];


% for subject check how many blocks do we have
s=[ns '_125.cnt'];

% select all blocks of participant x
files=dir(s);

for f=1:length(files)  % for number of blocks of this person

    filename = files(f).name;
    tempcnt= loadcnt(filename);


% extract triggers
%stim = tempcnt.event.stimtype;


event = tempcnt.event;
stim = struct2cell(event);
stim = stim(1,:,:);
stim=[stim{:}];

ii1=find(stim==1);
ii2=find(stim==2);
ii3=find(stim==3);
ii4=find(stim==4);
ii5=find(stim==5);
ii6=find(stim==6);


event = struct2cell(event);
offset = event(4,:,:);
offset=[offset{:}];

% break down into trials
trial_number = length(ii1);

for i=1:trial_number
    data1(:,:,i)=tempcnt.data(:, offset(ii1(i))-500:offset(ii1(i))+249);
end


trial_number = length(ii2);

for i=1:trial_number
    data2(:,:,i)=tempcnt.data(:, offset(ii2(i))-500:offset(ii2(i))+249);
end

trial_number = length(ii3);

for i=1:trial_number
    data3(:,:,i)=tempcnt.data(:, offset(ii3(i))-500:offset(ii3(i))+249);
end


trial_number = length(ii4);

for i=1:trial_number
    data4(:,:,i)=tempcnt.data(:, offset(ii4(i))-500:offset(ii4(i))+249);
end

trial_number = length(ii5);

for i=1:trial_number
    data5(:,:,i)=tempcnt.data(:, offset(ii5(i))-500:offset(ii5(i))+249);
end


trial_number = length(ii6);

for i=1:trial_number
    data6(:,:,i)=tempcnt.data(:, offset(ii6(i))-500:offset(ii6(i))+249);
end

% Linear detrend

for i=1:size(data1,3)
    data1(:,:,i)=(detrend2(squeeze(data1(:,:,i))',125,125))';
end

for i=1:size(data2,3)
    data2(:,:,i)=(detrend2(squeeze(data2(:,:,i))',125,125))';
end

for i=1:size(data3,3)
    data3(:,:,i)=(detrend2(squeeze(data3(:,:,i))',125,125))';
end

for i=1:size(data4,3)
    data4(:,:,i)=(detrend2(squeeze(data4(:,:,i))',125,125))';
end

for i=1:size(data5,3)
    data5(:,:,i)=(detrend2(squeeze(data5(:,:,i))',125,125))';
end

for i=1:size(data6,3)
    data6(:,:,i)=(detrend2(squeeze(data6(:,:,i))',125,125))';
end



% Baseline correct to pre-stimulus period
data1 = blcorrect3(data1, 62);
data2 = blcorrect3(data2, 62);
data3 = blcorrect3(data3, 62);
data4 = blcorrect3(data4, 62);
data5 = blcorrect3(data5, 62);
data6 = blcorrect3(data6, 62);


total_data = cat(3, total_data, data1, data2, data3, data4, data5, data6);
stim_matrix = [stim_matrix length(ii1) length(ii2) length(ii3) length(ii4) length(ii5) length(ii6)];

clear tempcnt data1 data2 data3 data4 data5 data6

end % end of files loop


eval(['save ' num2str(ns) '_stim_matrix'  ' stim_matrix']);

x=size(total_data);
eval(['save ' num2str(ns) '_data_matrix_dim'  ' x']);

Nelectrodes = x(1);
Nsamples = x(2);
Nevents = x(3);

total_data = reshape(total_data,Nelectrodes,Nevents*Nsamples);

eval(['save ' num2str(ns) '_data_epochs.mat'  ' total_data']);


b= jader(total_data, 30);


    s=['b' num2str(ns)];
    save(s, 'b');

clear total_data

end % end of subjects loop









