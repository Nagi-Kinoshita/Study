s = load('spectral_original.txt');

l = size(s,1);

news = zeros(101,5);

k=1;
for i=1:l
    if mod(s(i,1),4)==0 && s(i,1)<781 && s(i,1)>379
       news(k,:) = s(i,:); 
       k=k+1;
    end
end


