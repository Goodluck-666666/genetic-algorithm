function [quns,one] = create()
    code_num = [10, 23, 24, 10, 1]; % (0, 2^10), (-1, 2^23), (-2^23, 2^23), (1, 2^10),
    qun_size = 100; % 种群数量
    gene_size = sum(code_num);%quns = randi([0,1],qun_size, gene_size);
    for i =1:qun_size
        one = randi([0,1],1,gene_size);
        quns(i,:)=one;    
    end
end

