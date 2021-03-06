%Check Averages
clear all

elec_avg_early = [20 51 54];
elec_avg_mid = [15 20 49];
elec_avg_late = [14 15 49];
elec_avg_n2a = [14 15 49];
elec_avg_n2b = [13 19 47];
elec_avg_p2 = [15 20 51];

subjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'OA1', 'OA2','OA4', 'OA5', 'OA6', 'OA7', 'OA8', 'OA9', 'OA10', 'OA11', 'OA12','OA13', 'OA14','OA15','OA16','OA17'};

for x = 1:length(subjects)
subject = subjects(x);
subject = char(subject);

t=-2000:749;

%load([subject '_1_avg.mat']);
%plot(t, -avg(15,:), 'b:');
%hold on

%load([subject '_2_avg.mat']);
%plot(t, -avg(15,:), 'g:');
%hold on

%load([subject '_3_avg.mat']);
%plot(t, -avg(15,:), 'r:');
%hold on

load([subject '_4_avg_ca.mat']);
%t=-500:(size(avg,2) - 501);
avg = iirfilt(avg,500,2,20);
avg = blcorrect4(avg, 1750);
plot(t, -mean(avg(elec_avg_p2,:),1), 'b'), title(subject);
hold on

load([subject '_5_avg_ca.mat']);
avg = iirfilt(avg,500,2,20);
avg = blcorrect4(avg, 1750);
plot(t, -mean(avg(elec_avg_p2,:),1), 'g');
hold on

load([subject '_6_avg_ca.mat']);
avg = iirfilt(avg,500,2,20);
avg = blcorrect4(avg, 1750);
plot(t, -mean(avg(elec_avg_p2,:),1), 'r');
%topoplot(mean(avg([1:2 4:30 33:64], 750:1000),2), 'C:\Documents and Settings\mdmoscab\Desktop\Data analysis files\EEG analysis Matlab\chan.locs2'); caxis([-5 5]), colorbar
hold on

%pause
%close(gcf)
%end

%check latency
load N2latencies
load P2latencies
load amplitudes
AMP = reshape(AMP2,length(subjects),6,6);
N2 = (N2LAT+4000)/2;
P2 = (P2LAT+4000)/2;
Y = zeros(1,length(t));
Z = zeros(1,length(t));
%AMPLEP(44,:) = 5;

%Y(P2(x,1)) = AMPLEP(x,1);
%Y(P2(x,2)) = AMPLEP(x,2);
%Y(P2(x,3)) = AMPLEP(x,3);
Y(P2(x,4)) = AMP(x,4,6);
plot (t, -Y(:,:), 'y.')
hold on
Y(P2(x,5)) = AMP(x,5,6);
plot (t, -Y(:,:), 'y.')
hold on
Y(P2(x,6)) = AMP(x,6,6);
plot (t, -Y(:,:), 'y.')
hold on

%Z(N2(x,1)) = AMPLEP(x,7);
%Z(N2(x,2)) = AMPLEP(x,8);
%Z(N2(x,3)) = AMPLEP(x,9);
Z(N2(x,4)) = AMP(x,4,4);
plot (t, -Z(:,:), 'm.')
hold on
Z(N2(x,5)) = AMP(x,5,4);
plot (t, -Z(:,:), 'm.')
hold on
Z(N2(x,6)) = AMP(x,6,4);
plot (t, -Z(:,:), 'm.')
hold on

pause
close(gcf)
end