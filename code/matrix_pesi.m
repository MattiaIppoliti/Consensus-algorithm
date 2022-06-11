%Grafico la matrice dei pesi
close all;
M=zeros(100);

for i=1:1:5000
   M1= (1+sin(i/40));
   for k=1:1:100
       for p=1:1:100
           M(k,p)= exp(-((k-50)^2/400+(p-50)^2/400))*(M1);
       end
   end
   bar3(M);
   %drawnow;
   axis([0 100 0 100  0 2.5]);  %limito la finestra grafica alla porzione che mi interessa per vedere bene il drone
   %zlim([0 3])
   pause(0.00001);
   xlabel('riga');
   ylabel('colonna');
   zlabel('wij');
   
end
