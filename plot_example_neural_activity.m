function plot_example_neural_activity

close all
clear all
clc

% Plot_example neural activity.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('activity_APP')

% Sampling frequency of Scanimage.
fs_image = 9.35211;

% ALM.
animal_num = 4;
session_num = 1;
region_num = 1;
cell_num = 4;
figure('Position',[200,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[200,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[200,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 1;
cell_num = 8;
figure('Position',[400,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[400,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[400,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 1;
cell_num = 12;
figure('Position',[600,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[600,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[600,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

% vS1.
animal_num = 4;
session_num = 1;
region_num = 6;
cell_num = 1;
figure('Position',[200,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[200,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[200,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 6;
cell_num = 4;
figure('Position',[400,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[400,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[400,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 6;
cell_num = 89;
figure('Position',[600,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[600,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[600,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

% RSC.
animal_num = 4;
session_num = 1;
region_num = 7;
cell_num = 1;
figure('Position',[1000,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1000,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1000,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 7;
cell_num = 7;
figure('Position',[1200,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1200,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1200,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 7;
cell_num = 8;
figure('Position',[1400,950,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1400,800,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1400,600,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

% PPC.
animal_num = 4;
session_num = 1;
region_num = 8;
cell_num = 4;
figure('Position',[1000,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1000,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1000,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 8;
cell_num = 12;
figure('Position',[1200,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1200,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1200,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

animal_num = 4;
session_num = 1;
region_num = 8;
cell_num = 20;
figure('Position',[1400,450,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.00,0.45,0.74],linspace(0,1,256));
colormap(cMap)

figure('Position',[1400,300,200,50],'Color','w')
imagesc(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)),[min(min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),min(min(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:))))),max(max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:)))),max(max(squeeze(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:)))))])
xlim([1,75])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
cMap = interp1([0;1],[1,1,1;0.64,0.08,0.18],linspace(0,1,256));
colormap(cMap)

clear se_correct_response_APP
se_correct_response_APP{region_num}{1} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{1},2)^0.5);
se_correct_response_APP{region_num}{2} = squeeze(std(activity_APP{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,:,:),[],2))./(size(activity_APP{animal_num}{session_num}.correct_response{region_num}{2},2)^0.5);
x1 = [1:75];
x2 = [x1,fliplr(x1)];
curve1_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) + se_correct_response_APP{region_num}{1}';
curve1_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:) - se_correct_response_APP{region_num}{1}';
curve2_1 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) + se_correct_response_APP{region_num}{2}';
curve2_2 = activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:) - se_correct_response_APP{region_num}{2}';
in_between1 = [curve1_1,fliplr(curve1_2)];
in_between2 = [curve2_1,fliplr(curve2_2)];
figure('Position',[1400,100,200,100],'Color','w')
hold on
h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
set(h1,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:),'Color',[0.00,0.45,0.74])
h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
set(h2,'facealpha',0.2)
plot(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:),'Color',[0.64,0.08,0.18])
line([1.*fs_image,1.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([1.2*min(min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),min(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:))),1.2*max(max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{1}(cell_num,:)),max(activity_APP{animal_num}{session_num}.trial_averaged_correct_response{region_num}{2}(cell_num,:)))])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

end