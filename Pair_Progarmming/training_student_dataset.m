data1 =zeros(60000,6);
title = {'ѧ��','����','ʵ�ʳ�����','�Ͽ�λ��','�Ƿ����Ϸ','��ҵ�����'};

%ѧ����Ϣ
sno1 = randperm(60000)+32002100;


%������Ϣ 0.4-4.0����̬�ֲ� �Ƿ������ҵ ���ݼ�����Ϣ����
score = normrnd(2.2,0.56667,60000,1);
y=max(score)
z=min(score)
homework=score/(y-z);

%�Ƿ����Ϸ��0-1�ֲ� 2��8
playgame = zeros(1,60000);
x=rand(1,60000);
playgame(find(x<0.2))=1;
playgame(find(x>=0.2))=0;

%�Ͽ�λ��0-1�ֲ���1��1 ���ݼ�����Ϣ����
av=mean(score);
for i=1:60000
if score(i)<av
position(i) = 0;
else
    position(i)=1;
end
end

%������ 0.6-1����̬�ֲ�
class = normrnd(0.9,0.03333,60000,1);

% ���� ���excel
%data1(1,:)=title;
data1(1:end,1)=sno1;
data1(1:end,2)=score;
data1(1:end,3)=position;
data1(1:end,4)=playgame;
data1(1:end,5)=homework;
data1(1:end,6)=class;
xlswrite('data1.xls',data1);
