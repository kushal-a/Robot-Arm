% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;

% create new figure
fig = figure; clf

%% plot
% load('q.mat')
plot(time_sequence, q_dot(2, :),'LineWidth',1);
hold on
plot(time_sequence,q_dot(3, :),'LineWidth',1);
hold on
plot(time_sequence, q_dot(4, :),'LineWidth',1);
hold on
plot(time_sequence,q_dot(5, :),'LineWidth',1);
hold on
plot(time_sequence,q_dot(6, :),'LineWidth',1);
hold on

%% plot

% add axis labes and legend
axis tight
xlabel('Time in seconds')
ylabel('Joint Velocities in rad/s')
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
print([opts.saveFolder 'q26_velocity_plot'], '-dpng', '-r600')