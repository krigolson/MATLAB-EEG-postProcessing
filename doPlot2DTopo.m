function doPlot2DTopo(data,locs)

    % this function is just a shell to call topoplot and hide a bunch of
    % settings to simplify things for beginners, assumes a data vector of a
    % length that matches the number of electrode locations
    
    % set the background colour to white
    set(gcf,'color','w');
    topoplot(data,locs,'electrodes','off','whitebk','on','shading','interp','plotrad',0.5);
    axis([-0.6 0.6 -0.6 0.6]);
    
end