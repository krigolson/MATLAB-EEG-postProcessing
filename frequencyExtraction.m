function [fftPower freqtopo] = frequencyExtraction(data,frequencies,channel,bandWidth)

% function to do a max peak detection
% data needs to be channels x time x conditions x participants
% by O. Krigolson

    numberOfConditions = size(data,3)
    numberOfParticipants = size(data,4)
    startSearch = find(frequencies == bandWidth(1));
    endSearch = find(frequencies == bandWidth(2));
    
    for conditionCounter = 1:numberOfConditions
        
        for subjectCounter = 1:numberOfParticipants
            
            frequencyData = data(:,startSearch:endSearch,conditionCounter,subjectCounter);
            frequencyTopoData = mean(frequencyData,2);
            fftPower(subjectCounter,conditionCounter) = frequencyTopoData(channel);
            freqtopo(:,subjectCounter,conditionCounter) = frequencyTopoData;
            
        end
        
    end
    
end