function [peaks peaktimes peaktopo] = meanPeakDetection(data,times,channel,peakTime,peakWidth)

% function to do a max peak detection
% data needs to be channels x time x conditions x participants
% by O. Krigolson

    numberOfConditions = size(data,3);
    numberOfParticipants = size(data,4);
    startSearch = find((peakTime-peakWidth) == times);
    endSearch = find((peakTime+peakWidth) == times);
    
    for conditionCounter = 1:numberOfConditions
        
        conditionCounter
        
        for subjectCounter = 1:numberOfParticipants
            
            subjectCounter
            
            peakData = squeeze(data(:,:,conditionCounter,subjectCounter));
            peakMaxData = squeeze(peakData(channel,:));
            [meanPeak] = mean(peakMaxData(startSearch:endSearch));
            peaks(subjectCounter,conditionCounter) = meanPeak;
            peaktimes(subjectCounter,conditionCounter) = peakTime;
            topodata = mean(data(:,startSearch:endSearch,conditionCounter,subjectCounter),2);
            peaktopo(:,subjectCounter,conditionCounter) = topodata;
            
        end
        
    end
    
end