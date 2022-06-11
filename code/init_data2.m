function Data=init_data1

Data=zeros(3,3,4);
for i=1:1:100
%inzializzo 100 matrici random
q1=rand(3);
q1=expm(q1'-q1);
Data(:,:,i)=q1;

end
