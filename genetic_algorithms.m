qun_size = 1000;
acc = 10000;
gene_size = [10, 15, 16, 10, 1];
% gene_size = [20];
cz = 0.9;
mu = 0.2;
muz = ceil(gene_size/3);
times = 10;

qun = create(qun_size, gene_size)
disp("开始迭代")
% qun1 = jiaop(qun, qun_size, gene_size, mu, muz)
for i = 1:times
    qun1 = jiaop(qun, qun_size, gene_size, mu, muz); % 进行繁殖
    order = choice(qun1, qun_size, gene_size, acc); % 进行选择
    qun = order(:, 2:end);                           % 更新种群
    one = decode(order(1,2:end), acc, gene_size);
    out = [order(1,1), one];
    fprintf("第%d次迭代结束，最优结果是：\t", i)
    disp(out)
end
fprintf("迭代结束，最终结果是：")
disp(out)


function qun = create(qun_size, gene_size)
    size = length(gene_size);
    k = ones(1, size);
    qun = ones(qun_size, size);
    for i = 1:size
        k(i) = gene_size(i);
        qun(:,i) = randi([0, 2^k(i)-1], qun_size, 1);
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

function one = decode(one, acc, gene_size)
    if mod(one(1), 800) > 50
        one(1) = mod(one(1), 800);
    else
        one(1) = 50;
    end
    one(2) = one(2) / acc - 2;
    if one(3)
        one(3) = (one(3) - 2^(gene_size(3)-1)) / acc;
    else 
        one(3) = 1;
    end
    one(4) = mod(one(4) , 800) + 1;
    one(5) = mod(one(5) , 2)+ 2;
%     one = one / acc;
end

function score = get_score(num, acc, gene_size)
    num = decode(num, acc, gene_size);
    out = qiucan_new(num(1), num(2), num(3), num(4), num(5));
    score = out(1,1) - out(1,2);
%     score = 100 * sin(num * 0.5) / (abs(num) + 1);
end

function order = choice(qun, qun_size, gene_size, acc)
    order = ones(qun_size, length(gene_size) + 1);
    len_qun = size(qun,1);
    for i = 1:len_qun
        one = qun(i,:);
        score = get_score(one, acc, gene_size);
        order(i,1) = score;
        order(i,2:end) = one;
    end
    order = sortrows(order, -1);
    for j = len_qun:-1:1
        if j > 1.2*randi(len_qun,1,1)
            order(j,:) = [];
        end
    end
end

function kid = xxoo(father, mother, gene_size)
    kid = ones(1, length(gene_size));
    for i = 1:length(gene_size)
        if gene_size(i) < 2
            kid(i) = father(i);
            continue
        end
        pos = sort(randperm(gene_size(i),2))-1;
        x1 = bitshift(fix(bitshift(father(i), -pos(2))), pos(2));
        x2 = bitshift(fix(mod(mother(i), 2^pos(2)) / 2^pos(1)), pos(1));
        x3 = mod(father(i), 2^pos(1));
        kid(i) = x1 + x2 + x3;
    end
end

function qun = jiaop(qun, qun_size, gene_size, mu, muz)
    kid_qun = ones(qun_size, length(gene_size));
    n = ceil(randperm(qun_size*2) / 4);
    m = ceil(randperm(qun_size*2) / 2);
    for i = 1:qun_size
        father = qun(n(i),:);
        mother = qun(m(i),:);
        kid = xxoo(father, mother, gene_size);
        if rand(1,1) < mu
            kid = mul(kid, gene_size, muz);
        end
        kid_qun(i,:) = kid;
    end
    qun = [qun;kid_qun];
end
