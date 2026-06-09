clc; close all; clear all;

syms M m l bc bp g s real

A = [ 0, 1, 0, 0;
    g*(M+m)/(M*l), -bp*(M+m)/(m*M*l^2), 0, bc/(M*l);
    0, 0, 0, 1;
    -m*g/M, bp/(M*l), 0, -bc/M ];

B = [0;
    -1/(M*l);
    0;
    1/M];

C = [1,0,0,0;
    0,0,1,0];

D = zeros(size(C,1), size(B,2));

I = eye(size(A));

G = simplify(C*((s*I - A)\B) + D);

G_theta = simplify(G(1,1));
G_x     = simplify(G(2,1));

disp('G_theta = theta(s)/U(s)')
pretty(G_theta)

disp('G_x = x(s)/U(s)')
pretty(G_x)

%Analisis de controlabilidad y observabilidad del sistema pendulo inv:
m=0.33;
M=0.75;
l=0.3;
bc=0.01;
bp=0.01;
g=9.81;

A=[0, 1, 0, 0;
    g*(M+m)/(M*l), -bp*(M+m)/(m*M*l^2), 0, bc/(M*l);
    0, 0, 0, 1;
    -m*g/M, bp/(M*l), 0, -bc/M]

B=[0; -1/(M*l); 0; 1/M]
C=[1,0,0,0;0,0,1,0]


D = zeros(size(C,1), size(B,2));
sys_ss = ss(A,B,C,D);
G = tf(sys_ss)

G_theta = minreal(G(1,1))
%G_x     = minreal(G(2,1))

Co = ctrb(A, B)
rCo=rank(Co)
Ob = obsv(A, C)
rOb=rank(Ob)
