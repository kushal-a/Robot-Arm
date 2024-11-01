function [r,theta] = rotation_matrix_to_screw_axis(T)
	%converts the rotation matirx into screw axis representation
	R=T(1:3,1:3);
	theta=atan2(sqrt((R(1,2)-R(2,1))^2+(R(2,3)-R(3,2))^2+(R(3,1)-R(1,3))^2),R(1,1)+R(2,2)+R(3,3)-1);
	r=[R(3,2)-R(2,3);R(1,3)-R(3,1);R(2,1)-R(1,2)]/(2*sin(theta));
end