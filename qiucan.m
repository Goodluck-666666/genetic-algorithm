function [RMSECV1,Rc2,SEP2,R22] = qiucan(selectednum,a,b,c,fenleishu)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%%加载数据
load('105个安胎丸7性质原始数据.mat')
X;
Y;
%%%选择第3个性质值，选择25个样本
proSelectedIndex=1;
TestXSpec=[X(41:50,:); X(51:60,:); X(85:89,:) ];
%TestXSpec=X(85:105,:);
actPro=[Y(41:50,proSelectedIndex);Y(51:60,proSelectedIndex);Y(85:89,proSelectedIndex)];
%%
%%选择80个样本
YY=[Y(1:40,proSelectedIndex);Y(61:84,proSelectedIndex);Y(90:105,proSelectedIndex)];
XX=[X(1:40,:);X(61:84,:);X(90:105,:)];

%%
[WU,~,~] = UDPFS(XX',a,b,c,fenleishu);%SCUFS方法 X 维数*样本数
[UXID1,Index]= sort(WU,'descend');
[pointNum,samplesNum]=size(XX');

selectedNum=selectednum; 
selectWave= zeros(selectedNum,samplesNum);
indexArray=Index(1:selectedNum);
selectWave=XX(:,indexArray);
%%
[ EstimationY,MahDist,PRESS,RMSECV,R2,Slope,Intercept,Bias,RPD,SpecRes,ComponentF,Weights,Loads,Score_length_array,centerCompValue_array,B] = FullCrossValidate2(selectWave,YY,15);
%%
RMSECV1 = min(RMSECV);
Rc2 = max(R2);

%外部预测 计算Rp SEP
%波长选择后PLS计算
CalibrationX=selectWave;
CalibrationY=YY;
Factor = 15;
%对校正集进行PLS1分解,分析得到的参数将用于校正谱图和验证谱图的预测使用
[Score,Loads,Weights,b,Tnorm,Score_length]=PLS1(CalibrationX,CalibrationY,Factor);
valX=TestXSpec(:,indexArray);
%[EstimationY,PredictionXScores] =Estimation_PLS1_For_X(valX',Loads,Weights,b,Score_length);
valY= actPro;
centerCompValue = mean(CalibrationY);
centerSpecData = mean(CalibrationX);
 valX = valX - ones(size(valX,1),1) * centerSpecData;
 %计算Rp

[predictValue,Rp]= PridictFun2(valX,valY,Loads,Weights,b,Score_length,centerCompValue,Factor);

%计算SEP
selFactor=6;
bestPredicValue=predictValue(:,selFactor);
temp=0;
Num=max(size(actPro));
for lp=1:Num
    temp=temp+(actPro(lp)-bestPredicValue(lp))*(actPro(lp)-bestPredicValue(lp));
end
temp=temp/(Num-1);
SEP2 = sqrt(temp);
%RESECV2 = max(RMSECV);
R22 = max(Rp);
end

