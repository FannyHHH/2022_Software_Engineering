data1 =zeros(150,6);
title = {'学号','绩点','实际出勤率','上课位置','是否打游戏','作业完成率'};

%学号信息
sno1 = randperm(150)+32002100;

%绩点信息 0.4-4.0的正态分布 是否完成作业 根据绩点信息调整
score = normrnd(2.2,0.56667,150,1);
y=max(score)
z=min(score)
homework=score/(y-z);

%是否打游戏，0-1分布 2：8
playgame = zeros(1,150);
x=rand(1,150);
playgame(find(x<0.2))=1;
playgame(find(x>=0.2))=0;

%上课位置0-1分布，1：1 根据绩点信息调整
av=mean(score);
for i=1:150
if score(i)<av
position(i) = 0;
else
    position(i)=1;
end
end

%出勤率 0.6-1的正态分布
class = normrnd(0.9,0.03333,150,1);

% 整合 输出excel
%data1(1,:)=title;
data1(1:end,1)=sno1;
data1(1:end,2)=score;
data1(1:end,3)=position;
data1(1:end,4)=playgame;
data1(1:end,5)=homework;
data1(1:end,6)=class;
%xlswrite('allstudent.xls',data1);

% 读取产生的allstudent文件，从中选择一部分学生作为某一课程的选课人
allstudent = xlsread('Q.xlsx','sheet1');
data_select =zeros(90,7);

%返回行向量，其中包含在 1 到 n 之间随机选择的 k 个唯一整数。
p = randperm(60000,90);
normal_escape = 2; %根据题意，有两名同学因为各种原因进行缺席
for i=1:90
temp = p(1,i);
data_select(i,1) = allstudent(temp,1);
data_select(i,2) = allstudent(temp,2);
data_select(i,3) = allstudent(temp,3);
data_select(i,4) = allstudent(temp,4);
data_select(i,5) = allstudent(temp,5);
data_select(i,6) = allstudent(temp,6);
if (allstudent(temp,7) == 1) & (normal_escape > 0)
   data_select(i,7) = 2; %标志为2，方便算E的时候进行处理，因为正常学生逃课20次课只逃一次
   normal_escape = normal_escape - 1
else 
data_select(i,7) = allstudent(temp,7);
end
end

xlswrite('select_student.xls',data_select);
save data_select data_select
 




