function [zmap_not_corrected zmap_voxel zmap_cluster] = wavAnalysis(data,electrode,conditions,freq_cutoff,time_cutoff,n_permutations,alpha_value)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Written by Chad C. Williams, PhD student in the Krigolson Lab, 2019   %%
%%Code based off of Micheal X. Cohen                                    %%
%%small modiications by Olav Krigolson                                   %%
%%See http://mikexcohen.com/lectures.html                               %%
%%Specifically, his video on permutations: https://youtu.be/-85FAQwD49Q %%   
%%And on multiple comparison corrections: https://youtu.be/I0qoP7yvP-4  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sample call
% [ttest permutation cluster] = wavAnalysis(data,52,[1 2],30,500,1000,0.05);

%Shuffle the Random Number Generator
rng('default');

%Data should be organized as: [Electrode, Freq, Time, Condition, Participants] - This is the structre Micheal X. Cohen uses
%Note: The structure name of this the WAV data is summary.WAV.raw (relevant for a handful of lines down)

%Extract data
WAV_data = squeeze(data(electrode,1:freq_cutoff,1:time_cutoff,conditions,:)); %Cuts data to the specifications indicated above
WAV_data1 = permute(squeeze(WAV_data(:,:,1,:)),[3,1,2]); %Extracts condition 1 and reorganizes dimensions to [Participants, Frequency, Time]
WAV_data2 = permute(squeeze(WAV_data(:,:,2,:)),[3,1,2]); %Extracts condition 2 and reorganizes dimensions to [Participants, Frequency, Time]

%% TTest - Conduct a t-test at each point of the wavelet without any corrections
TTest_results = []; %Clear variable
for freq = 1:freq_cutoff %Cycle through all frequencies
    for time = 1:time_cutoff %Cycle through all timepoints
        TTest_results(freq,time) = ttest(WAV_data1(:,freq,time),WAV_data2(:,freq,time)); %Conduct a simple t-test at each point of the wavelets
    end
end

% Display T-Test results (simply significant or not significant)
figure(1);
subplot(3,3,1);
imagesc(flipud(TTest_results));set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot data. The labels assume 1 Hz resolution
title('T Test Results (0 or 1)');

%% Permutations Without Multiple Comparison Corrections
%As these values are not corrected for multiple comparison, do not stop after this section, you must correct for multiple comparisons using the next section

%Determine Initial Distributions and Statistical Cutoffs
perm_dist = permute(cat(1,WAV_data1,WAV_data2),[2,3,1]); %Combine two conditions by aligning the participant dimension (effectively stacking both conditions), reorganize dimensions to [Frequency, Time, Participants]
permmaps = zeros(n_permutations,freq_cutoff,time_cutoff); %Null hypothesis matrix of all zeros
z_crit = abs(norminv(alpha_value/2)); %Determine z-crit value - this is two tailed with alpha set to your parameter

for perm = 1:n_permutations %Cycle through all permutations
    random_perm = randperm(size(perm_dist,3)); %Randomize indices for mixing the participant*condition dimension
    temp_perm = perm_dist(:,:,random_perm); %Reorganize participant data to these randomized timepoints
    permmaps(perm,:,:) = mean((temp_perm(:,:,1:size(WAV_data,4))-temp_perm(:,:,size(WAV_data,4)+1:end)),3); %Finds a difference between the first and second half of the participant*condition dimension (representing the two conditions) and averages across participants, leaving us with [Frequency, Time] for each permutataion
end

mean_h0 = squeeze(mean(permmaps)); %Determine null mean across permutations
std_h0 = squeeze(std(permmaps)); %Determine null standard deviation across permutations

WAV_diff = mean(squeeze(WAV_data(:,:,1,:)-WAV_data(:,:,2,:)),3); %Creates a difference WAV (Condition 1 - Condition 2), averaged across partitipants
zmap_cluster = (WAV_diff-mean_h0)./std_h0; %Standardizes data based on the mean and standard deviation of the permutated null distribution
zmap_cluster(abs(zmap_cluster)<z_crit) = 0; %Removes any value that does not equal or surpass the z-crit values (e.g., non significant values).
zmap_not_corrected = zmap_cluster; %Saves this variable (the zmap variable is manipulated in the cluter size based permutations)

%Display Significance-Based Permutation Results
%Please note: Here I simply plot the values as significant vs not, but in manuscripts I suggest you rather put contour lines around significant portions of your original data. You do not want to zero out non-significant data as people want to see the whole range of data, regardless of significance (this is my opinion, not a standard)

%Plotting T-Test Significance
subplot(3,3,2)
imagesc(flipud(zmap_not_corrected)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot data. The labels assume 1 Hz resolution
title('T-Test Sigificance');
%Plotting Original Difference Data
subplot(3,3,3) 
imagesc(flipud(WAV_diff)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot data. The labels assume 1 Hz resolution
title('Original Wavelet Difference Data');
%% Permutations with Multiple Comparison Corrections
%Here, we will correct multiple comparisons as derived in the last sections
%We will be doing this in two ways (your choice what to use)
% 1)Looking at individual voxels
% 2)Looking at cluster sizes

%% Permutation of Individual Voxels
%Create Null Distribution
max_vals = zeros(n_permutations,2); %Null distribution for individual voxels

