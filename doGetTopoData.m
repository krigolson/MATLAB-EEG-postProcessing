function [topoData] = doGetTopoData(data,centre,edge,type,minOrMax,channel)

    % function to get topo data from channels x time x conditions x
    % participant matrix OR a channels x time x participant matrix
    % data is the 4D matrix - channels x time x conditions x
    % participants OR a 3D matrix - channels x time x participants
    % centre is the centre point of the search
    % edge is the +/- minus number of data points
    % type is mean (== 0) or max (== 1) or individual max (==3)
    % mean will average within the window, max will find individual max
    % topo within window based on maximum value and average those +/- the
    % edge for the individual and individual max will find where a given
    % channel is max and then get that topo for each person at that time
    % point
    % minOrMax defines whether you want to find the most negative or most
    % positive point, 0 == min, 1 == max
    % channel is only used for individual max searches
    
    if ndims(data) == 3
    
        if type == 0
            
            tempData = data(:,centre-edge:centre+edge,:);
            tempData = squeeze(mean(tempData,2));
            if minOrMax == 1
                [maxs maxPoints] = max(tempData,[],1);
            else
                [maxs maxPoints] = min(tempData,[],1);
            end
            topoPercents(1:size(tempData,1)) = 0;
            for counter = 1:size(tempData,1)
                [foundTopo foundLocation] = find(maxPoints == counter);
                topoPercents(counter) = sum(foundTopo)/size(tempData,2)*100;
            end
            topoData.mean = mean(tempData,2);
            topoData.individual = tempData;
            topoData.percents = topoPercents;
            
        end
        if type == 1
            if minOrMax == 1
                tempData = data(:,centre-edge:centre+edge,:);
                for subjectCounter = 1:size(tempData,3)
                    subjectData = [];
                    subjectData = squeeze(tempData(:,:,subjectCounter));
                    [chanMax chanMaxLocation] = max(subjectData,[],2);
                    [globalMax globalLocation] = max(chanMax);
                    maxLocation = chanMaxLocation(globalLocation);
                    individualTopoData(:,subjectCounter) = squeeze(subjectData(:,maxLocation));
                    maximumChannel(subjectCounter) = globalLocation;
                end
                meanTopoData = mean(individualTopoData,2);
                for counter = 1:size(tempData,1)
                    [foundTopo foundLocation] = find(maximumChannel == counter);
                    topoPercents(counter) = sum(foundTopo)/size(tempData,3)*100;
                end
                topoData.mean = meanTopoData;
                topoData.individual = individualTopoData;
                topoData.percents = topoPercents;
            end
            if minOrMax == 0
                tempData = data(:,centre-edge:centre+edge,:);
                for subjectCounter = 1:size(tempData,3)
                    subjectData = [];
                    subjectData = squeeze(tempData(:,:,subjectCounter));
                    [chanMax chanMaxLocation] = min(subjectData,[],2);
                    [globalMax globalLocation] = min(chanMax);
                    maxLocation = chanMaxLocation(globalLocation);
                    individualTopoData(:,subjectCounter) = squeeze(subjectData(:,maxLocation));
                    maximumChannel(subjectCounter) = globalLocation;
                end
                meanTopoData = mean(individualTopoData,2);
                for counter = 1:size(tempData,1)
                    [foundTopo foundLocation] = find(maximumChannel == counter);
                    topoPercents(counter) = sum(foundTopo)/size(tempData,3)*100;
                end
                topoData.mean = meanTopoData;
                topoData.individual = individualTopoData;
                topoData.percents = topoPercents;
            end 
        end
        if type == 2
             if minOrMax == 1
                tempData = data(:,centre-edge:centre+edge,:);
                for subjectCounter = 1:size(tempData,3)
                    subjectData = [];
                    subjectData = squeeze(tempData(:,:,subjectCounter));
                    [chanMax chanMaxLocation] = max(subjectData(channel,:));
                    individualTopoData(:,subjectCounter) = subjectData(:,chanMaxLocation);
                    maximumChannel(subjectCounter) = channel;
                end
                meanTopoData = mean(individualTopoData,2);
                for counter = 1:size(tempData,1)
                    [foundTopo foundLocation] = find(maximumChannel == counter);
                    topoPercents(counter) = sum(foundTopo)/size(tempData,3)*100;
                end
                topoData.mean = meanTopoData;
                topoData.individual = individualTopoData;
                topoData.percents = topoPercents;
            end           
             if minOrMax == 0
                tempData = data(:,centre-edge:centre+edge,:);
                for subjectCounter = 1:size(tempData,3)
                    subjectData = [];
                    subjectData = squeeze(tempData(:,:,subjectCounter));
                    [chanMax chanMaxLocation] = min(subjectData(channel,:));
                    individualTopoData(:,subjectCounter) = subjectData(:,chanMaxLocation);
                    maximumChannel(subjectCounter) = channel;
                end
                meanTopoData = mean(individualTopoData,2);
                for counter = 1:size(tempData,1)
                    [foundTopo foundLocation] = find(maximumChannel == counter);
                    topoPercents(counter) = sum(foundTopo)/size(tempData,3)*100;
                end
                topoData.mean = meanTopoData;
                topoData.individual = individualTopoData;
                topoData.percents = topoPercents;
            end             
        end  
        
    else
        
    end
    
end    