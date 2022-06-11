function Data=init_data1

Data=zeros(3,3,4);
%inizializzo le 4 matrici decompresse random
q1=rand(3);
q1=expm(q1'-q1);
Data(:,:,1)=q1;

q2=rand(3);
q2=expm(q2'-q2);
Data(:,:,2)=q2;

q3=rand(3);
q3=expm(q3'-q3);
Data(:,:,3)=q3;

q4=rand(3);
q4=expm(q4'-q4);
Data(:,:,4)=q4;
