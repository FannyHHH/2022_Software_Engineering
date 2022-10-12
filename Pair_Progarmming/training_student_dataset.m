data1 =zeros(60000,6);
title = {'学号','绩点','实际出勤率','上课位置','是否打游戏','作业完成率'};

%学号信息
sno1 = randperm(60000)+32002100;


%绩点信息 0.4-4.0的正态分布 是否完成作业 根据绩点信息调整
score = normrnd(2.2,0.56667,60000,1);
y=max(score)
z=min(score)
homework=score/(y-z);

%是否打游戏，0-1分布 2：8
playgame = zeros(1,60000);
x=rand(1,60000);
playgame(find(x<0.2))=1;
playgame(find(x>=0.2))=0;

%上课位置0-1分布，1：1 根据绩点信息调整
av=mean(score);
for i=1:60000
if score(i)<av
position(i) = 0;
else
    position(i)=1;
end
end

%出勤率 0.6-1的正态分布
class = normrnd(0.9,0.03333,60000,1);

% 整合 输出excel
%data1(1,:)=title;
data1(1:end,1)=sno1;
data1(1:end,2)=score;
data1(1:end,3)=position;
data1(1:end,4)=playgame;
data1(1:end,5)=homework;
data1(1:end,6)=class;
xlswrite('data1.xls',data1);
