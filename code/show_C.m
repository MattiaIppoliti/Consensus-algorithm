function show_C(CL,CG,step)
%grafico vettore di convergenza locale
CL1=subplot(1,2,1);
X=step*CL(1,:); %prendo la prima riga che sono i valori di i e la moltiplico per lo step ottenendo una discretizzazione del tempo
Y=CL(2,:); %prendo la seconda riga che contiene il valore delle distanze
plot(CL1,X,Y);
title(CL1,'Punti compressi');
xlabel(CL1,'tempo');
ylabel(CL1,'CL');
%grafico vettore di convergenza globale
CG1=subplot(1,2,2);
X=step*CG(1,:);
Y=CG(2,:);
plot(CG1,X,Y);
title(CG1,'Punti non compressi');
xlabel(CG1,'tempo')
ylabel(CG1,'CG');
