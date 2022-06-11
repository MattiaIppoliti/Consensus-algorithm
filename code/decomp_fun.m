function GData=decomp_fun(LData,m)
%decomprimere i dati della sfera Br su SO

e=eye(m);
v=log_SO(e,LData); 
GData=exp_SO(e,5.*v); 

