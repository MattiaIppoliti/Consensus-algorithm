% Rotazione di un cubo
Spigoli = [ 0 1 1 0 0 0 1 1 0 0 0 0 0 0 0 1 1 1 1 
            0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 1 1 
            0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 1 1 1 0];
close all
R = randn(3); H = 0.5*(R - R');
T = 0.02; 
Polo = [0 0 0]'; % Il cubo ruoterà intorno a questo punto, può essere sia interno che esterno al cubo
for k = 1:100
    SpigoliRuotati = expm(k*T*H)*(Spigoli - Polo) + Polo;
    plot3(SpigoliRuotati(1,:),SpigoliRuotati(2,:),SpigoliRuotati(3,:),'ro-',Polo(1),Polo(2),Polo(3),'bo')
    grid on; axis([-1 2 -1 2 -1 2]) 
    xlabel('x');ylabel('y');zlabel('z')
    pause(0.01)
end
