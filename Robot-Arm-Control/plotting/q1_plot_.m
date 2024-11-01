% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'plotting/planning_img/';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;

% create new figure
fig = figure; clf

%% plot
h = plot(time_sequence1, q1(1, :),'LineWidth',1);
hold on
h = plot(time_sequence1, q1_dot(1, :),'LineWidth',1);
hold on
h = plot(time_sequence1, q1_ddot(1, :),'LineWidth',1);
hold on

%% plot

% add axis labes and legend
axis tight
xlabel('Time in seconds')
ylabel('Joint 1 Trajectory')
lgd=legend("joint position in meters", "joint velocity in m/s", "joint acceleration in m/s2")
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
print([opts.saveFolder 'q1_plot'], '-dpng', '-r600')