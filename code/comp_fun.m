function LData=comp_fun(GData,m)
%comprime tutti i punti della sfera S0 in Br.

e=eye(m);        
v=log_SO(e,GData); %trovo il vettore tangente dal punto p alpunto q.
LData=exp_SO(e,0.2.*v); % è mappato a Br attraverso la funzione esponenziale