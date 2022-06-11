
load drone      
close all; 
figure;
Droni = [Xr';Yr';Zr'];  %le coordinate dei punti che costituiscono la figura del drone
close all
Centrorot = [-0.0125  -0.0048 0]'; %centro di massa del nosro drone

%numero droni
n=4;

%la dimensione dei dati della matrice quadrata che rappresentano la
%posizione nel punto.

m=3; 

%passo discretizzazione del tempo dei sistemi continui
step=0.01;

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
%posizione scritta centrale per il conteggio dei passi
dim = [.37 .205 .3 .3];

for i=1:1:500

%viene scelto casualmente una delle matrici con i pesi.    
index=floor(rand*3)+1;
M=A{index}(:,:);
    

    % Calcolo le nuove matrici all'istante successivo usando l'equazione di
    % stato. (usiamo eulero in avanti)
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
    
     %decomprimo i valori ottenuti e grafico il movimento dei droni fino al
     %raggiungimento del consenso.
    for j=1:1:n
       GData(:,:,j)=decomp_fun(LData(:,:,j),m);
       
       DroniRuotati = GData(:,:,j)*(Droni - Centrorot) + Centrorot; %droni ruotati usando la corrispondente matrice di rotazione
       DR(j)=subplot(2,2,j);   %ho 4 subplot, uno per ogni drone
       plot3(DroniRuotati(1,:),DroniRuotati(2,:),DroniRuotati(3,:),'ro-');   %stampa i droni ruotati a punti usando le 3 coordinate 
       title(DR(j),sprintf('Drone %i',j));
       grid on; 
       axis([-2 2 -2 2 -2 2])  %limito la finestra grafica alla porzione che mi interessa per vedere bene il drone
       xlabel('x');
       ylabel('y');
       zlabel('z');
       %visualizazione conteggio dei passi
       str=sprintf('Numero passi %i /500', i);
       h=annotation('textbox', dim, 'string', str,'FitBoxToText','on');
       pause(0.0001);
       delete(h);
        
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



