% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'plotting/img/';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;

% create new figure
fig = figure; clf

%% plot
% load('q.mat')
plot(time_sequence, speed(:, :, 1),'LineWidth',1);
hold on
plot(time_sequence,speed(:, :, 2),'LineWidth',1);
hold on
plot(time_sequence, speed(:, :, 3),'LineWidth',1);
hold on
plot(time_sequence,speed(:, :, 4),'LineWidth',1);
hold on
plot(time_sequence,speed(:, :, 5),'LineWidth',1);
hold on
plot(time_sequence,speed(:, :, 6),'LineWidth',1);
hold on

%% plot

% add axis labes and legend
axis tight
xlabel('Time in seconds')
ylabel('Joint linear speed in m/s')
lgd=legend("joint 1", "joint 2", "joint 3", "joint 4", "joint 5", "joint 6")
set(lgd,'FontSize',6)
% scaling
fig.Units               = 'centimeters'
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     9);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
set(lgd,'FontSize',6)

% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'q16_linear_speed_plot'], '-dpng', '-r600')