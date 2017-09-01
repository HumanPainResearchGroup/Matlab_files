%% create settings structure (don't change)
clear all
S=struct;
dbstop if error

%% INPUT FILE SETUP

% accelerometer data directory
S.acc_dir = 'C:\Matlab\FAST';
% accelerometer data generic file name (without subject identifier)
S.acc_file = '_WTV_MS_1.xlsx';
% column header for date and time
S.acc_datehead = {'date','epoch'};
% column header for data to be analysed
S.acc_data = 'steps';

% pain ratings data directory
S.pr_dir = 'C:\Matlab\FAST';
% pain ratings data generic file name (without subject identifier)
S.pr_file = '_PainScores_MS.xlsx';
% column header for date and time
S.pr_datehead = 'Date and time';
% column header for pain rating
S.pr_data = 'Pain score';

%% OUTPUT FILE DIRECTORY AND NAME
S.out_dir = 'C:\Matlab\FAST';
% save new file for each subject (saveeach = 1), or all subjects in one file (=0)?
S.saveeach = 1;
% generic file name (subject identifier will be added as prefix)
S.out_file = '_output.xlsx'; 

%% ANALYSIS SETTINGS

% First, define the time windows over which to apply functions (e.g. functions are simple summary measures such as the mean) to the data
% Also, define the accelerometer time window with respect to the pain ratings time window (S.acc_cen)

% time window to apply to accelerometer data
S.acc_tw = 'all'; % current options: 'daily'. Other options: a number of hours, e.g. '2' (not yet programmed)
% time window to apply to pain ratings data
S.pr_tw = 'all'; % current options: 'daily'. Other options: a number of hours, e.g. '2' (not yet programmed)
% centering of accelerometer data with respect to pain ratings outputs.
% if left empty as '', analysis of accelerometer data will proceed independently of pain ratings data
S.acc_cen = ''; % 'end' analyses accel data occuring before pain ratings. Other options: 'start' or 'middle' (not yet programmed))

% List functions to apply to each type of data
% Output file will include the results of these functions

% ACCEL FUNCTION 1
% name with no spaces
S.acc_fun(1).name = 'mean'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.acc_fun(1).fun = 'mean(X)'; 

% ACCEL FUNCTION 2
% name with no spaces
S.acc_fun(2).name = 'median'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.acc_fun(2).fun = 'median(X)'; 

% ACCEL FUNCTION 3
% name with no spaces
S.acc_fun(3).name = 'std'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.acc_fun(3).fun = 'std(X)'; 

% ACCEL FUNCTION 4
% name with no spaces
S.acc_fun(4).name = 'range'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.acc_fun(4).fun = 'max(X)-min(X)'; 

% ACCEL FUNCTION 5
% name with no spaces
S.acc_fun(5).name = 'sum'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.acc_fun(5).fun = 'sum(X)'; 

% PAIN RATINGS FUNCTION 1
% name with no spaces
S.pr_fun(1).name = 'mean'; 
% actual function using Matlab syntax. X = N-dimensional data array.
S.pr_fun(1).fun = 'mean(X)'; 

%% RUN SCRIPT

% create date/time string to add to output file name
runtime = datestr(now,30);
% list all accelerometer files in the directory
afiles = dir(fullfile(S.acc_dir,['*' S.acc_file]));

% create output headers defining dates/times
D = {'Date','Time'};
nHead = size(D);

