clear all

subjects = {'S1_';'S4_';'S5_';'S8_';'S9_';'S10_'};
sessions = {'2','3'};

for sess = 1:length(sessions)
    session = sessions(sess);
    session = session{:};
    
    for dt = 1:3
        
        grand_avg=zeros(62,1501);
    
        for sub = 1:length(subjects)
            subject = subjects(sub);
            subject = subject{:};

            load([subject 'avg_' session '_' num2str(dt) '.mat']);
            grand_avg=grand_avg + avg;
            clear avg       

            grand_avg = grand_avg / sub; 

            eval(['save Grand_avg_' session '_' num2str(dt) '.mat'  ' grand_avg']
        end
        clear grand_avg
    end
end




