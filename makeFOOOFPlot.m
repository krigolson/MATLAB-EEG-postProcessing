function  makeFOOOFPlot(aperiodicData,powerData,task,channel)

%Aperiodic data is a participant-meaned matrix of aperiodic series data
%for a given channel and task with the dimensions of frequency x condition. 
numConditions = size(aperiodicData,2);

f= figure;
f.WindowState = 'maximized';

title(['FOOOF results for ' task ' Task - ' channel])
hold on

colours(:,1) = 'black';
colours(:,2) = 'blue';
colours(:,3) = 'red';
colours(:,4) = 'green';


for condition = 1:numConditions
    a(condition) = plot(aperiodicData(:,condition),'Color',colours(condition),'LineWidth',2);
    hold on

    b(condition) = plot(powerData(:,condition),'Color',colours(condition),'LineStyle','--','LineWidth',2);
    hold on

end

legend([a,b(1)],{'Aperiodic Fit - No Shirt','Aperiodic Fit - Long Sleeve','Aperiodic Fit - Short Sleeve','Aperiodic Fit - Experimental','Power Spectra'})
legend boxoff

ylabel('Power')
xlabel('Frequency')
