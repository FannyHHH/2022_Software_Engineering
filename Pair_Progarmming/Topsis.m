clear;clc
load data_select

% 需要修改的地方 X是我扔进去的值 也就是90人的信息
[n,m] = size(data_select);
disp(['共有' num2str(n) '个评价对象, ' num2str(m) '个评价指标']) 
weigh = [0,0.6,0.1,0.05,0.2,0.05];

%% 对正向化后的矩阵进行标准化
Z = data_select ./ repmat(sum(data_select.*data_select) .^ 0.5, n, 1);
disp('标准化矩阵 Z = ')
disp(Z)

%% 计算与最大值的距离和最小值的距离，并算出得分
D_P = sum([(Z - repmat(max(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D+ 与最大值的距离向量
D_N = sum([(Z - repmat(min(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D- 与最小值的距离向量
S = D_N ./ (D_P+D_N);    % 未归一化的得分
disp('最后的得分为：')
stand_S = S / sum(S)
[sorted_S,index] = sort(stand_S ,'descend')

topsis_predict =zeros(6,1);
j = 1;
for i=1:90
temp = index(i,1)
if (temp>=85) & (temp<=90)
    topsis_predict(j,1) = data_select(i,1)
    j = j+1
end
end
xlswrite('topsis_predict.xls',topsis_predict);
