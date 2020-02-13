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

% make a topographic movie
doMake3DTopoMovie(dw,channelLocations,0,[50 120],'sampleMovie.avi')