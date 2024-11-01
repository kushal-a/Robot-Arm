function q = inverseKinematics(Td,q0)
    % Using non linear solver
    % Given a desired transformation matrix Td from frame zero to desired  
    % and initial guess q0, compute the joint angles q
    fun = @(q)fk_for_ik(q,Td);
    q = fsolve(fun,q0);
end