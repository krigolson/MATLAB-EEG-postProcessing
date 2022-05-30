function peakPoint = findPeakPoint(theTimes,theTime)

    % simple function to find a point in a time vector
    for i = 1:length(theTimes)

        if theTimes(i) >= theTime
            peakPoint = i;
            break
        end

    end

end