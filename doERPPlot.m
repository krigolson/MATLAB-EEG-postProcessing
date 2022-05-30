function doERPPlot(time,data)

    % this function plots an ERP waveform. The whole point of this is to hide a
    % bunch of settings for learning purposes
    
    % line width
    lineWidth = 3;
    
    plot(time,data,'LineWidth',lineWidth);
    xlabel('Time (ms)');
    ylabel('Voltage (uV)');
    % make the background white
    set(gcf,'color','w');
    % get the handle for the axis
    ax = gca;
    % turn off the plot box
    set(ax,'box','off');
    % set axis font and size
    ax.FontName = 'Arial';
    ax.FontSize = 20;
    % set the tick length to zero
    ax.TickLength = [0 0];
    % set hold on so plot is no erased
    hold on;
    x(1) = time(1);
    x(2) = time(end);
    y(1) = 0;
    y(2) = 0;
    hold on;
    % add a line through zero
    line(x,y,'Color','black','LineWidth',1);
hold off;

end