function [peakData] = doPeakDetection(data,times,channel,peakTime,peakWidth,type)

    % function to do peak detection
    % data needs to be channels x time x conditions x participants
    % by O. Krigolson
    % need to pass in the channel to search on
    % need to pass in the peak time and the width of the search
    % need to pass in the type, 0 for mean, 1 for max, 2 for min

    numberOfConditions = size(data,3);
    numberOfParticipants = size(data,4);
    for counter = 1:length(times)
        if peakTime - peakWidth >= times(counter)
            startSearch = counter;
        end
    end
    for counter = 1:length(times)
        if peakTime + peakWidth >= times(counter)
            endSearch = counter;
        end
    end

    for conditionCounter = 1:numberOfConditions
        for subjectCounter = 1:numberOfParticipants
            peakData = squeeze(data(:,:,conditionCounter,subjectCounter));
            peakSqueezeData = squeeze(peakData(channel,:));
            
            if type == 0
                [meanPeak] = mean(peakSqueezeData(startSearch:endSearch));
                peaks(subjectCounter,conditionCounter) = meanPeak;
                peakTimes(subjectCounter,conditionCounter) = peakTime;
            end
            
            if type == 1
                [maxPeak maxPosition] = max(peakSqueezeData(startSearch:endSearch));
                peakPosition = startSearch+maxPosition-1;
                peaks(subjectCounter,conditionCounter) = maxPeak;
                peakTimes(subjectCounter,conditionCounter) = times(peakPosition);
            end

            if type == 2
                [maxPeak maxPosition] = min(peakSqueezeData(startSearch:endSearch));
                peakPosition = startSearch+maxPosition-1;
                peaks(subjectCounter,conditionCounter) = maxPeak;
                peakTimes(subjectCounter,conditionCounter) = times(peakPosition);
            end
            
        end
    end
    
    peakData = [];
    peakData.peaks = peaks;
    peakData.times = peakTimes;
    
end