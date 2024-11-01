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
force_to_tau_conversion =  0.00793;
plot(time_sequence_s, tau_s(1, :)*force_to_tau_conversion ,'LineWidth',1);
hold on
plot(time_sequence_s,tau_s(2, :),'LineWidth',1);
hold on
plot(time_sequence_s, tau_s(3, :),'LineWidth',1);
hold on
plot(time_sequence_s,tau_s(4, :),'LineWidth',1);
hold on
plot(time_sequence_s,tau_s(5, :),'LineWidth',1);
hold on
plot(time_sequence_s,tau_s(6, :),'LineWidth',1);
hold on

%% plot

% add axis labes and legend
axis tight
xlabel('Time in seconds')
ylabel('Motor Torque in Nm')
lgd=legend("joint 1 motor", "joint 2", "joint 3", "joint 4", "joint 5", "joint 6")
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
print([opts.saveFolder 'q_torque_plot'], '-dpng', '-r600')