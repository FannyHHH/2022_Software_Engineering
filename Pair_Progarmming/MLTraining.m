
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% ���ؾ���ѵ���ķ��������� ׼ȷ�ȡ����´������´����� Classification Learner App ��ѵ
% ���ķ���ģ�͡�������ʹ�ø����ɵĴ�������������Զ�ѵ��ͬһģ�ͣ���ͨ�����˽�����Գ��򻯷�
% ʽѵ��ģ�͡�
%
%  ����:
%      trainingData: һ���������� App �е�Ԥ���������Ӧ�еı�
%
%  ���:
%      trainedClassifier: һ������ѵ���ķ������Ľṹ�塣�ýṹ���о��и��ֹ�����ѵ����
%       ��������Ϣ���ֶΡ�
%
%      trainedClassifier.predictFcn: һ���������ݽ���Ԥ��ĺ�����
%
%      validationAccuracy: һ������׼ȷ�Ȱٷֱȵ�˫����ֵ���� App �У�"��ʷ��¼" ��
%       ����ʾÿ��ģ�͵Ĵ�����׼ȷ�ȷ�����
%
% ʹ�øô��������������ѵ��ģ�͡�Ҫ����ѵ������������ʹ��ԭʼ���ݻ���������Ϊ�������
% trainingData �������е��øú�����
%
% ���磬Ҫ����ѵ������ԭʼ���ݼ� T ѵ���ķ�������������:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% Ҫʹ�÷��ص� "trainedClassifier" �������� T2 ����Ԥ�⣬��ʹ��
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 ������һ�����������ٰ�����ѵ���ڼ�ʹ�õ�Ԥ���������ͬ��Ԥ������С��й���ϸ��Ϣ����
% ����:
%   trainedClassifier.HowToPredict

% �� MATLAB �� 2022-10-08 22:34:06 �Զ�����


% ��ȡԤ���������Ӧ
% ���´��뽫���ݴ���Ϊ���ʵ���״��ѵ��ģ�͡�
% ��Ҫ�޸ĵĵط�1 Q��ѵ���� 
%load data_select
%Q = zeros(60000,6);
%Q = xlsread('Q.xlsx','sheet1');

trainingData=Q;
inputTable = trainingData;
predictorNames = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
predictors = inputTable(:, predictorNames);
response = inputTable.VarName7;
isCategoricalPredictor = [false, false, false, false, false];


% ѵ��������
% ���´���ָ�����з�����ѡ�ѵ����������
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [0; 1]);

% ʹ��Ԥ�⺯����������ṹ��
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% �����ṹ��������ֶ�
trainedClassifier.RequiredVariables = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = '�˽ṹ���Ǵ� Classification Learner R2020a ������ѵ��ģ�͡�';
trainedClassifier.HowToPredict = sprintf('Ҫ���±� T ����Ԥ�⣬��ʹ��: \n yfit = c.predictFcn(T) \n�� ''c'' �滻Ϊ��Ϊ�˽ṹ��ı��������ƣ����� ''trainedModel''��\n \n�� T ����������������ݷ��صı���: \n c.RequiredVariables \n������ʽ(�������/��������������)������ԭʼѵ������ƥ�䡣\n��������������\n \n�й���ϸ��Ϣ������� <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>��');

% ��ȡԤ���������Ӧ
% ���´��뽫���ݴ���Ϊ���ʵ���״��ѵ��ģ�͡�
%
inputTable = trainingData;
predictorNames = {'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6'};
predictors = inputTable(:, predictorNames);
response = inputTable.VarName7;
isCategoricalPredictor = [false, false, false, false, false];

% ִ�н�����֤
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 10);

% ������֤Ԥ��
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% ������֤׼ȷ��
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');


% ����ѵ������90���������Ԥ��
trainedClassifier.predictFcn(selectstudent)

%% ��Ԥ�������д�����������E
%Ԥ��Ľ����ʽ��90���˰�˳��Ԥ����ӿ���=0�����ӿ���=1
% ���Ԥ���ӿ����������㽨��
escape_num = 0;
for i=1:90
temp = ans(i,1)
if temp == 0
    escape_num = escape_num + 1;
end
end

ML_predict =zeros(escape_num,1);
Student_Actual_Escape_table = zeros(escape_num + 2, 21); %��¼ʵ���ӿ������+2����Ϊ������ͬѧ����ӿ�
Student_Predict_Escape_table = zeros(escape_num + 2, 21); %��¼�ӿ������+2����Ϊ������ͬѧ����ӿ�

%����MLԤ��Ľ�������ÿγ̵���ѧ����ѧ��
j = 1;
for i=1:90
temp = ans(i,1) %tempΪMLԤ������=1��ʾ��ѧ�����ӿΣ�=0��ʾ��ѧ�����ӿ�
if(data_select(i, 7) == 2) %����ѧ������һЩԭ��ȱ��
    Student_Actual_Escape_table(j,1) = data_select(i,1) %��һ��Ϊѧ��
    Student_Predict_Escape_table(j,1) = data_select(i,1) %��һ��Ϊѧ��
    for k=2:21 %�ӵڶ��п�ʼΪ�ӿμ�¼, ����20�ο�
        Student_Predict_Escape_table(j,k) = temp ; %MLԤ��Ľ��
        % ��������ѧ��ȱ�θ���Ϊ1/20 = 0.05
        x = rand(1)
        x(find(x<0.05))=0;%ȱ��
        x(find(x>=0.05))=1; 
        Student_Actual_Escape_table(j,k) = x;
    end
    j = j + 1
end
if temp == 0
    ML_predict(j,1) = data_select(i,1) %��һ��Ϊѧ��
    Student_Actual_Escape_table(j,1) = data_select(i,1) %��һ��Ϊѧ��
    Student_Predict_Escape_table(j,1) = data_select(i,1) %��һ��Ϊѧ��
    for k=2:21 %�ӵڶ��п�ʼΪ�ӿμ�¼, ����20�ο�
        Student_Predict_Escape_table(j,k) = 0; %��Ԥ������ʾ��ѧ�����ӿΣ���20�ο���������
        % ����ʵ���ӿ���������ӿε�ѧ��ֻ��0.8�ĸ��ʻ��ӿ�
        x = rand(1)
        x(find(x>0.8))=1;
        x(find(x<=0.8))=0; %0.8�ĸ����ӿ�
        Student_Actual_Escape_table(j,k) = x;
    end
    j = j+1
end
end
xlswrite('ML_predict.xls',ML_predict);
xlswrite('Student_Actual_Escape_table.xls',Student_Actual_Escape_table);
xlswrite('Student_Predict_Escape_table.xls',Student_Predict_Escape_table);

%% ���ɵ��ογ̵ĵ�����ȷ�����
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
    
            

