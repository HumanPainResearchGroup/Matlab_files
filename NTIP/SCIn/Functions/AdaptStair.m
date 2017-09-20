function [output, expthresholds] = AdaptStair(s)

%% Task:
% in roving oddball with task of detecting changes in intensity,
% 

% REMOVE THESE PARAMETERS LATER

%s.STIMULUSLEVEL = INIZIALIZES A VECTOR FOR THE LEVEL OF THE STIMULI
%s.SUBJCTACCURACY = INIZIALIZES A VECTOR FOR EVALUATION OF SUBJECT ACCURACY
%s.FA = INIZIALIZES A VECTOR FOR THE FALSE ALLARMS
%s.FEEDBACK= LOGICAL VALUE. DISPLAY ANSWER CORRECTNESS
%s.TEMPORARYTHRESHOLD = TEMPORARY THRESHOLDS AFTER EACH TRIAL
%s.MATSAVEDATA = INIZIALIZES A MATRIX FOR SAVING THE DATA

tracking = 'Staircase';
%s.standard= -30;
s.feature='TwoDownOneUp';
s.down=2;
s.feedback= 1;
s.reversals = [4;8];
s.stepsize = [2;sqrt(2)];
s.fileout = 'data.txt';
s.SaveResults =1;
s.tasktype = 1;
s.exppos = 1;
s.experiment = 'IntensityDiscriminationPureTone_S';
s.thresholdtype='Arithmetic';
s.reversalForthresh = 8;
s.isstep = 0;
s.nafc=3;
s.NameStepSize='Factor';

% if this is the first run, do some setup
if s.count_of_n_of_reversals == 0
    if length(s.reversals) ~= length(s.stepsize)
        error('The number of s.reversals and the number of steps must be identical.');
    end
    % here I set the plan of the threshold tracking, i.e., a matrix (two
    % columns) that contains on the left the progressive number of s.reversals and
    % on the right the corresponding step size
    s.expplan = [(1:sum(s.reversals))', zeros(sum(s.reversals), 1)];
    i=1;
    for j=1:length(s.reversals)
        for k=1:s.reversals(j)
            s.expplan(i, 2)=s.stepsize(j);
            i=i+1;
        end
    end
    % here I define the variable row of output that contains all the output values of the
    % function. In the current function the output is updated at the end of the while loop
    % this are the values and the labels
    output = [];
    rowofoutput = zeros(1, 6);
    expthresholds = zeros(1, 1);


    clc
    input('Press return to begin ', 's');
    pause(1)
    % indexes for the while loop
    s.count_of_n_of_reversals = 0;
    s.adaptive.trial = 1;
    s.blockthresholds = zeros(length(s.reversalForthresh), 1);
    s.n_threshold = 1;
    % variable for the up-s.down
    s.n_down = 0;
    % variable for count the positive and negative answers
    s.pos = 0;
    s.neg = 0;
    s.trend = 30;
    s.StimulusLevel = s.Settings.adaptive.startinglevel;
    s.actualstep = s.expplan(1, 2);
end

if s.count_of_n_of_reversals < sum(s.reversals);
    pause(0.5)
    %fprintf('[%1.0f] ', s.adaptive.trial);
    
    % here I get the answer from the simulated listener
    %fun = [s.experiment,'(' num2str(s.standard) ', StimulusLevel ,' num2str( s.nafc)   ')'];
    %[CorrectAnswer, Question] =  eval(fun);
    
    % evaluate the subject's response
    resi = ismember(s.out.pressbutton{s.i},h.Settings.buttonopt); % which button was pressed?
    resfun = s.Settings.adaptive.signalval(resi); %what is meaning of this response?
    
    if resfun == s.Seq.signal(s.i);
    %s.SubjectAccuracy(s.adaptive.trial)= EvaluateAnswer(CorrectAnswer,s.feedback,Question);   %evaluing the subject answer (right or wrong)
        s.SubjectAccuracy(s.adaptive.trial)= 1;
    else
        s.SubjectAccuracy(s.adaptive.trial)= 0;
    end
    
    % UPDATE THE ROWOFOUTPUT
    %rowofoutput (1, 1) = block;
    rowofoutput (1, 2) = s.adaptive.trial;
    rowofoutput (1, 3) = s.StimulusLevel;
    rowofoutput (1, 4) = s.SubjectAccuracy(s.adaptive.trial);
    % here I upddate the count for the up-s.down motion
    if s.SubjectAccuracy(s.adaptive.trial) == 1
        s.n_down = s.n_down + 1;
        if s.n_down == s.down
            s.n_down = 0;
            s.pos = 1;
            s.trend = 1;
            % here I update the count of the number of s.reversals and
            % corresponding stepsize
            if s.pos ==1 && s.neg == -1
                s.count_of_n_of_reversals = s.count_of_n_of_reversals + 1;
                % calculate the threshold
                blockthresholds(s.n_threshold)=(s.StimulusLevel + rowofoutput(1, 3))/2;
                s.n_threshold = s.n_threshold + 1;
                s.actualstep = expplan(s.count_of_n_of_reversals, 2);
                s.pos = s.trend;
                s.neg = s.trend;
            end
            if s.isstep == 1
                s.StimulusLevel = s.StimulusLevel - s.actualstep;
            else
                s.StimulusLevel = s.StimulusLevel / s.actualstep;
            end
        end
    else
        s.neg = -1;
        s.trend = -1;
        s.n_down = 0;
        % here I update the count of the number of s.reversals and
        % corresponding stepsize
        if s.pos ==1 && s.neg == -1
            s.count_of_n_of_reversals = s.count_of_n_of_reversals + 1;
            % calculate the threshold
            blockthresholds(s.n_threshold)=(s.StimulusLevel + rowofoutput(1, 3))/2;
            s.n_threshold = s.n_threshold + 1;
            s.actualstep = s.expplan(s.count_of_n_of_reversals, 2);
            s.pos = s.trend;
            s.neg = s.trend;
        end
        if s.isstep == 1
            s.StimulusLevel = s.StimulusLevel + s.actualstep;
        else
            s.StimulusLevel = s.StimulusLevel * s.actualstep;
        end
    end
    % UPDATE THE ROWOFOUTPUT
    rowofoutput (1, 5) = s.count_of_n_of_reversals;
    rowofoutput (1, 6) = s.actualstep;
    % update the number of trials
    s.adaptive.trial = s.adaptive.trial + 1;
    % UPDATE THE GLOBAL OUTPUT VARIABLE
    output = [output; rowofoutput];
end
% here I calculate the threshol for the block
switch s.thresholdtype
    case 'Arithmetic'
        expthresholds(block)=mean(blockthresholds(end-(s.reversalForthresh-1):end));
    case 'Geometric'
        expthresholds(block)=prod(blockthresholds(end-(s.reversalForthresh-1):end))^(1/length(blockthresholds(end-(s.reversalForthresh-1):end)));
    case 'Median'
        expthresholds(block)=median(blockthresholds(end-(s.reversalForthresh-1):end));
    otherwise
        disp('Unknown calculation type.')
end
fprintf('Threshold equal to %1.3f\n', expthresholds(block));
fprintf('Press return to continue\n');
pause
fprintf ('\nBLOCK ENDED\n');
pause(2)
%clc
%fprintf ('\nEXPERIMENT ENDED\n\n');
%s.MATSAVEDATA = output;
%if s.SaveResults
%    WriteDataFile(tracking,s.fileout,output,s.nsub,s.name,s.gender,s.age,s.note,expthresholds);
%end
%clear all