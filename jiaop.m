function quns=jiaop(quns) 
    qun_size = 100;
    %qun = [];
    best = quns(1:50);
    while length(quns) <= qun_size/2
        if rand(0,1)< cz
            father = best(randi(numel(best),1,1));
            mother = quns(randi(numel(quns),1,1));
            if father == mother
                continue
            pos = randi(1, gene_size - 1);
            poss = randi(0, pos - 1);
            child = father(1:poss)+mother(poss:pos)+father(pos:end)  ;
            mul = [];
            end
            if rand(0,1)< mu
                child = mul(child);
            quns = [quns,child]
            end
        end
    end
end