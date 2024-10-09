function [FOOOFResults] = doFOOOF(EEG,channel,settings,fRange)

x1 = 1; %Create a window we can slide through as we go
x2 = 2000;

counter = 1;

while x2 < size(EEG.data,2) %as we slide through the data, 
    [x(:,counter), freqs1] = pwelch(EEG.data(channel,x1:x2), 500, 250, 500, 500); %Compute welch's PSD on this window
    counter = counter + 1; %Slide the window over for the next round
    x1 = x2 + 1;%Slide the window over for the next round
    x2 = x2 + 2000;%Slide the window over for the next round
end
newX = squeeze(mean(x,2)); %Take a mean of the power spectra throughout the entire recording

% Transpose, to make inputs row vectors
freqs1 = freqs1';

% Run FOOOF
FOOOFResults = fooof(freqs1, newX, fRange, settings,true);