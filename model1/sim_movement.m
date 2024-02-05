% 设置初始条件
v1_0 = 0.01; % r(0)
v2_0 = 0; % r'(0)
v3_0 = 0; % theta(0)
v4_0 = 0; % theta'(0)
y0 = [v1_0; v2_0; v3_0; v4_0];

% 设置其他参数值
k = 1969.8;
m = 48200;
tspan = [0 3600];
alpha_t = linspace(0,3600,3601);
v_t = linspace(0,3600,3601);

opts = odeset('RelTol',1,'AbsTol',1);

% 进行1000次模拟
num_simulations = 10000;

% 存储最终物体坐落的笛卡尔坐标位置和对应的alpha值
final_x = zeros(num_simulations, 1);
final_y = zeros(num_simulations, 1);
alpha_values = zeros(num_simulations, 1);


for sim = 1:num_simulations %可以parfor，但是处于dbg的目的暂时不
    random_alpha = - pi + 2 * pi * rand();
    alpha = gen_random_alpha(3600,2,0,0,-pi/2,pi/2,random_alpha,0);
    %加入随机的alpha之后，产生未知原因的warning
    v = gen_random_v(3600,2,0.5,1.5,0.5,0,0);
    % 求解微分方程
    [t, y] = ode45(@(t, y) move_equations(t, y, k, m, alpha_t,alpha,v_t,v), tspan, y0,opts);
    % todo：一些情况会失败 警告: 在 t=4.814695e+00 处失败。在时间 t 处，步长必须降至所允许的最小值(1.421085e-14)以下，才能达到积分容差要求

    % 将极坐标转换为笛卡尔坐标
    r = y(end, 1);
    theta = y(end, 3);
    x = r * cos(theta);
    y = r * sin(theta);

    % 存储最终物体坐落的笛卡尔坐标位置和对应的alpha值
    final_x(sim) = x;
    final_y(sim) = y;
    clearvars y
end

scatter(final_x, final_y)
xlabel('X')
ylabel('Y')
title('Scatter Plot of Final Positions')

bins = 50; % 设置直方图的箱数

% 计算频率
[frequencies, xEdges, yEdges] = histcounts2(final_x, final_y, bins);

frequencies = frequencies/num_simulations;

% 绘制热力图
figure
imagesc(frequencies)
colorbar
colormap=sky(2);
xlabel('X')
ylabel('Y')
title('Heatmap')



