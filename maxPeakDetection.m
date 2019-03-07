function [peaks peaktimes peaktopo] = maxPeakDetection(data,times,channel,peakTime,peakWidth)

% function to do a max peak detection
% data needs to be channels x time x conditions x participants
% by O. Krigolson

    numberOfConditions = size(data,3);
    numberOfParticipants = size(data,4);
    startSearch = find((peakTime-peakWidth) == times);
    endSearch = find((peakTime+peakWidth) == times);
    
    for conditionCounter = 1:numberOfConditions
        
        for subjectCounter = 1:numberOfParticipants
            
            peakData = squeeze(data(:,:,conditionCounter,subjectCounter));
            peakMaxData = squeeze(peakData(channel,:));
            [maxPeak maxPosition] = max(peakMaxData(startSearch:endSearch));
            peakPosition = startSearch+maxPosition-1;
            peaks(subjectCounter,conditionCounter) = maxPeak;
            peaktimes(subjectCounter,conditionCounter) = times(peakPosition);
            topodata = data(:,peakPosition,conditionCounter,subjectCounter);
            peaktopo(:,subjectCounter,conditionCounter) = topodata;
            
        end
        
    end
    
end