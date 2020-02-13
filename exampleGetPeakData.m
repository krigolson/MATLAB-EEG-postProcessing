clear all;
close all;
clc;

% load the sample data and the associated location file
load('erpData.mat');
load('channelLocations.mat');

% create dw data for each participant
dwERP = erpData(:,:,1,:) - erpData(:,:,2,:);

% create a time vector for peak detection search, we know we have data from
% -200 to 598 ms at a 500 Hz sampling rate
timeVector = [-200:2:598];

% get the topo data
peakData = doPeakDetection(dwERP,timeVector,26,250,25,0);