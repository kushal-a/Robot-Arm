% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 12;
opts.height     = 8;
opts.fontType   = 'Times';
opts.fontSize   = 9;

% create new figure
fig = figure; clf

load('workspace_l1_l2_change.mat');
surf(x,y,0.5+zeros(size(x)),weights)
hold on
surf(x,y,0.6+zeros(size(x)),weights)
surf(x,y,0.7+zeros(size(x)),weights)
surf(x,y,0.8+zeros(size(x)),weights)
surf(x,y,0.9+zeros(size(x)),weights)
surf(x,y,1.0+zeros(size(x)),weights)
surf(x,y,1.1+zeros(size(x)),weights)
surf(x,y,1.2+zeros(size(x)),weights)
a = colorbar;
a.Label.String = 'number of orientations when sampled at 0.08 radians';
xlabel('x in m')
ylabel('y in m')
zlabel('z in m')
title('Workspace charactaerisation in task space')
%% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     7);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% set(lgd,'FontSize',6)

% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'my_figure'], '-dpng', '-r600')