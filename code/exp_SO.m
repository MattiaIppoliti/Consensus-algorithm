function h=exp_SO(p,x)
%dato il vettore tangente x del punto p su SO(3) calcolare il valore della
%funzione esponenziale corrispondente.
h=p*expm(p'*x);

