function x = decode(codes)
    %codes = [];
    code_num = [10, 23, 24, 10, 1]; % (0, 2^10), (-1, 2^23), (-2^23, 2^23), (1, 2^10)
    %x = (1:5);
    ff =0;
    for ii= 1:5
        x(ii)=0;
        for jj = 1:code_num(ii)
            x(ii)= 2*x(ii)+codes(ff+jj)
        end
        ff = ff + code_num(ii)    
    if mod(x(1), 800) > 50
        x(1) = mod(x(1), 800);
    else
        x(1) = 50;
    end
    x(2) = x(2) / 1000 - 2;
    if x(3)
        x(3) = (x(3) - 2^(gene_size(3)-1)) / acc;
    else 
        x(3) = 1;
    end
    x(4) = mod(x(4) , 800) + 1;
    x(5) = mod(x(5) , 2)+ 2;
    end      
end

