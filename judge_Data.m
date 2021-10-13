 data_size =  100;
 judge_time = 20;
 load data_f;
 data_f = data_f(:,1:4);
 %data = create_data(data_size);
 data=data_f;
 
 a = rand(1,4);
 b = rand(1,4);
 
 score = zeros(1,4);
 for i = 1:judge_time
     a = randi([1 100],1,1);
     b = randi([1 100],1,1);
     if a == b
         i = i-1;
         continue
     else 
        s = judge(data(a,:),data(b,:));
        if s == 0
            break
        end
        score = score + s;
     end
 end
score 
 
 
 function  data = create_data(data_size)
    data1 = rand(100,1)*0.25+0.7;
    data2 = rand(100,1)*0.07+0.06;
    data3 = rand(100,1)*0.25+0.7;
    data4 = rand(100,1)*0.07+0.06;
    data = [data1,data2,data3,data4];
 end
  
 
 function score = judge(data1,data2)
    disp('please compare two datas and input a number,if the first is bigger,press 1,else 2');
    disp(data1);
    disp('');
    disp(data2);
    k = input(''); 
    score = zeros(1,length(data1));
    for i = 1:length(data1)
        if  k ==1 
            if data1(i) > data2(i)
                score(i) = 1;
            else 
                score(i) = -1;
            end
        elseif k==11
            if data1(i) < data2(i)
                score(i) = 1;
            else
                score(i) = -1;
            end
        else
            score = zeros(1, 4);
        end  
    end  
 end
 
 
 