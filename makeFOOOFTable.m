function fooofTable = makeFOOOFTable(peakData,aperiodicData,meanData,titles)

%Peak data is a parameter(centralFreq,power,width) x condition x participant matrix 
%Aperiodic data is a parameter(slope,intercept) x condition x participant matrix 
%Mean data is a condition x participant matrix with meanPower (in window)


numConditions = size(peakData,2);
numParticipants = size(peakData,3);

ppData = squeeze(peakData);
ppData = permute(ppData,[2,1,3]);
ppData = reshape(ppData,[numConditions*3,numParticipants])';
ppData(ppData==0) = NaN;
apData = squeeze(aperiodicData);
apData = permute(apData,[2,1,3]);
apData = reshape(apData,[numConditions*2,numParticipants])';
apData(apData==0) = NaN;
mpData = squeeze(meanData)';
mpData(mpData==0) = NaN;
fooofTable = array2table([ppData,apData,mpData],"VariableNames",titles);