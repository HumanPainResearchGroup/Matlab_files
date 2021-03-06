clear all

subjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16'};
   
Nsub = length(subjects);

AMP = zeros(Nsub,6,4,5); % subject, condition, time bins, electrode

fnames={'_1_avg.mat';
    '_2_avg.mat';
    '_3_avg.mat';
    '_4_avg.mat';
    '_5_avg.mat';
    '_6_avg.mat';
  };

for n = 1:Nsub
    subject = subjects(n);
    subject = char(subject);   

fname=char(fnames(1));
fname= [subject fname(1:6)];
mdata1= load(fname);       
    
fname=char(fnames(2));
fname= [subject fname(1:6)];
mdata2= load(fname);   

fname=char(fnames(3));
fname= [subject fname(1:6)];
mdata3= load(fname);   

fname=char(fnames(4));
fname= [subject fname(1:6)];
mdata4= load(fname);   

fname=char(fnames(5));
fname= [subject fname(1:6)];
mdata5= load(fname);   

fname=char(fnames(6));
fname= [subject fname(1:6)];
mdata6= load(fname);

    
grandavg= (mdata1.avg+mdata2.avg+mdata3.avg+mdata4.avg+mdata5.avg+mdata6.avg)/6;

Cz= grandavg(15, :);

%identify P2 latencies

[XMAX,IMAX,XMIN,IMIN] = extrema(Cz(:,500:585));%%search for extrema on internet - peak detection prog, xmax ampli imax latency
LAT = IMAX(1)+500; %% change to be the same as the 1st time point to zero everything

[XMAX,IMAX,XMIN,IMIN] = extrema(mdata1.avg(15,LAT-8:LAT+8));%%each cond seperatly +/-64 ms 15 is CZ
LAT1 = IMAX(1);
[XMAX,IMAX,XMIN,IMIN] = extrema(mdata2.avg(15,LAT-8:LAT+8));
LAT2 = IMAX(1);
[XMAX,IMAX,XMIN,IMIN] = extrema(mdata3.avg(15,LAT-8:LAT+8));
LAT3 = IMAX(1);
[XMAX,IMAX,XMIN,IMIN] = extrema(mdata4.avg(15,LAT-8:LAT+8));
LAT4 = IMAX(1);
[XMAX,IMAX,XMIN,IMIN] = extrema(mdata5.avg(15,LAT-8:LAT+8));
LAT5 = IMAX(1);
[XMAX,IMAX,XMIN,IMIN] = extrema(mdata6.avg(15,LAT-8:LAT+8));
LAT6 = IMAX(1);

%Extract and save data

e1=mdata1.avg(:,188:250)';
e2=mdata2.avg(:,188:250)';
e3=mdata3.avg(:,188:250)';
e4=mdata4.avg(:,188:250)';
e5=mdata5.avg(:,188:250)';
e6=mdata6.avg(:,188:250)';
e1_av=mean(e1);
e2_av=mean(e2);
e3_av=mean(e3);
e4_av=mean(e4);
e5_av=mean(e5);
e6_av=mean(e6);
%c_e_av=[e4_av,e5_av,e6_av];
%c_e_av=mean(c_e_av,2);
%u_e_av=[e1_av,e2_av,e3_av];
%u_e_av=mean(u_e_av,2);
eval(['save ' subject '_1_e_av.dat'  ' e1_av /ASCII'])
eval(['save ' subject '_2_e_av.dat'  ' e2_av /ASCII'])
eval(['save ' subject '_3_e_av.dat'  ' e3_av /ASCII'])
eval(['save ' subject '_4_e_av.dat'  ' e4_av /ASCII'])
eval(['save ' subject '_5_e_av.dat'  ' e5_av /ASCII'])
eval(['save ' subject '_6_e_av.dat'  ' e6_av /ASCII'])


