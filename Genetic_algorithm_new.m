qun_size = 100;                         % 种群大小
acc = 100;                               % 精度
% gene = [10, 23, 22, 10, 1];
% gene_size = [sum(gene)];
gene_size = [10, 11, 12, 10, 1];        % 基因编码
% gene_size = [20];
cz = 0.9;                               % 基因重组
mu = 0.2;                               % 变异Z
muz = ceil(gene_size/3);                % 变异片段长度
times = 4;                             % 迭代次数

qun = create(qun_size, gene_size);      % 创建种群

% order = choice(qun, qun_size, gene_size, acc)
% size(order,1)

disp("开始迭代")
% qun1 = jiaop(qun, qun_size, gene_size, mu, muz)
for i = 1:times
    start = cputime;
    qun1 = jiaop(qun, qun_size, gene_size, mu, muz); % 进行繁殖
    order = choice(qun1, qun_size, gene_size, acc);  % 进行选择
%     disp(order(1:end,1))
    qun = order(:, 2:end);                           % 更新种群
    
    one = decode(order(1,2:end), acc, gene_size);
    out = [order(1,1), one];
    stop = cputime;
    fprintf("\n第%d次迭代结束，最优结果是：\t", i)
    disp(out)
    fprintf("用时 %.3f 秒\n", (stop-start)/2)
end
fprintf("迭代结束，最终结果是：")
disp(out)


function qun = create(qun_size, gene_size)%%%%把gene_size十进制转成二进制   %%%产生qun_size*5的矩阵
    size = length(gene_size);
    k = ones(1, size);
    qun = ones(qun_size, size);
    for i = 1:size
        k(i) = gene_size(i);
        qun(:,i) = randi([0, 2^k(i)-1], qun_size, 1);%%%转成二进制   %%在1~二进制这个值里头随机产生qun_size个整数
    end
end

function one = mul(one, gene_size, muz)
    for i = 1:length(one)
        size = gene_size(i);
        one(i) = bitxor(one(i), 1);
        x = randi([0, 2^muz(i)-1], 1, 1);
        y = randi([0,size-muz(i)], 1, 1);
        one(i) = bitxor(one(i),x*2^y);
    end
end

function one = decode(one, acc, gene_size)          % 解码显示
    if mod(one(1), 800) > 50
        one(1) = mod(one(1), 800);
    else
        one(1) = 50;
    end
    one(2) = one(2) / acc - 2;
    kk = one(3) - 2^(gene_size(3)-1);
    if kk
        one(3) = kk / acc;
    else 
        one(3) = 1;
    end
    one(4) = mod(one(4) , 800) + 1;
    
%     one(5) = mod(one(5) , 2)+ 2;
%     one(5) = 2;
    one(5) = 1;
%     one = one / acc;
end

% function score = get_score(num, acc, gene_size)         % 得分
%     num = decode(num, acc, gene_size)
%     out = qiucan_new(num(1), num(2), num(3), num(4), num(5))
%     score = out(1,1) - out(1,2)
% %     score = 100 * sin(num * 0.5) / (abs(num) + 1);
% end
function score = get_score(num, acc, gene_size)         % 得分
    num = decode(num, acc, gene_size);
    out = qiucan0(num(1), num(2), num(3), num(4), num(5));
    score = out(1, 1);
%     score = 100 * sin(num * 0.5) / (abs(num) + 1);
end


% function re = get_score(num, acc, gene_size)         % 得分
%     num = decode(num, acc, gene_size);
%     out = qiucan_new(num(1), num(2), num(3), num(4), num(5));
%     re = [out, num];
% %     score = 100 * sin(num * 0.5) / (abs(num) + 1);
% end


function order = choice(qun, qun_size, gene_size, acc)  % 排序
    order = ones(qun_size, length(gene_size) + 1);      % 排序矩阵大小
    len_qun = size(qun,1);                              % 繁殖后的种群大小
    for i = 1:len_qun                                   % 把所有个体基因及其得分放入order
        one = qun(i,:);                         
        score = get_score(one, acc, gene_size);
        order(i,1) = score;
        order(i,2:end) = one;
    end
    order = sortrows(order, -1) ;                        % 种群排序
    for j = len_qun:-1:ceil(len_qun*0.1)                % 按概率杀死一些个体
        if j > 1.1*randi(len_qun)
            order(j,:) = [];
        end
    end
end

function kid = xxoo(father, mother, gene_size)
    size = length(gene_size);
    kid = ones(1, size);
    n = randi(size);%%%在1~size里产生一个数，size（后面参数默认为1）
    m = randperm(size, n);%%%在size里头随机选择n个数置换
    for i = m
        if gene_size(i) < 2
            kid(i) = father(i);
            continue
        end
%         pos = sort(randperm(gene_size(i),2))-1;
        e = rand() - 0.5;
        d = ceil(gene_size(i)*(2*abs(e)).^0.6.*e+0.5);
        a = randi(gene_size(i));
        b = mod(a + d, gene_size(i));
        pos = sort([a, b]);
        x1 = bitshift(fix(bitshift(father(i), -pos(2))), pos(2));
        x2 = bitshift(fix(mod(mother(i), 2^pos(2)) / 2^pos(1)), pos(1));
        x3 = mod(father(i), 2^pos(1));
        kid(i) = x1 + x2 + x3;
    end
end

function qun = jiaop(qun, qun_size, gene_size, mu, muz)
    kid_qun = ones(qun_size, length(gene_size));%%%产生qun_size*5的矩阵
    n = ceil(randperm(qun_size*2) / 8);%%%产生1~（qun_size*2）之间的随机置换数/8，向上取整(n为（qun_size*2）个值)   例如 p = randperm(5) 得到p =5     1     2     4     6     3 
    m = ceil(randperm(qun_size*2) / 3);%%%同上m为（qun_size*2）个值
    for i = 1:qun_size
        father = qun(n(i),:);%%%取qun的第n(i)行
        mother = qun(m(i),:);%%%取qun的第n(i)行
        kid = xxoo(father, mother, gene_size);
        if rand(1,1) < mu
            kid = mul(kid, gene_size, muz);
        end
        kid_qun(i,:) = kid;
    end
    qun = [qun;kid_qun];
end
