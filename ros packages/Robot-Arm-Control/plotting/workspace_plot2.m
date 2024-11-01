% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 9;

% create new figure
fig = figure; clf
load('workspace.mat')
load('robot_description.mat')
scatter(ddd(1,:),ddd(2,:));
xlabel('x in m');
ylabel('y in m');
title('Reachable Points of the end effector');
hold on
plot([task_space(1,1),task_space(1,2),task_space(1,2),task_space(1,1),task_space(1,1)],[task_space(2,1),task_space(2,1),task_space(2,2),task_space(2,2),task_space(2,1)],'LineWidth',1)
% add axis labes and legend
axis tight

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     7);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'my_figure'], '-dpng', '-r600')
