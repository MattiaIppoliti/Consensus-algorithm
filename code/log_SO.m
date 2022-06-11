function v=log_SO(p,q)
%dati due punti p e q su SO(3) trova la funzione logaritmo 
v=p*realLogSO(p'*q);
