function [R] = screw_axis_to_rotation_matrix(r,theta)
	%converts the rotation matirx into screw axis representation
	R=zeros(3,3);
	R=[r(1)^2*(1-cos(theta))+cos(theta)  		 r(1)*r(2)*(1-cos(theta))-r(3)*sin(theta)  r(1)*r(3)*(1-cos(theta))+r(2)*sin(theta);
	   r(1)*r(2)*(1-cos(theta))+r(3)*sin(theta)  r(2)^2*(1-cos(theta))+cos(theta)		   r(3)*r(2)*(1-cos(theta))-r(1)*sin(theta)
	   r(1)*r(3)*(1-cos(theta))-r(2)*sin(theta)  r(2)*r(3)*(1-cos(theta))+r(1)*sin(theta)  r(3)^2*(1-cos(theta))+cos(theta)]
end