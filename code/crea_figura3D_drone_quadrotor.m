% Programma per la creazione di una figura 3D simile ad un drone
% quadricottero, di Simone DE GRANDIS (tesi di laurea triennale in
% Ingegneria Informatica e dell'Automazione, relatore Prof. Simone Fiori,
% anno accademico 2016/2017), Università Politecnica delle Marche, Facoltà
% di Ingegneria
clear variables; close all; clc;

[X1, Y1, Z1] = ellipsoid(0, 0, 0, 1, 0.2, 0.1);
figure;
hold on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');

S = surf(X1, Y1, Z1);
rotate(S, [0 0 1], 90);
X2 = get(S, 'xdata');
Y2 = get(S, 'ydata');
Z2 = get(S, 'zdata');
hold off;

figure;
hold on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
surf(X2, Y2, Z2);
surf(X1, Y1, Z1);

X = cat(1, X1, X2);
Y = cat(1, Y1, Y2);
Z = cat(1, Z1, Z2);

[X1, Y1, Z1] = ellipsoid(1, 0, 0, 0.4, 0.4, 0.06);
surf(X1, Y1, Z1);
X = cat(1, X, X1);
Y = cat(1, Y, Y1);
Z = cat(1, Z, Z1);
[X1, Y1, Z1] = ellipsoid(-1, 0, 0, 0.4, 0.4, 0.06);
surf(X1, Y1, Z1);
X = cat(1, X, X1);
Y = cat(1, Y, Y1);
Z = cat(1, Z, Z1);
[X1, Y1, Z1] = ellipsoid(0, 1, 0, 0.4, 0.4, 0.06);
surf(X1, Y1, Z1);
X = cat(1, X, X1);
Y = cat(1, Y, Y1);
Z = cat(1, Z, Z1);
[X1, Y1, Z1] = ellipsoid(0, -1, 0, 0.4, 0.4, 0.06);
surf(X1, Y1, Z1);
X = cat(1, X, X1);
Y = cat(1, Y, Y1);
Z = cat(1, Z, Z1);

[r, c] = size(X);
Xr = X(:, 1);
Yr = Y(:, 1);
Zr = Z(:, 1);

% matrice -> vettore
for i = 2:c
    Xr = cat(1, Xr, X(:, i));
    Yr = cat(1, Yr, Y(:, i));
    Zr = cat(1, Zr, Z(:, i));
end;

save drone.mat Xr Yr Zr;

% I vettori Xr, Yr e Zr contengono le coordinate (x,y,z) rispettivamente
% dei punti. Plottando questi punti singolarmente si ottiene un solido 3D
% che assomiglia ad un drone a 4 motori

hold off;