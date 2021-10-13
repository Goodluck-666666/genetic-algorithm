function [quns,order] = choice(quns)
    order = [];
    for i = 1: length(quns)
        one = quns(i,:); 
        %x = decode(one);
        score = get_score(one);
        order = [score,one];
    end
    order= sort(order,'descend');
    %order.sort(key=lambda tup: tup[0], reverse=True)
    %qun = [];
    leng = lenth(order);
    for i =1:leng
        if i < r.randint(0, leng)
            quns=[quns,order(i,1)];
        end
    end
    order=order(1,1);
end
