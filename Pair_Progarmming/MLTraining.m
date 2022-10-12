
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% 返回经过训练的分类器及其 准确度。以下代码重新创建在 Classification Learner App 中训
% 练的分类模型。您可以使用该生成的代码基于新数据自动训练同一模型，或通过它了解如何以程序化方
% 式训练模型。
%
%  输入:
%      trainingData: 一个包含导入 App 中的预测变量和响应列的表。
%
%  输出:
%      trainedClassifier: 一个包含训练的分类器的结构体。该结构体中具有各种关于所训练分
%       类器的信息的字段。
%
%      trainedClassifier.predictFcn: 一个对新数据进行预测的函数。
%
%      validationAccuracy: 一个包含准确度百分比的双精度值。在 App 中，"历史记录" 列
%       表显示每个模型的此总体准确度分数。
%
% 使用该代码基于新数据来训练模型。要重新训练分类器，请使用原始数据或新数据作为输入参数
% trainingData 从命令行调用该函数。
%
% 例如，要重新训练基于原始数据集 T 训练的分类器，请输入:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% 要使用返回的 "trainedClassifier" 对新数据 T2 进行预测，请使用
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 必须是一个表，其中至少包含与训练期间使用的预测变量列相同的预测变量列。有关详细信息，请
% 输入:
%   trainedClassifier.HowToPredict

% 由 MATLAB 于 2022-10-08 22:34:06 自动生成


% 提取预测变量和响应
% 以下代码将数据处理为合适的形状以训练模型。
% 需要修改的地方1 Q是训练集 
%load data_select
%Q = zeros(60000,6);
%Q = xlsread('Q.xlsx','sheet1');

trainingData=Q;
inputTable = trainingData;
predictorNames = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
predictors = inputTable(:, predictorNames);
response = inputTable.VarName7;
isCategoricalPredictor = [false, false, false, false, false];


% 训练分类器
% 以下代码指定所有分类器选项并训练分类器。
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

% 使用预测函数创建结果结构体
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% 向结果结构体中添加字段
trainedClassifier.RequiredVariables = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = '此结构体是从 Classification Learner R2020a 导出的训练模型。';
trainedClassifier.HowToPredict = sprintf('要对新表 T 进行预测，请使用: \n yfit = c.predictFcn(T) \n将 ''c'' 替换为作为此结构体的变量的名称，例如 ''trainedModel''。\n \n表 T 必须包含由以下内容返回的变量: \n c.RequiredVariables \n变量格式(例如矩阵/向量、数据类型)必须与原始训练数据匹配。\n忽略其他变量。\n \n有关详细信息，请参阅 <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>。');

% 提取预测变量和响应
% 以下代码将数据处理为合适的形状以训练模型。
%
inputTable = trainingData;
predictorNames = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
predictors = inputTable(:, predictorNames);
response = inputTable.VarName7;
isCategoricalPredictor = [false, false, false, false, false];

% 执行交叉验证
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 10);

% 计算验证预测
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% 计算验证准确度
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');


% 根据训练集对90人情况产生预测
trainedClassifier.predictFcn(selectstudent)

%% 对预测结果进行处理，便于生成E
%预测的结果格式：90个人按顺序，预测会逃课则=0，不逃课则=1
% 算出预测逃课人数，方便建表
escape_num = 0;
for i=1:90
temp = ans(i,1)
if temp == 0
    escape_num = escape_num + 1;
end
end

ML_predict =zeros(escape_num,1);
Student_Actual_Escape_table = zeros(escape_num + 2, 21); %记录实际逃课情况，+2是因为有两名同学随机逃课
Student_Predict_Escape_table = zeros(escape_num + 2, 21); %记录逃课情况，+2是因为有两名同学随机逃课

%根据ML预测的结果产生该课程点名学生的学号
j = 1;
for i=1:90
temp = ans(i,1) %temp为ML预测结果，=1表示该学生不逃课，=0表示该学生会逃课
if(data_select(i, 7) == 2) %正常学生由于一些原因缺课
    Student_Actual_Escape_table(j,1) = data_select(i,1) %第一列为学号
    Student_Predict_Escape_table(j,1) = data_select(i,1) %第一列为学号
    for k=2:21 %从第二列开始为逃课记录, 对于20次课
        Student_Predict_Escape_table(j,k) = temp ; %ML预测的结果
        % 对于正常学生缺课概率为1/20 = 0.05
        x = rand(1)
        x(find(x<0.05))=0;%缺课
        x(find(x>=0.05))=1; 
        Student_Actual_Escape_table(j,k) = x;
    end
    j = j + 1
end
if temp == 0
    ML_predict(j,1) = data_select(i,1) %第一列为学号
    Student_Actual_Escape_table(j,1) = data_select(i,1) %第一列为学号
    Student_Predict_Escape_table(j,1) = data_select(i,1) %第一列为学号
    for k=2:21 %从第二列开始为逃课记录, 对于20次课
        Student_Predict_Escape_table(j,k) = 0; %若预测结果显示该学生会逃课，则20次课他都会逃
        % 对于实际逃课情况，会逃课的学生只有0.8的概率会逃课
        x = rand(1)
        x(find(x>0.8))=1;
        x(find(x<=0.8))=0; %0.8的概率逃课
        Student_Actual_Escape_table(j,k) = x;
    end
    j = j+1
end
end
xlswrite('ML_predict.xls',ML_predict);
xlswrite('Student_Actual_Escape_table.xls',Student_Actual_Escape_table);
xlswrite('Student_Predict_Escape_table.xls',Student_Predict_Escape_table);

%% 生成单次课程的点名正确率情况
request = 0
positive = 0
for i = 1:escape_num + 2
    for j = 2:21
        if(Student_Predict_Escape_table(i,j) == 0) 
            request = request + 1
        end
        if(Student_Predict_Escape_table(i,j) == 0 & Student_Actual_Escape_table(i, j) == 0)
            positive = positive + 1
        end
    end
end
E = positive / request
    
            