%save c_e_av.dat c_e_av /ASCII
%save u_e_av.dat u_e_av /ASCII
AMP(n,1,1,1) = e1_av(:, 21);%saving into AMP matrix, saving at electrode 21, early time period
AMP(n,2,1,1) = e2_av(:, 21);
AMP(n,3,1,1) = e3_av(:, 21);
AMP(n,4,1,1) = e4_av(:, 21);
AMP(n,5,1,1) = e5_av(:, 21);
AMP(n,6,1,1) = e6_av(:, 21);
AMP(n,1,1,2) = e1_av(:, 20);
AMP(n,2,1,2) = e2_av(:, 20);
AMP(n,3,1,2) = e3_av(:, 20);
AMP(n,4,1,2) = e4_av(:, 20);
AMP(n,5,1,2) = e5_av(:, 20);
AMP(n,6,1,2) = e6_av(:, 20);
AMP(n,1,1,3) = e1_av(:, 15);
AMP(n,2,1,3) = e2_av(:, 15);
AMP(n,3,1,3) = e3_av(:, 15);
AMP(n,4,1,3) = e4_av(:, 15);
AMP(n,5,1,3) = e5_av(:, 15);
AMP(n,6,1,3) = e6_av(:, 15);
AMP(n,1,1,4) = e1_av(:, 14);
AMP(n,2,1,4) = e2_av(:, 14);
AMP(n,3,1,4) = e3_av(:, 14);
AMP(n,4,1,4) = e4_av(:, 14);
AMP(n,5,1,4) = e5_av(:, 14);
AMP(n,6,1,4) = e6_av(:, 14);
AMP(n,1,1,5) = e1_av(:, 4);
AMP(n,2,1,5) = e2_av(:, 4);
AMP(n,3,1,5) = e3_av(:, 4);
AMP(n,4,1,5) = e4_av(:, 4);
AMP(n,5,1,5) = e5_av(:, 4);
AMP(n,6,1,5) = e6_av(:, 4);

m1=mdata1.avg(:,313:375)';%mid time period
m2=mdata2.avg(:,313:375)';
m3=mdata3.avg(:,313:375)';
m4=mdata4.avg(:,313:375)';
m5=mdata5.avg(:,313:375)';
m6=mdata6.avg(:,313:375)';
m1_av=mean(m1);
m2_av=mean(m2);
m3_av=mean(m3);
m4_av=mean(m4);
m5_av=mean(m5);
m6_av=mean(m6);
%c_m_av=[m4_av,m5_av,m6_av];
%c_m_av=mean(c_m_av,2);
%u_m_av=[m1_av,m2_av,m3_av];
%u_m_av=mean(u_m_av,2);
eval(['save ' subject '_1_m_av.dat'  ' m1_av /ASCII'])
eval(['save ' subject '_2_m_av.dat'  ' m2_av /ASCII'])
eval(['save ' subject '_3_m_av.dat'  ' m3_av /ASCII'])
eval(['save ' subject '_4_m_av.dat'  ' m4_av /ASCII'])
eval(['save ' subject '_5_m_av.dat'  ' m5_av /ASCII'])
eval(['save ' subject '_6_m_av.dat'  ' m6_av /ASCII'])


