function doPlot3DTopo(data,locs,view)

    % this function is just a shell to call topoplot and hide a bunch of
    % settings to simplify things for beginners, assumes a data vector of a
    % length that matches the number of electrode locations
    
    % set the background colour to white
    set(gcf,'color','w');
    
    % set up the 3D headmap
    headplot('setup',locs,'spline_setup');
    headplot(data,'spline_setup','electrodes','off','view',view);
    
end