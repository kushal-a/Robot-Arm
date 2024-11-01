[T,A]=fk_for_ik([0.5; -pi/4; -pi/3; -pi; pi/4; 0],zeros(4,4));
Link_Frame=eye(4);
collision_boxes{n_links}=[];
for i=1:n_links
    collision_boxes{i}=collisionBox(b_dim(1,i),b_dim(2,i),b_dim(3,i));
    Link_Frame=Link_Frame*A(:,:,i);
    collision_boxes{i}.Pose=Link_Frame*[eye(3),f_c(:,i);0 0 0 1]; 
end
fig = figure;
for j=1:n_links        
    show(collision_boxes{j})
    hold on
end
% text properties
% set(fig.Children, ...
%     'FontName',     'Times', ...
%     'FontSize',     9);

% export to png

fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'box_collision_plot'], '-dpng', '-r600')
hold off
pause(0.1)