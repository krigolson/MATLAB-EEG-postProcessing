function [topoData] = doMake3DTopoMovie(data,locs,scaled,view,fileName)

    % this function makes a topographic movie from EEG data and saves it as an .avi file 
    % the data must be in a channels x time format
    % locs files must be in the standard EEGLAB format
    % scaled is whether all of the topos are scaled to the max and min of the
    % full range of time points or whether the topos are scaled within each frame (time
    % point)
    % view is the view angle for the 3D topomap
    % fileName is the output filename

    % create and open a new video object
    vidObj = VideoWriter(fileName);
    open(vidObj);

    % set up the 3D headmap
    headplot('setup',locs,'spline_setup');
    
    % compute max and min values for scaled map if needed
    scaledMax = max(max(data));
    scaledMin = min(min(data));
    
    % cycle through each time point
    for counter = 1:size(data,2)

        % set the background colour to white
        set(gcf,'color','w');
        % make the 3D headplot
        if scaled == 1
            headplot(data(:,counter),'spline_setup','maplimits',[scaledMin scaledMax],'electrodes','off','view',view);
        else
            headplot(data(:,counter),'spline_setup','electrodes','off','view',view);
        end
        % grab the current screen frame
        currentFrame = getframe;
        % write the frame to the video file
        writeVideo(vidObj,currentFrame);

    end

    % close the video file
    close(vidObj);
    
end


    
    