data1 =zeros(150,6);
title = {'ѧ��','����','ʵ�ʳ�����','�Ͽ�λ��','�Ƿ����Ϸ','��ҵ�����'};

%ѧ����Ϣ
sno1 = randperm(150)+32002100;

%������Ϣ 0.4-4.0����̬�ֲ� �Ƿ������ҵ ���ݼ�����Ϣ����
score = normrnd(2.2,0.56667,150,1);
y=max(score)
z=min(score)
homework=score/(y-z);

%�Ƿ����Ϸ��0-1�ֲ� 2��8
playgame = zeros(1,150);
x=rand(1,150);
playgame(find(x<0.2))=1;
playgame(find(x>=0.2))=0;

%�Ͽ�λ��0-1�ֲ���1��1 ���ݼ�����Ϣ����
av=mean(score);
for i=1:150
if score(i)<av
position(i) = 0;
else
    position(i)=1;
end
end

%������ 0.6-1����̬�ֲ�
class = normrnd(0.9,0.03333,150,1);

% ���� ���excel
%data1(1,:)=title;
data1(1:end,1)=sno1;
data1(1:end,2)=score;
data1(1:end,3)=position;
data1(1:end,4)=playgame;
data1(1:end,5)=homework;
data1(1:end,6)=class;
%xlswrite('allstudent.xls',data1);

% ��ȡ������allstudent�ļ�������ѡ��һ����ѧ����Ϊĳһ�γ̵�ѡ����
allstudent = xlsread('Q.xlsx','sheet1');
data_select =zeros(90,7);

%���������������а����� 1 �� n ֮�����ѡ��� k ��Ψһ������
p = randperm(60000,90);
normal_escape = 2; %�������⣬������ͬѧ��Ϊ����ԭ�����ȱϯ
for i=1:90
temp = p(1,i);
data_select(i,1) = allstudent(temp,1);
data_select(i,2) = allstudent(temp,2);
data_select(i,3) = allstudent(temp,3);
data_select(i,4) = allstudent(temp,4);
data_select(i,5) = allstudent(temp,5);
data_select(i,6) = allstudent(temp,6);
if (allstudent(temp,7) == 1) & (normal_escape > 0)
   data_select(i,7) = 2; %��־Ϊ2��������E��ʱ����д�����Ϊ����ѧ���ӿ�20�ο�ֻ��һ��
   normal_escape = normal_escape - 1
else 
data_select(i,7) = allstudent(temp,7);
end
end

xlswrite('select_student.xls',data_select);
save data_select data_select
 




