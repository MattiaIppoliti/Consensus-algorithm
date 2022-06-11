function Data=init_data

Data=zeros(3,3,4);
%Matrici antipodali tra loro
Data(:,:,1)=[1,0,0;
             0,1,0;
             0,0,1];
Data(:,:,2)=[-1,0,0;
             0,-1,0;
             0,0,1];
Data(:,:,3)=[-1,0,0;
             0,1,0;
             0,0,-1];
Data(:,:,4)=[1,0,0;
             0,-1,0;
             0,0,-1];