%Determine Min/Max Z-Values of Each Permutation
for perms = 1:n_permutations %Cycle through number of permutations
    temp = permmaps(perms,:,:); %Extract current permutation
    max_vals(perms,:) = [min(temp(:)) max(temp(:))]; %Extracts min and max Z-Values
end

%Determine the Voxel Z-Crit Cutoffs
thresh_lo = prctile(max_vals(:,1),100*(alpha_value/2)); %Determine low cutoff
thresh_hi = prctile(max_vals(:,2),100-(100*(alpha_value/2))); %Determine high cutoff

zmap_voxel = WAV_diff; %Carry over the difference data into something we can manipulate
zmap_voxel(zmap_voxel>thresh_lo & zmap_voxel < thresh_hi) = 0; %If specific voxels are as extreme or more extreme than cutoffs, then change them to zero
zmap_voxel = vec2mat(zmap_voxel,time_cutoff); %Last step turns it into a vector, so turn it back into a matrix

%% Plotting Voxel Permutation Results
%Please note: Here I simply plot the values that are significant, but in manuscripts I suggest you rather put contour lines around significant portions of your original data. You do not want to zero out non-significant data as people want to see the whole range of data, regardless of significance (this is my opinion, not a standard)

%Plotting Voxel Distribution 
%subplot(3,3,4)
%hist(max_vals,1000); %Plot histogram of both the min and max distributions
%voxel_histogram_ylim = ylim; %Determine the y-axis limits
%line([prctile(max_vals(:,1),100*alpha_value/2) prctile(max_vals(:,1),100*alpha_value/2)],voxel_histogram_ylim,'Color',[1 0 0]); %Add line at low cutoff value
%line([prctile(max_vals(:,2),100-100*alpha_value/2) prctile(max_vals(:,2),100-100*alpha_value/2)],voxel_histogram_ylim,'Color',[1 0 0]) %Add line at high cutoff value
%title('Histogram of Min and Max Distributions');

%Plotting Voxel Significance
%subplot(3,3,5)
%imagesc(flipud(zmap_voxel)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot permutated data. The labels assume 1 Hz resolution
%title('Voxel Significance');

%Plotting Original Difference Data
%subplot(3,3,6) 
%imagesc(flipud(WAV_diff)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot original data. The labels assume 1 Hz resolution
%title('Original Wavelet Difference Data');
%% Permutations with Cluster Sizes

%Create Null Distribution
max_cluster_size = zeros(1,n_permutations); %Null distribution for cluster sizes

%Determine Max Cluster Size of Each Permutation
for perms = 1:n_permutations %Cycle through number of permutations
    threshimg = squeeze(permmaps(perms,:,:)); %Extract the current permutation
    threshimg = (threshimg - mean_h0)./std_h0; %Standardize the permutation
    threshimg(abs(threshimg)<z_crit) = 0; %Set any non-significant values to 0
    
    %Determine Max Cluster Size
    islands = bwconncomp(threshimg); %Determines the clusters within the permutation wavelet
    if numel(islands.PixelIdxList)>0 %This statement only runs if at least one cluster has been found, otherwise cluster size remains at zero
        tempclustsize = cellfun(@length,islands.PixelIdxList); %Lists the sizes (in pixels) of all clusters
        max_cluster_sizes(perms) = max(tempclustsize); %Extracts the largest cluster size of this permutation
    end
end

%Determine significance of clusters
cluster_thresh = prctile(max_cluster_sizes,100-(100*alpha_value/2)); %Determine the cluster size at Z-Crit value
islands = bwconncomp(zmap_cluster); %Determine the size of all previously significant clusters (without corrections)
for i=1:islands.NumObjects %Cycle through all clusters
   if numel(islands.PixelIdxList{i}==i)<cluster_thresh %Determine if current cluster is as large as or greater than our cutoff
       zmap_cluster(islands.PixelIdxList{i})=0; %If the cluster is not significant, change the size to 0
   end
end

%% Plotting Cluster Results
%Please note: Here I simply plot the values that are significant, but in manuscripts I suggest you rather put contour lines around significant portions of your original data. You do not want to zero out non-significant data as people want to see the whole range of data, regardless of significance (this is my opinion, not a standard)

%Plotting Cluster Distribution 
subplot(3,3,7) 
hist(max_cluster_sizes,40); %Plot histogram of max cluster size from all permutations
cluster_histogram_ylim = ylim; %Determine the y-axis limits
line([prctile(max_cluster_sizes,100-(100*alpha_value/2)) prctile(max_cluster_sizes,100-(100*alpha_value/2))],cluster_histogram_ylim,'Color',[1 0 0]); %Add line at cutoff cluster size
title('Histogram of Max Cluster Size for All Permutations');

%Plotting Cluster Significance
subplot(3,3,8) 
imagesc(flipud(zmap_cluster)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot permutated data. The labels assume 1 Hz resolution
title('Significant Clusters');

%Plotting Original Difference Data
subplot(3,3,9) 
imagesc(flipud(WAV_diff)); set(gca, 'YTick', 1:freq_cutoff, 'YTickLabel', freq_cutoff:-1:1); caxis([-1 1]); %Plot original data. The labels assume 1 Hz resolution
title('Original Wavelet Difference Data');
end