%save c_m_av.dat c_m_av /ASCII
%save u_m_av.dat u_m_av /ASCII
AMP(n,1,2,1) = m1_av(:, 21);
AMP(n,2,2,1) = m2_av(:, 21);
AMP(n,3,2,1) = m3_av(:, 21);
AMP(n,4,2,1) = m4_av(:, 21);
AMP(n,5,2,1) = m5_av(:, 21);
AMP(n,6,2,1) = m6_av(:, 21);
AMP(n,1,2,2) = m1_av(:, 20);
AMP(n,2,2,2) = m2_av(:, 20);
AMP(n,3,2,2) = m3_av(:, 20);
AMP(n,4,2,2) = m4_av(:, 20);
AMP(n,5,2,2) = m5_av(:, 20);
AMP(n,6,2,2) = m6_av(:, 20);
AMP(n,1,2,3) = m1_av(:, 15);
AMP(n,2,2,3) = m2_av(:, 15);
AMP(n,3,2,3) = m3_av(:, 15);
AMP(n,4,2,3) = m4_av(:, 15);
AMP(n,5,2,3) = m5_av(:, 15);
AMP(n,6,2,3) = m6_av(:, 15);
AMP(n,1,2,4) = m1_av(:, 14);
AMP(n,2,2,4) = m2_av(:, 14);
AMP(n,3,2,4) = m3_av(:, 14);
AMP(n,4,2,4) = m4_av(:, 14);
AMP(n,5,2,4) = m5_av(:, 14);
AMP(n,6,2,4) = m6_av(:, 14);
AMP(n,1,2,5) = m1_av(:, 4);
AMP(n,2,2,5) = m2_av(:, 4);
AMP(n,3,2,5) = m3_av(:, 4);
AMP(n,4,2,5) = m4_av(:, 4);
AMP(n,5,2,5) = m5_av(:, 4);
AMP(n,6,2,5) = m6_av(:, 4);

l1=mdata1.avg(:,438:500)';%late
l2=mdata2.avg(:,438:500)';
l3=mdata3.avg(:,438:500)';
l4=mdata4.avg(:,438:500)';
l5=mdata5.avg(:,438:500)';
l6=mdata6.avg(:,438:500)';
l1_av=mean(l1);
l2_av=mean(l2);
l3_av=mean(l3);
l4_av=mean(l4);
l5_av=mean(l5);
l6_av=mean(l6);
%c_l_av=[l4_av,l5_av,l6_av];
%c_l_av=mean(c_l_av,2);
%u_l_av=[l1_av,l2_av,l3_av];
%u_l_av=mean(u_l_av,2);

eval(['save ' subject '_1_l_av.dat'  ' l1_av /ASCII'])
eval(['save ' subject '_2_l_av.dat'  ' l2_av /ASCII'])
eval(['save ' subject '_3_l_av.dat'  ' l3_av /ASCII'])
eval(['save ' subject '_4_l_av.dat'  ' l4_av /ASCII'])
eval(['save ' subject '_5_l_av.dat'  ' l5_av /ASCII'])
eval(['save ' subject '_6_l_av.dat'  ' l6_av /ASCII'])


%save c_l_av.dat c_l_av /ASCII
%save u_l_av.dat u_l_av /ASCII
AMP(n,1,3,1) = l1_av(:, 21);%%late time period
AMP(n,2,3,1) = l2_av(:, 21);
AMP(n,3,3,1) = l3_av(:, 21);
AMP(n,4,3,1) = l4_av(:, 21);
AMP(n,5,3,1) = l5_av(:, 21);
AMP(n,6,3,1) = l6_av(:, 21);
AMP(n,1,3,2) = l1_av(:, 20);
AMP(n,2,3,2) = l2_av(:, 20);
AMP(n,3,3,2) = l3_av(:, 20);
AMP(n,4,3,2) = l4_av(:, 20);
AMP(n,5,3,2) = l5_av(:, 20);
AMP(n,6,3,2) = l6_av(:, 20);
AMP(n,1,3,3) = l1_av(:, 15);
AMP(n,2,3,3) = l2_av(:, 15);
AMP(n,3,3,3) = l3_av(:, 15);
AMP(n,4,3,3) = l4_av(:, 15);
AMP(n,5,3,3) = l5_av(:, 15);
AMP(n,6,3,3) = l6_av(:, 15);
AMP(n,1,3,4) = l1_av(:, 14);
AMP(n,2,3,4) = l2_av(:, 14);
AMP(n,3,3,4) = l3_av(:, 14);
AMP(n,4,3,4) = l4_av(:, 14);
AMP(n,5,3,4) = l5_av(:, 14);
AMP(n,6,3,4) = l6_av(:, 14);
AMP(n,1,3,5) = l1_av(:, 4);
AMP(n,2,3,5) = l2_av(:, 4);
AMP(n,3,3,5) = l3_av(:, 4);
AMP(n,4,3,5) = l4_av(:, 4);
AMP(n,5,3,5) = l5_av(:, 4);
AMP(n,6,3,5) = l6_av(:, 4);

