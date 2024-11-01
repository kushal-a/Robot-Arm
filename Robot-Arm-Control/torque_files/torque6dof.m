function torque = torque6dof(q,q_dot,q_dotdot)
    % returns how much torque or force each joint should apply to achieve
    % required q, q_dot and q_dotdot
    %% Define 
    n = 6;
    load robot_description.mat inertia DH;
    dh = DH(zeros(6,1));
    
    lc = zeros(3,n+1); % COM coordinates in zero position wrt frame {0}
    m = zeros(n); % mass of links
    I0 = zeros(3,3,n); % Inertia of links on COM in ground frame orientation
    for i=1:6
        lc(:,i) = inertia(i,3:5)';
        m(i) = inertia(i,2);
        I0(:,:,i) = reshape(inertia(i,6:end),[3 3])';
    end
    lc = [lc;ones(1,n+1)]; % For multiplication with transformation matrices
       
    V0 = [0;0;0;0;0;0]; % Twist of the frame 0
    Vdot0 = [0;0;0;0;0;-9.81];
    
    Ftip = [0;0;0;0;0;0];
    F = zeros(6,7);
    F(:,7) = Ftip; % Defining F_{n+1} = F7 = Ftip

    %% Don't do anything below

%     T0 = zeros(4,4,n); % Transformation matix from frame 0 to frame i
%     for i=1:n
%         T = eye(4);
%         for j=1:i
%             T = T*transDH(dh(j,1:4));
%         end
%         T0(:,:,i) = T; % Store transformation matrices from 0 to i
%     end

    T0 = forwardKinematicsAllJoints(zeros(6,1));

    % xc is the COMi coordinates wrt dh frame i-1 
    xc = zeros(4,n+1);
    xc(:,1) = lc(:,1);
    for i=2:n
        xc(:,i)=Tinv(T0(:,:,i-1))*lc(:,i);
    end

    I = zeros(3,3,n); % Convert to ith frame orientation
    for i=1:n
        I(:,:,i) = T0(1:3,1:3,i)'*I0(:,:,i)*T0(1:3,1:3,i);
    end

    % Screw axis of joint i in frame i
    A = zeros(6,n);
    
    for i=1:n
        A(:,i) = [0;0;dh(i,5);(-dh(i,5)*box3([0;0;1])*xc(1:3,i) + (1-dh(i,5))*[0;0;1])];
    end
    
    % M(:,:,i) is the initial transformation matrix of frame i-1 wrt frame i
    M = zeros(4,4,n+1);
    M(:,:,1) = [eye(3) -xc(1:3,1);0 0 0 1];
    for i=2:n+1
        M(:,:,i) = Tinv([eye(3) xc(1:3,i);0 0 0 1])*Tinv(transDH(dh(i-1,1:4)))*[eye(3) xc(1:3,i-1);0 0 0 1];
    end
    
    % Define T7 which creates 1:6 entries blank
    T = zeros(4,4,n+1);
    T(:,:,n+1) = M(:,:,n+1); 
    V = zeros(6,n);
    Vdot = zeros(6,n);
    
    G = zeros(6,6,n);
    tau = zeros(6);

    %% Forward Iteration: from 1 to n
    % T{i} is transformation matrix of frame i-1 wrt frame i
    for i=1:n
        T(:,:,i) = exp_matrix4(-box6(A(:,i)),q(i))*M(:,:,i);
        % display(T(:,:,i))
        if (i==1)
            V(:,i) = Ad(T(:,:,i))*V0 + A(:,i)*q_dot(i);
            Vdot(:,i) = Ad(T(:,:,i))*Vdot0 + ad_twist(V(:,i))*A(:,i)*q_dot(i) + A(:,i)*q_dotdot(i);
        else
            V(:,i) = Ad(T(:,:,i))*V(:,i-1) + A(:,i)*q_dot(i);
            Vdot(:,i) = Ad(T(:,:,i))*Vdot(:,i-1) + ad_twist(V(:,i))*A(:,i)*q_dot(i) + A(:,i)*q_dotdot(i);
        end
    end

    %% Backward iteration: from n to 1
    for i=6:-1:1
        G(:,:,i) = [I(:,:,i) zeros(3,3); zeros(3,3) m(i)*eye(3)];
        F(:,i) = Ad(T(:,:,i+1))'*F(:,i+1) + G(:,:,i)*Vdot(:,i) - ad_twist(V(:,i))'*G(:,:,i)*V(:,i);
        tau(i) = F(:,i)'*A(:,i); % how much torque is experienced by joint i
    end
    
    torque = zeros(6,1);
    for i=1:6
        torque(i,1) = -tau(i);
    end
end