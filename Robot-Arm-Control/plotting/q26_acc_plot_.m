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
% load('q.mat')
plot(time_sequence1, q1_ddot(2, :),'LineWidth',1);
hold on
plot(time_sequence1,q1_ddot(3, :),'LineWidth',1);
hold on
plot(time_sequence1, q1_ddot(4, :),'LineWidth',1);
hold on
plot(time_sequence1,q1_ddot(5, :),'LineWidth',1);
hold on
plot(time_sequence1,q1_ddot(6, :),'LineWidth',1);
hold on

%% plot

% add axis labes and legend
axis tight
xlabel('Time in seconds')
ylabel('Joint Accelerations in rad/s2')
lgd=legend("joint 2", "joint 3", "joint 4", "joint 5", "joint 6")
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
print([opts.saveFolder 'q26_accleration_plot'], '-dpng', '-r600')