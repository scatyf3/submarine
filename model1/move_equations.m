function dy = move_equations(t, y, k, m, alpha_t,alpha,v_t,v)
    dy = zeros(4, 1); 
    %f = interp1(ft,f,t);
    alpha = interp1(alpha_t,alpha,t); % 定义域，值域，插值的点
    V_water = interp1(v_t,v,t);
    %y(1) = r
    %y(2)=r'
    %y(3)=theta
    %y(4)=theta'
    dy(1) = y(2);%r
    dy(2) = (k/m) * (V_water*cos(alpha-y(3))-y(2)) * abs(V_water*cos(alpha-y(3))-y(2)) + (k/m) * abs(V_water * sin(alpha - y(3))-y(1)*y(4))* (V_water * sin(alpha - y(3))-y(1)*y(4)) - 2 * y(2) * y(4);
    dy(3) = y(4);
    dy(4) =(1/y(1)) * ((k/m) *  abs(V_water * sin(alpha - y(3))-y(1)*y(4))* (V_water * sin(alpha - y(3))-y(1)*y(4)) - 2*y(2)*y(4));
end