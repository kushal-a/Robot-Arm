% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 8;
opts.height     = 6;
opts.fontType   = 'Times';
opts.fontSize   = 7;

% create new figure
fig = figure; clf

% plot sin-curves with the 7 standard colors
load('2_.mat')
nColsNodes=3;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('4_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('6_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('8_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('10_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('12_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

load('14_.mat')
nColsNodes=nColsNodes+2;
h = plot(x(ceil(nColsNodes*0.5):nColsNodes:end),y(ceil(nColsNodes*0.5):nColsNodes:end),'LineWidth',1);
hold on

plot(xf,yf,'k','LineWidth',2)
% add axis labes and legend
axis tight
xlabel('X in cm')
ylabel('Y in cm')
lgd=legend('60 squares','240 squares','540 squares','960 squares','1500 squares','2160 squares','2940 squares','FEM')
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
print([opts.saveFolder 'my_figure'], '-dpng', '-r600')