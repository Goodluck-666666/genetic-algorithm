function one = mul(one)
    muz = 8;
    code_num = [10, 23, 24, 10, 1];
    gene_size = sum(code_num); % 基因长度
    one(1) = randi([0,1],1,1);
    one(end) = randi([0,1],1,1);
    pos = randi([muz, gene_size],1,1);
    poss = randi([pos - muz, pos - 1],1,1);
    for ii = poss: pos
        one(ii) = randi([0,1],1,1);
    end
end