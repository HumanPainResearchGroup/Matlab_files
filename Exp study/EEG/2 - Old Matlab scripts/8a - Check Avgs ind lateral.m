%Check Averages
clear all

subjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'OA1', 'OA2', 'OA4', 'OA5', 'OA6', 'OA7', 'OA8', 'OA9', 'OA10', 'OA11', 'OA12'};

for x = 1:length(subjects)
subject = subjects(x);
subject = char(subject);

t=-500:250;

%load([subject '_1_avg.mat']);
%plot(t, -avg(19,:), 'b:');
%hold on

%load([subject '_2_avg.mat']);
%plot(t, -avg(19,:), 'g:');
%hold on

%load([subject '_3_avg.mat']);
%plot(t, -avg(19,:), 'r:');
%hold on

load([subject '_4_avgP2_ca.mat']);
t=-500:(size(avg,2) - 501);
plot(t, -avg(19,:), 'k'), title(subject);
hold on

load([subject '_5_avgP2_ca.mat']);
plot(t, -avg(19,:), 'k');
hold on

load([subject '_6_avgP2_ca.mat']);
plot(t, -avg(19,:), 'k');
hold on

%check latency
load N2latencies4
load P2latencies4
load amplitudesLEP4
N2 = (N2LAT+4000)/8;
P2 = (P2LAT+4000)/8;
Y = zeros(1,length(t));
Z = zeros(1,length(t));

%Y(P2(x,1)) = AMPLEP(x,1);
%Y(P2(x,2)) = AMPLEP(x,2);
%Y(P2(x,3)) = AMPLEP(x,3);
Y(P2(x,4)) = AMPLEP(x,4);
plot (t, -Y(:,:), 'y.')
hold on
Y(P2(x,5)) = AMPLEP(x,5);
plot (t, -Y(:,:), 'y.')
hold on
Y(P2(x,6)) = AMPLEP(x,6);
plot (t, -Y(:,:), 'y.')
hold on

%Z(N2(x,1)) = AMPLEP(x,7);
%Z(N2(x,2)) = AMPLEP(x,8);
%Z(N2(x,3)) = AMPLEP(x,9);
Z(N2(x,4)) = AMPLEP(x,10);
plot (t, -Z(:,:), 'm.')
hold on
Z(N2(x,5)) = AMPLEP(x,11);
plot (t, -Z(:,:), 'm.')
hold on
Z(N2(x,6)) = AMPLEP(x,12);
plot (t, -Z(:,:), 'm.')
hold on

pause
close(gcf)
end