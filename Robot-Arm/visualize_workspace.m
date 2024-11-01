function [flag]=visualize_workspace(reachable_poses,task_space)
    %this function plots the workspace. On left all the possible points are
    %shown and on right all possible the oreintation of the position which we select on
    %the left plot is shown

    delta_x=0.02;
    delta_y=0.02;

    % gridlines ---------------------------
    subplot(1,2,1)
    hold on
    g_x=task_space(1,1):delta_x:task_space(1,2); % user defined grid Y [start:spaces:end]
    g_y=task_space(2,1):delta_y:task_space(2,2); % user defined grid X [start:spaces:end]
    for i=1:length(g_x)
       plot([g_x(i) g_x(i)],[g_y(1) g_y(end)],'k:') %y grid lines
       hold on    
    end
    for i=1:length(g_y)
       plot([g_x(1) g_x(end)],[g_y(i) g_y(i)],'k:') %x grid lines
       hold on    
    end
    points_x=(g_x(1:end-1)+g_x(2:end))*0.5;
    points_y=(g_y(1:end-1)+g_y(2:end))*0.5;
    [x_,y_]=meshgrid(points_x,points_y);
    h=plot(reshape(x_,1,[]),reshape(y_,1,[]),'ko');
    h.ButtonDownFcn = @directionsPlotter;
    drawnow
    function [] = directionsPlotter(hObj, event)
        x = hObj.XData; 
        y = hObj.YData; 
        pt = event.IntersectionPoint;       % The (x0,y0) coordinate you just selected
        coordinates = [x(:),y(:)];     % matrix of your input coordinates
        dist = pdist2(pt(1,1:2),coordinates);      %distance between your selection and all points
        [~, minIdx] = min(dist);% index of minimum distance to points  
        POI=(reachable_poses(1,:)<=(x(minIdx)+delta_x*0.5) & reachable_poses(1,:)>=(x(minIdx)-delta_x*0.5) & reachable_poses(2,:)<=(y(minIdx)+delta_y*0.5) & reachable_poses(2,:)>=(y(minIdx)-delta_y*0.5));
        hold on
        subplot(1,2,1)
        plot(reachable_poses(1,POI),reachable_poses(2,POI))
        hold off
        subplot(1,2,2)
        [X,Y,Z]=sphere;
        hSurface=surf(X,Y,Z);
%         set(hSurface,'FaceColor',[0 0 1], 'FaceAlpha',0.5,'EdgeAlpha', 0);
        plot3(reachable_poses(4,POI),reachable_poses(5,POI),reachable_poses(6,POI),'ko')
    end
end