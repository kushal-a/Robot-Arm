function [q, q_dot, q_ddot] = trapezoidalTimeScaling(q_i, q_f, v, a, T, time_sequence)
% for trapezoidal profile generated for s(t) given a, v, T
total_time_steps = size(time_sequence, 2);

% s, s_dot, s_ddot
s = zeros(1, total_time_steps);
s_dot = zeros(1, total_time_steps);
s_ddot = zeros(1, total_time_steps);

for i=1:total_time_steps
    t = time_sequence(i);

    if (t >= 0) && (t <= v/a)
        s(i) = a * t * t / 2;
        s_dot(i) = a * t;
        s_ddot(i) = a;

    elseif (t > v/a) && (t <= T - (v/a))
        s(i) = t* v - (v*v/(2*a));
        s_dot(i) = v;
        s_ddot(i) = 0;

    elseif (t > T - (v/a)) && (t <= T)
        s(i) = -1 * ( (a*a*(T-t)*(T-t)) + (2*v*v) - (2*T*a*v) )/(2*a);
        s_dot(i) = a * (T - t);
        s_ddot(i) = -1 * a;

    else % t>T
        s(i) = 1;
        s_dot(i) = 0;
        s_ddot(i) = 0;
    end

q = q_i + (q_f - q_i) .* s;
q_dot = (q_f - q_i) .* s_dot;
q_ddot = (q_f - q_i) .* s_ddot;

end