function  makeFOOOFPlot(aperiodicData,powerData,task,channel,peak,fooofFolder,legendText)

%Aperiodic data is a participant-meaned matrix of aperiodic series data
%for a given channel and task with the dimensions of frequency x condition. 
numConditions = size(aperiodicData,2);

f= figure;
f.WindowState = 'maximized';

hold on

colours(:,1) = [0.69 0.27 0.96];
colours(:,2) = [0.18 0.44 0.82];
colours(:,3) = [0.11 0.69 0.42];
colours(:,4) = [0.91 0.11 0.32];

minSpot = min(min(powerData));
maxSpot = max(max(powerData));

for condition = 1:numConditions
    a(condition) = plot(aperiodicData(:,condition),'Color',colours(:,condition),'LineWidth',2);
    hold on

    b(condition) = plot(powerData(:,condition),'Color',colours(:,condition),'LineStyle','--','LineWidth',2);
    hold on

end

xlim([1,30])

rectangle('Position',[peak(1)-peak(3),0,peak(3)*2,maxSpot-minSpot],'FaceColor',[0.72 0.72 0.72 0.25],'EdgeColor','none');
yline(0,'Color', [0 0 0],'LineWidth',1.5)

s=gca;
s.XAxis.TickLength = [0 0];
s.XAxis.FontSize = 25;
s.YAxis.TickLength = [0 0];
s.YAxis.FontSize = 25;

l = legend([a,b(1)],legendText);
l.Box = "off";
fontsize(l,20,"points");

ylabel('Power')
xlabel('Frequency')

saveas(f,fullfile(fooofFolder,['FOOOF_' task '_' channel '.png']))
