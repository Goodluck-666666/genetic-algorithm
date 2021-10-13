data_f = [];
    for num = order(1:1000, 2:end)'
    num = num';
    score = get_score(num, acc, gene_size);
    data_f = [data_f; score];
    end