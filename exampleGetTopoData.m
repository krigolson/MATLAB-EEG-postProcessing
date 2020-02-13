clear all;
close all;
clc;

% load the sample data and the associated location file
load('erpData.mat');
load('channelLocations.mat');

% create dw data for each participant
dwERP = squeeze(erpData(:,:,1,:) - erpData(:,:,2,:));

% get the topo data
topoData = doGetTopoData(erpData,250,5,0,1,0);