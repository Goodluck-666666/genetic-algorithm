function Out = qiucan0(selectednum,a,b,c,fenleishu)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%��������
load('105����̥��7����ԭʼ����.mat')
X;
Y;
%%%ѡ���3������ֵ��ѡ��25������
proSelectedIndex=1;
TestXSpec=[X(41:50,:); X(51:60,:); X(85:89,:) ];
%TestXSpec=X(85:105,:);
actPro=[Y(41:50,proSelectedIndex);Y(51:60,proSelectedIndex);Y(85:89,proSelectedIndex)];
%%
%%ѡ��80������
YY=[Y(1:40,proSelectedIndex);Y(61:84,proSelectedIndex);Y(90:105,proSelectedIndex)];
XX=[X(1:40,:);X(61:84,:);X(90:105,:)];

%%
[WU,~,~] = UDPFS(XX',a,b,c,fenleishu);%SCUFS���� X ά��*������
[UXID1,Index]= sort(WU,'descend');
[pointNum,samplesNum]=size(XX');

selectedNum=selectednum; 
selectWave= zeros(selectedNum,samplesNum);
indexArray=Index(1:selectedNum);
selectWave=XX(:,indexArray);
%%
[ EstimationY,MahDist,PRESS,RMSECV,R2,Slope,Intercept,Bias,RPD,SpecRes,ComponentF,Weights,Loads,Score_length_array,centerCompValue_array,B] = FullCrossValidate2(selectWave,YY,15);
%%
RMSECV1 = RMSECV;
Rc2 = R2;

%�ⲿԤ�� ����Rp SEP
%����ѡ���PLS����
CalibrationX=selectWave;
CalibrationY=YY;
Factor = 15;
%��У��������PLS1�ֽ�,�����õ��Ĳ���������У����ͼ����֤��ͼ��Ԥ��ʹ��
[Score,Loads,Weights,b,Tnorm,Score_length]=PLS1(CalibrationX,CalibrationY,Factor);
valX=TestXSpec(:,indexArray);
%[EstimationY,PredictionXScores] =Estimation_PLS1_For_X(valX',Loads,Weights,b,Score_length);
valY= actPro;
centerCompValue = mean(CalibrationY);
centerSpecData = mean(CalibrationX);
 valX = valX - ones(size(valX,1),1) * centerSpecData;
 %����Rp

[predictValue,Rp]= PridictFun2(valX,valY,Loads,Weights,b,Score_length,centerCompValue,Factor);

%����SEP
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
R22 = Rp;

Out = ones(1, 5);
mid = 100;
for i = 1:length(R22)
    out = [Rc2(i)/100, RMSECV1(i), R22(i)/100, SEP2];
%     score = 4*(out(1,1)-0.9194) - 20000*(out(1,2)-0.0751) + 3*(out(1,3)-0.9) - 2*(out(1,4)-0.0815);
%     if score > mid
%         Out(1, 1) = score;
%         Out(1, 2:end) = out;
%     end
    score = RMSECV1(i);
    if score < mid
        mid = score;
        Out(1, 1) = 4*(out(1,1)-0.9194) -1*(out(1,2)-0.0751) + 3*(out(1,3)-0.8761) - 2*(out(1,4)-0.0815);
        Out(1, 2:end) = out;
    end

    
end
end