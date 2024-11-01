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
eef = zeros(4, size(joint_space_traversed, 2));
base_frame = zeros(4, 1);
base_frame(4, 1) = 1;
time_steps = size(joint_space_traversed, 2);
for i=1:time_steps
    T_ = forwardKinematicsAllJoints(joint_space_traversed(:, i)) ;
    eef(:, i) = T_(:,:,6) * base_frame;
end
set(gca,'Xticklabel',[])
set(gca,'Yticklabel',[])
set(gca,'Zticklabel',[])
box_6_dof_plot2(joint_space_traversed(:, 1), 0.25, 1)
hold on
p = plot3(eef(1, :), eef(2, :), eef(3, :));
hold off
% box_6_dof_plot2(joint_space_traversed(:, 61), 0.25, 0)
% box_6_dof_plot2(q(:, 2*time_steps/4), 0.7, 0)
% box_6_dof_plot2(joint_space_traversed(:, 121), 0.25, 0)
box_6_dof_plot2(joint_space_traversed(:, time_steps), 1.0, 0)
grid on
p.LineWidth = 2;
xlim([-1, 1]);
ylim([-0.8, 1]);
zlim([0, 3]);
axis equal

% %% plot
% 
% % add axis labes and legend
% axis tight
% xlabel('Time in seconds')
% ylabel('Motor Torque in Nm')
% lgd=legend("joint 1", "joint 2", "joint 3", "joint 4", "joint 5", "joint 6")
% set(lgd,'FontSize',6)
% % scaling
% fig.Units               = 'centimeters'
% fig.Position(3)         = opts.width;
% fig.Position(4)         = opts.height;
% 
% % set text properties
% set(fig.Children, ...
%     'FontName',     'Times', ...
%     'FontSize',     9);
% 
% % remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% set(lgd,'FontSize',6)
% 
% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'eef_3d_plot'], '-dpng', '-r600')