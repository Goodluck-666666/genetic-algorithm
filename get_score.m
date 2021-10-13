% function re = get_score(num, acc, gene_size)         % 得分
%     num = decode(num, acc, gene_size);
%     out = qiucan_new(num(1), num(2), num(3), num(4), num(5));
%     re = [out, num];
% %     score = 100 * sin(num * 0.5) / (abs(num) + 1);
% end
function re = get_score(num, acc, gene_size)         % 得分
    num = decode(num, acc, gene_size);
    out = qiucan0(num(1), num(2), num(3), num(4), num(5));
    re = [out(1, 2:end), num];
%     score = 100 * sin(num * 0.5) / (abs(num) + 1);
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
    one(5) = 1;
%     one = one / acc;
end