p21=mdata1.avg(:,(LAT-8+LAT1)-1:(LAT-8+LAT1)+1)';%P2 for condtion 1 
p22=mdata2.avg(:,(LAT-8+LAT2)-1:(LAT-8+LAT2)+1)';%P2 for condition 2
p23=mdata3.avg(:,(LAT-8+LAT3)-1:(LAT-8+LAT3)+1)';
p24=mdata4.avg(:,(LAT-8+LAT4)-1:(LAT-8+LAT4)+1)';
p25=mdata5.avg(:,(LAT-8+LAT5)-1:(LAT-8+LAT5)+1)';
p26=mdata6.avg(:,(LAT-8+LAT6)-1:(LAT-8+LAT6)+1)';
p21_av=mean(p21);
p22_av=mean(p22);
p23_av=mean(p23);
p24_av=mean(p24);
p25_av=mean(p25);
p26_av=mean(p26);
%c_p2_av=[p24_av,p25_av,p26_av];
%c_p2_av=mean(c_p2_av,2);
%u_p2_av=[p21_av,p22_av,p23_av];
%u_p2_av=mean(u_p2_av,2);

eval(['save ' subject '_1_p2_av.dat'  ' p21_av /ASCII'])%all electrodes in 1 file - source analysis
eval(['save ' subject '_2_p2_av.dat'  ' p22_av /ASCII'])
eval(['save ' subject '_3_p2_av.dat'  ' p23_av /ASCII'])
eval(['save ' subject '_4_p2_av.dat'  ' p24_av /ASCII'])
eval(['save ' subject '_5_p2_av.dat'  ' p25_av /ASCII'])
eval(['save ' subject '_6_p2_av.dat'  ' p26_av /ASCII'])



AMP(n,1,4,1) = p21_av(:, 21);%p2 electrode 
AMP(n,2,4,1) = p22_av(:, 21);
AMP(n,3,4,1) = p23_av(:, 21);
AMP(n,4,4,1) = p24_av(:, 21);
AMP(n,5,4,1) = p25_av(:, 21);
AMP(n,6,4,1) = p26_av(:, 21);
AMP(n,1,4,2) = p21_av(:, 20);
AMP(n,2,4,2) = p22_av(:, 20);
AMP(n,3,4,2) = p23_av(:, 20);
AMP(n,4,4,2) = p24_av(:, 20);
AMP(n,5,4,2) = p25_av(:, 20);
AMP(n,6,4,2) = p26_av(:, 20);
AMP(n,1,4,3) = p21_av(:, 15);
AMP(n,2,4,3) = p22_av(:, 15);
AMP(n,3,4,3) = p23_av(:, 15);
AMP(n,4,4,3) = p24_av(:, 15);
AMP(n,5,4,3) = p25_av(:, 15);
AMP(n,6,4,3) = p26_av(:, 15);
AMP(n,1,4,4) = p21_av(:, 14);
AMP(n,2,4,4) = p22_av(:, 14);
AMP(n,3,4,4) = p23_av(:, 14);
AMP(n,4,4,4) = p24_av(:, 14);
AMP(n,5,4,4) = p25_av(:, 14);
AMP(n,6,4,4) = p26_av(:, 14);
AMP(n,1,4,5) = p21_av(:, 4);
AMP(n,2,4,5) = p22_av(:, 4);
AMP(n,3,4,5) = p23_av(:, 4);
AMP(n,4,4,5) = p24_av(:, 4);
AMP(n,5,4,5) = p25_av(:, 4);
AMP(n,6,4,5) = p26_av(:, 4);



end
AMP2 = reshape(AMP,Nsub,120); % reshapes: column order = cond(1->6) for each time (1->4), for each electrode (1->5).
save amplitudes.mat AMP2