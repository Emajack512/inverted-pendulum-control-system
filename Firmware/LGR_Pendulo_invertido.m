clc;
clear;
close all;

M  = 0.75;
m  = 0.33;
bc = 0.01;
bp = 0.01;
l  = 0.3;
g  = 9.81;

a2 = ((M+m)*bp)/(M*m*l^2) + bc/M;
a1 = (bc*bp)/(M*m*l^2) - ((M+m)*g)/(M*l);
a0 = -(bc*g)/(M*l);

% Planta real:
% Theta(s)/U(s)
Gtheta = tf([-1/(M*l) 0],[1 a2 a1 a0]);

% Planta para LGR con K positivo:
% -Theta(s)/U(s)
G_LGR = -Gtheta;

G_LGR = minreal(G_LGR);

figure
rlocus(G_LGR)
grid on
title('LGR de -\Theta(s)/U(s) con fricciones')
xlabel('Eje real')
ylabel('Eje imaginario')

disp('Theta(s)/U(s):')
Gtheta

disp('-Theta(s)/U(s) usada para LGR:')
G_LGR

disp('Polos:')
pole(G_LGR)

disp('Ceros:')
zero(G_LGR)