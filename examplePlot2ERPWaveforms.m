clear all;
close all;
clc;

% load the sample data and the associated location file
load('erpData.mat');
load('channelLocations.mat');

% create a mean ERP waveform by collapsing accross participants (4th
% dimenion)
meanERP = mean(erpData,4);

% so, for this plot to be accurate we need to determine the time points for
% the x axis. You have to start somewhere, so we will assume that you know
% that the epochs start at -200 ms and the sampling rate if 500 Hz so it is
% 2 ms a sample. Because there are 400 data points this means that the plot
% range is from -200 to 598 ms. Why not 600 ms? Because 0 ms is a time
% point so you would need 401 data points to get from -200 to 600 ms.

% create a time vector
timeVector = [-200:2:598];

% plot the ERP waveform - here I am telling it to plot channel 26
doERPPlot(timeVector,meanERP(26,:,1));
% you need to use hold and set it to on to draw over top of the existing
% plot and not erase it
hold on;
doERPPlot(timeVector,meanERP(26,:,2));
hold off;