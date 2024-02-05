function y = gen_random_v(num_intervals, time_step,v_min,v_max,v_start,is_fix,has_pic)

% 0.5-1.5m/s


if mod(num_intervals,time_step)~=0
    msg = '我们要求num_intervals整除于time_step';
    error(msg);
    return 
end

if(is_fix==1)
    y = repmat(v_start, num_intervals+1, 1);
    return 
end

% 定义域
x = linspace(0, num_intervals, num_intervals+1);
delta_x = x(2) - x(1); 

% 变化率不超过正负0.1m/s2
y_derivative = 0.1*rand(1, num_intervals+1) - 0.05;


y = inf(num_intervals+1, 1);

y(1) = v_start;


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
        %timestep不能太大，否则变化后的值既大于vmax后来也可以小于vmin，则出现inf
        if y_new > v_max
            %disp("出现异常状况之y_new > v_max")
            y_new = y(i-time_step) - delta_x * y_derivative(i) * time_step;
            %y_new = alpha_min + (alpha_max - alpha_min) * rand(); % 生成新的随机值
            y_derivative(i) = (y_new - y(end)) / (delta_x * time_step); % 更新这一段的导数
        end
        if y_new < v_min
            %disp("出现异常状况之y_new < v_min")
            y_new = y(i-time_step) - delta_x * y_derivative(i) * time_step;
            %y_new = alpha_min + (alpha_max - alpha_min) * rand(); % 生成新的随机值
            y_derivative(i) = (y_new - y(end)) / (delta_x * time_step); % 更新这一段的导数
        end
        y(i) = y_new;
        %disp("==update above this to noinf==");
    end
end

% 拟合最近的两个非零的y点
zero_indices = find(y == inf);
%disp(zero_indices);

for i = 1:length(zero_indices)
    index = zero_indices(i);
    %disp(index);
    prev_noninf_index = find(y(1:index-1) ~= inf, 2, 'last');
    next_noninf_index = find(y(index+1:end) ~= inf, 2, 'first') + index;
    %disp(prev_noninf_index);
    %disp(next_noninf_index);
    noninf_indices = [prev_noninf_index; next_noninf_index];
    noninf_values = y(noninf_indices);
    %disp(noninf_indices);
    %disp(noninf_values);
    fitted_values = interp1(noninf_indices, noninf_values, index, 'linear');
    y(index) = fitted_values;
end

if has_pic
    figure;
    subplot(2, 1, 1);
    plot(x, y);
    title('Generated Function');

    subplot(2, 1, 2);
    plot(x, y_derivative);
    title('Rate of Change');
end



end






