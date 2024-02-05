function y = gen_random_alpha(num_intervals, time_step,is_fix,alpha_val,alpha_min,alpha_max,alpha_start,has_pic)
if mod(num_intervals,time_step)~=0
    msg = '我们要求num_intervals整除于time_step';
    error(msg);
    return 
end

if(is_fix==1)
    y = repmat(alpha_val, num_intervals+1, 1);
    return 
end

% 定义域
x = linspace(0, num_intervals, num_intervals+1);
delta_x = x(2) - x(1); 

% 生成介于 -π/6/3600和π/6/3600之间的随机数，作为函数的导数
y_derivative = (pi/3/3600)*rand(1, num_intervals+1) - pi/6/3600;


y = inf(num_intervals+1, 1);

y(1) = alpha_start;


% 第一轮迭代，利用随机算法生成一些存在导数变化的点
for i = 2:num_intervals+1
    if mod(i, time_step) == 1
        %disp(i);
        %disp("这是前一个y");
        %disp(y(i-time_step));
        %disp("这是增量");
        %disp(delta_x * y_derivative(i) * time_step);
        y_new = y(i-time_step) + delta_x * y_derivative(i) * time_step;
        disp(y_new);
        if y_new > alpha_max
            y_new = y(i-time_step) - delta_x * y_derivative(i) * time_step;
            %y_new = alpha_min + (alpha_max - alpha_min) * rand(); % 生成新的随机值
            y_derivative(i) = (y_new - y(end)) / (delta_x * time_step); % 更新这一段的导数
            %disp("alpha超出上限");
            %disp(y_new);
        end

        if y_new < alpha_min
            y_new = y(i-time_step) - delta_x * y_derivative(i) * time_step;
            %y_new = alpha_min + (alpha_max - alpha_min) * rand(); % 生成新的随机值
            y_derivative(i) = (y_new - y(end)) / (delta_x * time_step); % 更新这一段的导数
            %disp("alpha超出下限");
            %disp(y_new);
        end
        y(i) = y_new;
    end
end

% 拟合最近的两个非零的y点
zero_indices = find(y == inf);
%disp(zero_indices)

for i = 1:length(zero_indices)
    index = zero_indices(i);
    prev_noninf_index = find(y(1:index-1) ~= inf, 2, 'last');
    next_noninf_index = find(y(index+1:end) ~= inf, 2, 'first') + index;
    noninf_indices = [prev_noninf_index; next_noninf_index];
    noninf_values = y(noninf_indices);
    fitted_values = interp1(noninf_indices, noninf_values, index, 'linear');
    y(index) = fitted_values;
end

if has_pic
    % 画出图像
    figure;
    subplot(2, 1, 1);
    plot(x, y);
    title('Generated Function');

    subplot(2, 1, 2);
    plot(x, y_derivative);
    title('Rate of Change');
end

end
