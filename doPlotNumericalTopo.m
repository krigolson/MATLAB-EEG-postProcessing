function doPlotNumericalTopo(data,locs,tag)

    % this function is just a shell to call topoplot and plot the numbers
    % in data as opposed to voltages with interpolation, tag is an optional
    % bit of text to append to the numerical values
    
    % change the electrode names to the values in data
    for counter = 1:length(data)
        locs(counter).labels = [num2str(data(counter)) tag];
    end
    
    % set the background colour to white
    set(gcf,'color','w');
    topoplot(data,locs,'style','blank','electrodes','labels','whitebk','on','efontsize',16);
    axis([-0.6 0.6 -0.6 0.6]);
    
end