%Utilizzo il metodo di Heun per risolvere l'IVP
clear all; close all;
%numero droni
n=4;

%la dimensione dei dati della matrice quadrata che rappresentano la
%posizione nel punto.

m=3; 

%passo discretizzazione del tempo dei sistemi continui
step=0.001;

%inizializzazione matrici
InitData=init_data1;
         
A(1)={[0,1.5,0.5,0;
       0,0,0,1.5;
       1,0,0,0;
       1,0,0.5,0]};
A(2)={[0,1,0,0;
       1,0,0.5,0;
       0,0.5,0,1.5;
       0,0,1.5,0]};
A(3)={[0,0.5,0,0;
       0.5,0,1,0;
       0,0,0,1;
       0,1,0,0]};

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

for i=1:1:5000

%viene scelto casualmente una delle matrici con i pesi.    
index=floor(rand*3)+1;
M=A{index}(:,:);
    

    % Calcolo le nuove matrici all'istante successivo usando l'equazione di
    % stato. 
    %(usiamo eulero in avanti per stimare la yn+1 che andremo poi a mettere all'interno della formula per Heun)
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
        vincrement(:,:,r)=increment;
        NewLData(:,:,r)=exp_SO(pr,step.*increment);    
    end
    %metodo di Heun
    for r=1:1:n 
        increment1=zeros(m,m);
        pr1=NewLData(:,:,r);
        for k=1:1:n
            w=M(r,k);
            if (w>0)
                pk=LData(:,:,k);   %prendo di nuovo, una alla volta, le matrici compesse
                % applico l'equazione di stato.
                increment1=increment1+w.*log_SO(pr1,pk); %increment mi indica la matrice velocità con cui il punto cambia la sua posizione
            end
        end   
       
        pr=LData(:,:,r);
        NewLData1(:,:,r)=exp_SO(pr,step.*((vincrement(:,:,r)+pt_SO(pr1,pr,increment1))/2));
        
    end
    %memorizzo i nuovi dati nella vecchia matrice.
    LData=NewLData1;
    
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
    
end

%visualizzazione grafica dell'andamento della distanza tra i punti
show_C(CL,CG,step);
