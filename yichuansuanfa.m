% %import random as r
% import numpy as np
% import operator as op
% import math as m
% import time
% import time
% import matlab.engine
% eng = matlab.engine.start_matlab()
%%
code_num = [10, 23, 24, 10, 1]; % (0, 2^10), (-1, 2^23), (-2^23, 2^23), (1, 2^10),
qun_size = 100; % ��Ⱥ����
gene_size = sum(code_num); % ���򳤶�
cz = 0.9; % ������
mu = 0.2; % ������
muz = 8;
times = 100; % ��������

%begin = time.time()
quns = create();
k = 0;
kk = 0;
temp = 0;
for i =1:times
    new_qun = jiaop(quns);
    %one = mul(one);
    %nums = decode(new_qun(1,:));
    [quns,score] = choice(new_qun);
    nums = decode(quns(1,:));
    disp(length(quns));
    disp(i, max_score, nums)
    numss = decode(qun(fix(-qun_size/3)));
    %print('===', mu, numss, '\n')

    if kk
        k = k+1;
    end
    if nums == numss
        temp = nums;
        mu = mu+ 0.1;
        muz = muz + 2;
        kk = 1;
        if mu > 0.7 || muz > gene_size - 2
           disp('\n��', nums, '��ȡ�����ֵ��', max_score);
            break
        end
    end
    if k % 7 == 6
        if k < 20 || nums ~= temp
            mu = 0.2;
            muz = 8;
            if nums ~= temp
                kk = 0;
        else
            disp('\n��', nums, '��ȡ�����ֵ��', max_score);
            break
            end
        end
    end
end
over = time.time()
if i > (times-2)
    disp('\n��', nums, '��ȡ�����ֵ��', max_score);
disp('��ʱ��', over - begin, '\t����������', i);
end






