clear all;
close all;
clc;

% load the sample data and the associated location file
load('erpData.mat');
load('channelLocations.mat');

% create a mean ERP waveform by collapsing accross participants (4th
% dimenion)
meanERP = mean(erpData,4);

% create a difference waveform
dw = squeeze(meanERP(:,:,1) - meanERP(:,:,2));

% assuming we know channel 26 is "the channel" find the time of the maximal
% difference and plot the topo map at that time point
[maxERP maxPoint] = max(dw(26,:));

% get topo data at the maxmimum point identified above
topoData = dw(:,maxPoint);

% round to one decimal point
topoData = round(topoData,1);

% plot a 2D topomap
doPlotNumericalTopo(topoData,channelLocations,' %');