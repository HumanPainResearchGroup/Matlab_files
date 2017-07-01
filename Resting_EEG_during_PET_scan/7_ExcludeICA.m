
%exclude components
clear all

subjects = {'S1_';'S4_';'S5_';'S8_';'S9_';'S10_';'S11_'};
for x=7%1:length(subjects)

subject = subjects(x);
subject = char(subject);



    load ([subject 'data_segments2_acc.mat']);

    load ([subject 'b2_acc' ]);

%excludes = {
%   ''
%   ''
%   ''
%   ''
%   ''
%   ''
%};
excludes = {
    ''
    ''
    ''
    ''
    ''
    ''
    ''
};


exclude=excludes(x);
exclude=[exclude{:}];

exclude=str2num(exclude);

include = [1:30];
include(exclude) = [];


act = b * total_data_ICA2;
ib = pinv(b);

iact= ib(:, include) * act(include,:);  

%iact = iirfilt(iact,500,0,30); %filter the data

Nelectrodes = 62;
Nsamples = 1501;
Nevents = size(iact,2)/Nsamples;

total_data_ICA2=reshape(iact, Nelectrodes, Nsamples, Nevents); % re-froms the epochs

eval(['save ' subject 'total_data_ICA2_acc.mat'  ' total_data_ICA2']);


clear exclude include total_data_ICA2_acc total_data_ICA2

end

%exclude components
clear all

subjects = {'S1_';'S4_';'S5_';'S8_';'S9_';'S10_';'S11_'};
for x=1:length(subjects)

subject = subjects(x);
subject = char(subject);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ([subject 'data_segments3_acc.mat']);

load ([subject 'b3_acc' ]);

%excludes = {
%   ''
%   ''
%   ''
%   ''
%   ''
%   ''
%};
excludes = {
    ''
    ''
    ''
    ''
    ''
    ''
    ''
};


exclude=excludes(x);
exclude=[exclude{:}];

exclude=str2num(exclude);

include = [1:30];
include(exclude) = [];

act = b * total_data_ICA3;
ib = pinv(b);

iact= ib(:, include) * act(include,:);  

%iact = iirfilt(iact,500,0,30); %filter the data

Nelectrodes = 62;
Nsamples = 1501;
Nevents = size(iact,2)/Nsamples;

total_data_ICA3=reshape(iact, Nelectrodes, Nsamples, Nevents); % re-froms the epochs

eval(['save ' subject 'total_data_ICA3_acc.mat'  ' total_data_ICA3']);


clear exclude include total_data_ICA3_acc total_data_ICA3 x

end