for f = 1:length(afiles)
    
    clear pr_head pr_out acc_head acc_out
    
    % load each accel file in turn and also load it's corresponding pain
    % ratings data file (if there is one)
    
    % obtain file name
    acc_file = afiles(f).name;
    % identify subject
    temp = strsplit(acc_file,'_');
    subname = [temp{1} '_' temp{2}];
    % obtain corresponding pain ratings file name
    pr_file = [subname S.pr_file];
    % load each data file
    [~,~,acc] = xlsread(fullfile(S.acc_dir,acc_file));
    try
        [~,~,pr] = xlsread(fullfile(S.pr_dir,pr_file));
    catch
        % if there are no pain ratings: create empty variables
        pr=[];
        S.acc_cen = ''; % cannot centre acc data with respect to pr
    end
    % housekeeping: remove first header
    acc(1,:)=[];
    
    %% get dates/times
    
    % for accel data:
    % column of file with date/time
    acc_dt_col = ismember(acc(1,:),S.acc_datehead);
    % datetime data
    acc_dt_dat = acc(2:end,acc_dt_col);
    % parse into dates and times
    acc_ds = acc_dt_dat(:,1);
    acc_ds = cellstr(datestr(datenum(acc_ds,'dd/mm/yyyy'),29));
    acc_ts = acc_dt_dat(:,2);
    acc_ts = cellfun(@(x) datestr(x,13),acc_ts,'UniformOutput',0);
    
    % for PR data:
    if ~isempty(pr)
        % column of file with date/time
        pr_dt_col = ismember(pr(1,:),S.pr_datehead);
        % datetime data
        pr_dt_dat = pr(2:end,pr_dt_col);
        % fix Excel bug that causes 00:00 times to not be imported via xlsread
        pr_dt_dat(cellfun(@length,pr_dt_dat)~=19)=strcat(pr_dt_dat(cellfun(@length,pr_dt_dat)~=19),' 00:00:00');
        % find indices of first unique entry and remove duplicates
        [~,pr_dt_uni,~] = unique(pr_dt_dat,'stable');
        pr_dt_dat = pr_dt_dat(pr_dt_uni);
        % parse into dates and times
        temp = cellfun(@(x) strsplit(x,' '),pr_dt_dat,'UniformOutput',0);
        pr_ds = cellfun(@(x) x(1),temp,'UniformOutput',0);
        pr_ts = cellfun(@(x) x(2),temp,'UniformOutput',0);
        pr_ds=[pr_ds{:}]'; % dates
        pr_ds = cellstr(datestr(datenum(pr_ds,'dd/mm/yyyy'),29));
        pr_ts=[pr_ts{:}]'; % times
    end
    
    
    %% analyse pain ratings data (if the file exists)
    if ~isempty(pr)
        % column of file with pain ratings data
        pr_col = strmatch(S.pr_data,pr(1,:));
        % pain ratings data
        pr_dat = pr(2:end,pr_col);
        % values only from unique dates/times
        pr_dat = pr_dat(pr_dt_uni);
        
        % find indices of data according to the specified time window
        if strcmp(S.pr_tw,'daily')
            % unique dates and their index
            [pr_tu,~,pr_ti] = unique(pr_ds,'stable');
            % time column is empty
            pr_tu(:,2)=cell(length(pr_tu),1);
            pr_tu(:,2)={''};
        elseif strcmp(S.pr_tw,'all')
            pr_tu = {'all',''};
            pr_ti = ones(length(pr_ds),1);
        else
            error('this time window is not yet programmed!');
        end

        % calculate functions over specified time window
        for fi = 1:length(S.pr_fun)
            % create column header
            pr_head(1,fi) = {[genvarname(S.pr_data) '_' genvarname(S.pr_fun(fi).name)]};
            for i = 1:size(pr_tu,1)
                % get data
                X = cell2mat(pr_dat(pr_ti==i,:));
                % apply function
                eval(['fout = ' S.pr_fun(fi).fun ';']);
                pr_out(i,fi) = fout;
            end
        end 
        
    else
        pr_head = {};
        pr_out = [];
    end
    
    %% analyse accel data
    
    % column of file with pain ratings data
    acc_col = find(ismember(acc(1,:),S.acc_data));
    % accel data
    acc_dat = acc(2:end,acc_col);

    % find indices of data according to the specified time window
    if strcmp(S.acc_tw,'daily')
        % unique dates and their index
        [acc_tu,~,acc_ti] = unique(acc_ds,'stable');
        % time column is empty
        acc_tu(:,2)=cell(length(acc_tu),1);
        acc_tu(:,2)={''};
    elseif strcmp(S.acc_tw,'all')
        acc_tu = {'all',''};
        acc_ti = ones(length(acc_ds),1);
    else
        error('this time window is not yet programmed!');
    end

    
    % calculate functions over specified time window
    for fi = 1:length(S.acc_fun)
        % create column header
        acc_head(1,fi) = {[genvarname(S.acc_data) '_' genvarname(S.acc_fun(fi).name)]};
        for i = 1:size(acc_tu,1)
            % get data
            X = cell2mat(acc_dat(acc_ti==i,:));
            % apply function
            eval(['fout = ' S.acc_fun(fi).fun ';']);
            acc_out(i,fi) = fout;
        end
    end  
    
    
    %% output dates and data
    if isempty(pr)
        out_tu = acc_tu;
        %acc_tu_i = 1:size(out_tu,1);
        %out_data = acc_out;
        acc_out = num2cell(acc_out);
    else
    % if the PR data exists, this will require interleaving dates/times
    % from both data types.
    % requires matching up the PR and accel dates/times
    % finds unique dates as well as indices of those unique outputs that
    % match the rows of each data type (PR and accel)
        temp = [pr_tu;acc_tu];
        [~,i1,i2] = unique(cell2mat(temp),'rows');
        out_tu = temp(i1,:);
        pr_tu_i = 1:size(pr_tu,1);
        acc_tu_i = size(pr_tu,1)+1:size(pr_tu,1)+size(acc_tu,1);
        pr_tu_i = i2(pr_tu_i);
        acc_tu_i = i2(acc_tu_i);
        
        % output data arrays
        temp = cell(size(out_tu,1),size(acc_out,2));
        temp(acc_tu_i,:) = num2cell(acc_out);
        acc_out = temp;
        
        temp = cell(size(out_tu,1),size(pr_out,2));
        temp(pr_tu_i,:) = num2cell(pr_out);
        pr_out = temp;
    end

    
    
    %% create output cell array and save
    % add PR data output headers
    allhead = horzcat(pr_head,acc_head);
    D(nHead(1),nHead(2)+1:nHead(2)+length(allhead)) = allhead;
    % add date/time data to output
    D(nHead(1)+1:nHead(1)+size(out_tu,1),1:nHead(2)) = out_tu;
    % add PR data to output
    D(nHead(1)+1:nHead(1)+size(out_tu,1),nHead(2)+1:nHead(2)+size(pr_out,2)) = pr_out;
    % add accel data to output
    D(nHead(1)+1:nHead(1)+size(out_tu,1),nHead(2)+size(pr_out,2)+1:nHead(2)+size(pr_out,2)+size(acc_out,2)) = acc_out;
    % save 
    if S.saveeach
        xlswrite(fullfile(S.out_dir,[subname S.out_file]),D); 
    else
        error('saving multiple subjects in one file not yet implemented');
    end
    
end
    