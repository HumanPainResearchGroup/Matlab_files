%% plot VOI data as dots and boxplots

% PREREQUISITES: 
% - VOI data file(s) in excel LONG format (e.g. output from Convert_VOImat_to_excel.m)
close all
P.pth = 'C:\Data\Catastrophising study\SPMstats\Source\1_grp\_Time_Int_Exp_Subject_spm_t416_478\ExpBMed_clusters';
% xlsx files must be LONG format. Values in each factor columns should be
% text labels (not numerical) as these will be used to label the charts.
P.filenames = {'VOI*.xlsx'}; % use * to load multiple files, each with separate plots. Filename must have extension
% name of data column
P.datnames = {'Data'};
% y axis label (should correspond to data type)
P.yaxisnames = {'mean cluster activity (�V)'};
%factor names:
%P.xaxisnames = {'Stimulus Intensity'}; % header of factor represented on x axis
P.xaxisnames = {'Stimulus Intensity'}; % header of factor represented on x axis
P.subplotnames = {'LOI vs Baseline'}; % OPTIONAL factor that splits x axis into subplots
%P.groupingnames = {'Expectation Cues'}; % factor of main interest for comparison - plots as different colours
P.groupingnames = {'Expectation Cues'}; % factor of main interest for comparison - plots as different colours
% other options:
P.groupcolours = [1 0 0; 0 0 1]; % colours of each group on each plot: if two groups, two colours are needed.
P.textsize = 12; % size of text
P.label_points = 1; % 1 = labels points with subject name; 0 = no labelling
P.plot_sep_fg=0;
%filenames = {'N132_data_longformat.xlsx','N124_data_longformat.xlsx','P268_data_longformat.xlsx'};
%datnames = {'N132','N124','P268'};
%yaxisnames = {'N132 Amplitude (�V)','N124 Amplitude (�V)','P268 Amplitude (�V)'};

% 1 = plot, 0 = no plot. Will align plots horizonally in figure, so a small number should be slected (2-3).
P.plottypes = {
    'jitter', 0;
    'boxplot', 1;
    'violin', 0;
    'confidence',1;
    };
    
P.save_figure=1;

%% call function
plotdotbox(P)