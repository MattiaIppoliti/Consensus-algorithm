function d=dist_SO(p,q)
%dati due punti calcolo la distanza tra di essi
d=norm(realLogSO(p'*q),'fro'); %definizione distanza su SO(3).

