clear all

subjects = {'M1';'M2';'M4';'M6';'M7';'M10';'M12';'M14';'M15';'M16';'M17';'M29';'M30';'M32';'M33';'M9';'M19';'M20';'M21';'M22';'M24';'M25';'M26';'M35';'M36';'M37';'M38';'M40'};
NSub = length(subjects);
load ICAcmp_max
maxi(1,11) = 13;

Ngp1 = 15;
Ngp2 = 13;

conditions = 2;
cond_inc = [1:2]; % conditions to include in test 

ele = [1:2 4:30 33:64];
peaks = 1;
results = zeros(3,3,length(maxi),conditions,peaks);
subject = [1:NSub 1:NSub]; %- subject ID
time = [ones(1,NSub) 2*ones(1,NSub)]; %- timepoint
group = [ones(1,Ngp1) 2*ones(1,Ngp2) ones(1,Ngp1) 2*ones(1,Ngp2)]; %-- group ID for every datapoint

e = [9 19];

c1t = zeros(1,length(ele));
c2t = zeros(1,length(ele));
c3t = zeros(1,length(ele));
c4t = zeros(1,length(ele));

%%%%%%%%%%
for h = 1:length(ele)

for f = 1:peaks
%fname = fnames(f,:)';
    
data1 = zeros(1,NSub*2); %cond1
data2 = zeros(1,NSub*2); %cond2
%data3 = zeros(1,NSub*2); %cond2-1

for n = 1:NSub
    
channel = maxi(1,e); 

for g = 1:length(e)
    
fname={
    ['_1_ICA' num2str(e(g)) '_avg_ca.mat'] 
    ['_2_ICA' num2str(e(g)) '_avg_ca.mat'] 
    ['_3_ICA' num2str(e(g)) '_avg_ca.mat'] 
    ['_4_ICA' num2str(e(g)) '_avg_ca.mat'] 
  };
    
sub = subjects(n);
load([char(sub) char(fname(1))]);
c1 = avg;
load([char(sub) char(fname(2))]);
c2 = avg;
load([char(sub) char(fname(3))]);
c3 = avg;
load([char(sub) char(fname(4))]);
c4 = avg;
%c5 = load([char(sub) char(fname(5))]);
%c6 = load([char(sub) char(fname(6))]);

c1 = c1(1,ele);
c2 = c2(1,ele);
c3 = c3(1,ele);
c4 = c4(1,ele);
%c5 = c5(1,ele);
%c6 = c6(1,ele);

c1t = c1t + c1;
c2t = c2t + c2;
c3t = c3t + c3;
c4t = c4t + c4;
end

c1t = c1t/4;
c2t = c2t/4;
c3t = c3t/4;
c4t = c4t/4;

c1t = c1t(1,h);
c2t = c2t(1,h);
c3t = c3t(1,h);
c4t = c4t(1,h);

data1(1,n) = c1t;
data2(1,n) = c2t;
%data3(1,n) = c5(1,channel);
data1(1,n+NSub) = c3t;
data2(1,n+NSub) = c4t;
%data3(1,n+NSub) = c6(1,e);

end

% normalise the data to percent of mean across conditions, for each subject
data4mean = reshape(cat(2,data1,data2), NSub,4);
for i=1:NSub
    meandata = mean(data4mean(i,:),2);
    %data4mean(i,:) = ((data4mean(i,:)-meandata)/meandata)*100;
    data4mean(i,:) = data4mean(i,:) - meandata;
end
data4mean = reshape(data4mean, 1, NSub*4);
data1 = data4mean(1,1:2*NSub);
data2 = data4mean(1,2*NSub+1:4*NSub);

data = data1;
tab = F1LDF1(data,group,subject,time);
results(:,:,h,1,f) = tab;

data = data2;
tab = F1LDF1(data,group,subject,time);
results(:,:,h,2,f) = tab;

%data = data3;
%tab = F1LDF1(data,group,subject,time);
%results(:,:,e,3,f) = tab;


end
end

%end

results_pval = results(:,3,:,cond_inc,:); % '3' for t values - use '2' for n values
p = reshape(results_pval,1,h*length(cond_inc)*3*peaks);
q=0.05;

%%%% FDR correction
%[pID,pN] = fdr(p,q)


%% readout of significant electrodes

peak = 1;

results_pval2 = results_pval(:,:,:,:,peak);
p2 = p(1+(length(p)/peaks)*(peak-1):(length(p)/peaks)+(length(p)/peaks)*(peak-1));

if exist('pID') == 1
sig = find(p2<=pID);
else
sig = find(p2<=q);
pID = q;
end

s1 = find(sig<=3*length(ele));
s2 = find(sig<=3*length(ele)*length(cond_inc));
if length(cond_inc) > 2
s3 = find(sig<=3*length(ele)*length(cond_inc));
s3(s2) = [];
end
s2(s1) = [];

[elec,x,y,chans] = textread('C:\Documents and Settings\mdmoscab\Desktop\Data analysis files\EEG analysis Matlab\chan.locs','%f %f %f %s');
chans = chans(ele);
ele2 = zeros(length(ele)*length(cond_inc)*3,1);
chans2 = cell(length(ele)*length(cond_inc)*3,1);
for c = 1:length(ele)
chans2(1+3*(c-1):3+3*(c-1)) = chans(c);
chans2(length(ele)*3+1+3*(c-1):length(ele)*3+3+3*(c-1)) = chans(c);
chans2(2*length(ele)*3+1+3*(c-1):2*length(ele)*3+3+3*(c-1)) = chans(c);
ele2(1+3*(c-1):3+3*(c-1)) = ele(c);
ele2(length(ele)*3+1+3*(c-1):length(ele)*3+3+3*(c-1)) = ele(c);
ele2(2*length(ele)*3+1+3*(c-1):2*length(ele)*3+3+3*(c-1)) = ele(c);
end

cond1_chans = chans2(sig(s1))
c1p = ismember(ele,ele2(sig(s1)));
cond1_pval = results_pval2(:,:,c1p,1)
interp1 = find(cond1_pval(3,:,:) <= pID)
inter1 = cond1_chans(interp1)

cond2_chans = chans2(sig(s2))
c2p = ismember(ele,ele2(sig(s2)));
cond2_pval = results_pval2(:,:,c2p,2)
interp2 = find(cond2_pval(3,:,:) <= pID)
inter2 = cond2_chans(interp2)

if length(cond_inc) > 2
cond3_chans = chans2(sig(s3))
c3p = ismember(ele,ele2(sig(s3)));
cond3_pval = results_pval2(:,:,c3p,3)
interp3 = find(cond3_pval(3,:,:) <= pID)
inter3 = cond3_chans(interp3)
end

