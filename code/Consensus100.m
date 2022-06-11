%Caso in cui ho 1oo droni
close all; clear all; clc
%numero droni
n=100;

%la dimensione dei dati della matrice quadrata che rappresentano la
%posizione nel punto.

m=3; 

%passo discretizzazione del tempo dei sistemi continui
step=0.025;

%inizializzazione matrici
InitData=init_data2;
         

 %le matrici vengono compresse nel sottoinsieme Br.
for i=1:1:n
    LData(:,:,i)=comp_fun(InitData(:,:,i),m);
end

%salvo i dati iniziali.
InitGData=InitData; %dati non compressi
InitLData=LData;    %dati compressi

% vettore di convergenza. 
CL=[]; 
CG=[];
%inizializzo la matrice dei pesi
M=zeros(100);
M2=zeros(100);
waitbar(0,'Attesa del consenso');

for i=1:1:400 %10 secondi
   waitbar(i/400);
   tic
   M1= (1.1+sin(i/127-pi/2));
   for k=1:1:100
       for p=1:1:100
           M2(k,p)= exp(-((k-50)^2/500+(p-50)^2/500));
       end
end
   M=M2*M1;
   
   
   bar3(M);
   %limito la finestra grafica alla porzione che mi interessa per vedere bene il drone
   axis([0 100 0 100  0 2.5]);
   %pause(0.00001);
   xlabel('riga');
   ylabel('colonna');
   zlabel('wij');
           
    
    % Calcolo le nuove matrici all'istante successivo usando l'equazione di
    % stato. (usiamo Eulero in avanti)
    for r=1:1:n
        increment=zeros(m,m);
        pr=LData(:,:,r);  % prendo una alla volta le matrici compresse
        for j=1:1:n
            w=M(r,j);
            if (w>0)
                pj=LData(:,:,j);   %prendo di nuovo, una alla volta, le matrici compesse
                % applico l'equazione di stato.
                increment=increment+w.*log_SO(pr,pj); %increment mi indica la matrice velocità con cui il punto cambia la sua posizione
            end
        end   
        % calcolo il nuovo valore della matrice, applicando l'esponenziale lo
        % mappo su Br. devo moltiplicare increment (che è una velocità) per
        % step(che mi indica il tempo di discretizzazione), ottenendo la nuova
        % posizione della matrice.
        NewLData(:,:,r)=exp_SO(pr,step.*increment);
        
    end
    %memorizzo i nuovi dati nella vecchia matrice.
    LData=NewLData;
    
     %decomprimo i valori ottenuti
    for j=1:1:n
       GData(:,:,j)=decomp_fun(LData(:,:,j),m);
    end
    
    %inserimento visualizzazione a tempo reale del movimento dei droni
    %attraverso le funzioni di visualizzazione drone e rotazione oggetti
    
    tmp_L=0;
    tmp_G=0;
    
    for j=1:1:n
        for k=(j+1):1:n
             %calcolo la distanza tra due punti.
             tmp_L=tmp_L+dist_SO(LData(:,:,j),LData(:,:,k)); %compressi(locali)
             tmp_G=tmp_G+dist_SO(GData(:,:,j),GData(:,:,k)); %non compressi(non locali)
        end
    end
    
    % uso questi 2 vettori per visualizzare le prestazioni di convergenza
    CL=[CL,[i;tmp_L]]; 
    CG=[CG,[i;tmp_G]];
    toc
end

%visualizzazione grafica dell'andamento della distanza tra i punti
show_C(CL,CG,step);
