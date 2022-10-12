clear;clc
load data_select

% ��Ҫ�޸ĵĵط� X�����ӽ�ȥ��ֵ Ҳ����90�˵���Ϣ
[n,m] = size(data_select);
disp(['����' num2str(n) '�����۶���, ' num2str(m) '������ָ��']) 
weigh = [0,0.6,0.1,0.05,0.2,0.05];

%% �����򻯺�ľ�����б�׼��
Z = data_select ./ repmat(sum(data_select.*data_select) .^ 0.5, n, 1);
disp('��׼������ Z = ')
disp(Z)

%% ���������ֵ�ľ������Сֵ�ľ��룬������÷�
D_P = sum([(Z - repmat(max(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D+ �����ֵ�ľ�������
D_N = sum([(Z - repmat(min(Z),n,1)) .^ 2 ] .* repmat(weigh,n,1) ,2) .^ 0.5;   % D- ����Сֵ�ľ�������
S = D_N ./ (D_P+D_N);    % δ��һ���ĵ÷�
disp('���ĵ÷�Ϊ��')
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
