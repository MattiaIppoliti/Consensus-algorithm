%Caso in cui ho le matrici già decompresse

%numero droni
n=4;

%la dimensione dei dati della matrice quadrata che rappresentano la
%posizione nel punto.

m=3; 

%passo discretizzazione del tempo dei sistemi continui
step=0.001;

%inizializzazione matrici
InitData=init_data;
         
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

%salvo i dati iniziali.
GData=InitData; %dati non compressi

% vettore di convergenza. 
CG=[]; 

for i=1:1:5000

%viene scelto casualmente una delle matrici con i pesi.    
index=floor(rand*3)+1;
M=A{index}(:,:);
    

    % Calcolo le nuove matrici all'istante successivo usando l'equazione di
    % stato. (usiamo eulero in avanti)
    for r=1:1:n
        increment=zeros(m,m);
        pr=GData(:,:,r);  % prendo una alla volta le matrici compresse
        for j=1:1:n
            w=M(r,j);
            if (w>0)
                pj=GData(:,:,j);   %prendo di nuovo, una alla volta, le matrici compesse
                % applico l'equazione di stato.
                increment=increment+w.*log_SO(pr,pj); %increment mi indica la matrice velocità con cui il punto cambia la sua posizione
            end
        end   
        % calcolo il nuovo valore della matrice, applicando l'esponenziale lo
        % mappo su Br. devo moltiplicare increment (che è una velocità) per
        % step(che mi indica il tempo di discretizzazione), ottenendo la nuova
        % posizione della matrice.
        NewGData(:,:,r)=exp_SO(pr,step.*increment);
        
    end
    %memorizzo i nuovi dati nella vecchia matrice.
    GData=NewGData;
    
    %inserimento visualizzazione a tempo reale del movimento dei droni
    %attraverso le funzioni di visualizzazione drone e rotazione oggetti
   
    tmp_G=0;
    
    for j=1:1:n
        for k=(j+1):1:n
             %calcolo la distanza tra due punti.
             tmp_G=tmp_G+dist_SO(GData(:,:,j),GData(:,:,k)); %non compressi(non locali)
        end
    end
    
    % uso questo  vettore per visualizzare le prestazioni di convergenza
    CG=[CG,[i;tmp_G]];
    
end

%visualizzazione grafica dell'andamento della distanza tra i punti
X=step*CG(1,:);
Y=CG(2,:);
plot(X,Y);
title('Punti non compressi');
xlabel('tempo')
ylabel('CG');
