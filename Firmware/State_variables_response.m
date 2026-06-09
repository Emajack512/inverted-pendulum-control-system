clc;
clear;
close all;

%% ============================================================
%  MODELO EN VARIABLES DE ESTADO - PENDULO INVERTIDO
%  Estados:
%  x1 = theta
%  x2 = theta_dot
%  x3 = x
%  x4 = x_dot
%  ============================================================

%% Parametros fisicos
M  = 0.75;     % Masa del carro [kg]
m  = 0.33;     % Masa de la esfera del pendulo [kg]
l  = 0.30;     % Longitud del pendulo [m]
bc = 0.01;     % Friccion viscosa del carro [kg/s]
bp = 0.01;     % Friccion viscosa del pivote [kg*m^2/s]
g  = 9.81;     % Gravedad [m/s^2]

%% Matrices del sistema

A = [ 0, 1, 0, 0;
      g*(M+m)/(M*l), -bp*(M+m)/(m*M*l^2), 0, bc/(M*l);
      0, 0, 0, 1;
      -m*g/M, bp/(M*l), 0, -bc/M ];

B = [ 0;
     -1/(M*l);
      0;
      1/M ];

C = [1 0 0 0;
     0 0 1 0];

D = [0;
     0];

%% Mostrar matrices y autovalores

disp('Matriz A:')
disp(A)

disp('Matriz B:')
disp(B)

disp('Matriz C:')
disp(C)

disp('Matriz D:')
disp(D)

disp('Autovalores del sistema:')
disp(eig(A))

%% ============================================================
%  TIEMPO DE SIMULACION
%  ============================================================

% El sistema es inestable. Si aumentas mucho el tiempo, la respuesta crece demasiado.
t_final = 0.5;
dt = 0.001;
t = 0:dt:t_final;

%% ============================================================
%  RESPUESTA AL IMPULSO UNITARIO
%  x_imp(t) = Phi(t)B = expm(A*t)B
%  ============================================================

x_imp = zeros(4,length(t));

for k = 1:length(t)
    x_imp(:,k) = expm(A*t(k))*B;
end

%% ============================================================
%  RESPUESTA AL ESCALON UNITARIO
%  x_step(t) = integral_0^t Phi(sigma)B d_sigma
%  ============================================================

x_step = cumtrapz(t,x_imp,2);

%% ============================================================
%  SALIDAS DEL SISTEMA
%  y = [theta ; x]
%  ============================================================

y_imp  = C*x_imp;
y_step = C*x_step;

%% ============================================================
%  CARPETA PARA GUARDAR FIGURAS
%  ============================================================

carpeta = 'graficas_pendulo';

if ~exist(carpeta,'dir')
    mkdir(carpeta);
end

%% ============================================================
%  CONFIGURACION GENERAL DE GRAFICAS
%  ============================================================

set(0,'DefaultFigureColor','w');
set(0,'DefaultAxesColor','w');
set(0,'DefaultAxesXColor','k');
set(0,'DefaultAxesYColor','k');
set(0,'DefaultAxesFontSize',13);
set(0,'DefaultAxesLineWidth',1.2);
set(0,'DefaultLineLineWidth',2.2);

%% Nombres y unidades de estados

nombres = {'$\theta(t)$', '$\dot{\theta}(t)$', '$x(t)$', '$\dot{x}(t)$'};
unidades = {'rad', 'rad/s', 'm', 'm/s'};

%% ============================================================
%  GRAFICAS DE ESTADOS ANTE ENTRADA IMPULSO
%  ============================================================

fig1 = figure('Name','Estados ante entrada impulso','Color','w');
set(fig1,'Position',[100 100 1300 800]);

tl = tiledlayout(2,2);
tl.TileSpacing = 'compact';
tl.Padding = 'compact';

for i = 1:4
    nexttile;

    plot(t,x_imp(i,:),'LineWidth',2.2);
    grid on;

    xlabel('Tiempo [s]', ...
           'Interpreter','latex', ...
           'FontSize',13, ...
           'FontWeight','bold', ...
           'Color','k');

    ylabel([nombres{i} ' [' unidades{i} ']'], ...
           'Interpreter','latex', ...
           'FontSize',13, ...
           'FontWeight','bold', ...
           'Color','k');

    title(['Respuesta al impulso - ' nombres{i}], ...
          'Interpreter','latex', ...
          'FontSize',15, ...
          'FontWeight','bold', ...
          'Color','k');

    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    ax.LineWidth = 1.2;
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.GridAlpha = 0.25;
end

sgtitle('Respuesta de los estados ante entrada impulso unitario', ...
        'Interpreter','latex', ...
        'FontSize',20, ...
        'FontWeight','bold', ...
        'Color','k');

exportgraphics(fig1,fullfile(carpeta,'estados_impulso.png'), ...
               'Resolution',300, ...
               'BackgroundColor','white');

%% ============================================================
%  GRAFICAS DE ESTADOS ANTE ENTRADA ESCALON
%  ============================================================

fig2 = figure('Name','Estados ante entrada escalon','Color','w');
set(fig2,'Position',[150 100 1300 800]);

tl = tiledlayout(2,2);
tl.TileSpacing = 'compact';
tl.Padding = 'compact';

for i = 1:4
    nexttile;

    plot(t,x_step(i,:),'LineWidth',2.2);
    grid on;

    xlabel('Tiempo [s]', ...
           'Interpreter','latex', ...
           'FontSize',13, ...
           'FontWeight','bold', ...
           'Color','k');

    ylabel([nombres{i} ' [' unidades{i} ']'], ...
           'Interpreter','latex', ...
           'FontSize',13, ...
           'FontWeight','bold', ...
           'Color','k');

    title(['Respuesta al escalon - ' nombres{i}], ...
          'Interpreter','latex', ...
          'FontSize',15, ...
          'FontWeight','bold', ...
          'Color','k');

    ax = gca;
    ax.FontSize = 12;
    ax.FontWeight = 'bold';
    ax.LineWidth = 1.2;
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.GridAlpha = 0.25;
end

sgtitle('Respuesta de los estados ante entrada escalon unitario', ...
        'Interpreter','latex', ...
        'FontSize',20, ...
        'FontWeight','bold', ...
        'Color','k');

exportgraphics(fig2,fullfile(carpeta,'estados_escalon.png'), ...
               'Resolution',300, ...
               'BackgroundColor','white');

%% ============================================================
%  GRAFICAS DE SALIDAS ANTE ENTRADA IMPULSO
%  y = [theta ; x]
%  ============================================================

fig3 = figure('Name','Salidas ante entrada impulso','Color','w');
set(fig3,'Position',[200 150 1200 600]);

plot(t,y_imp(1,:),'LineWidth',2.4);
hold on;
plot(t,y_imp(2,:),'LineWidth',2.4);
grid on;

xlabel('Tiempo [s]', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

ylabel('Salidas del sistema', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

title('Salidas ante entrada impulso unitario', ...
      'Interpreter','latex', ...
      'FontSize',18, ...
      'FontWeight','bold', ...
      'Color','k');

legend({'$\theta(t)$ [rad]','$x(t)$ [m]'}, ...
       'Interpreter','latex', ...
       'FontSize',13, ...
       'Location','best');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;
ax.XColor = 'k';
ax.YColor = 'k';
ax.GridAlpha = 0.25;

exportgraphics(fig3,fullfile(carpeta,'salidas_impulso.png'), ...
               'Resolution',300, ...
               'BackgroundColor','white');

%% ============================================================
%  GRAFICAS DE SALIDAS ANTE ENTRADA ESCALON
%  y = [theta ; x]
%  ============================================================

fig4 = figure('Name','Salidas ante entrada escalon','Color','w');
set(fig4,'Position',[250 150 1200 600]);

plot(t,y_step(1,:),'LineWidth',2.4);
hold on;
plot(t,y_step(2,:),'LineWidth',2.4);
grid on;

xlabel('Tiempo [s]', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

ylabel('Salidas del sistema', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

title('Salidas ante entrada escalon unitario', ...
      'Interpreter','latex', ...
      'FontSize',18, ...
      'FontWeight','bold', ...
      'Color','k');

legend({'$\theta(t)$ [rad]','$x(t)$ [m]'}, ...
       'Interpreter','latex', ...
       'FontSize',13, ...
       'Location','best');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;
ax.XColor = 'k';
ax.YColor = 'k';
ax.GridAlpha = 0.25;

exportgraphics(fig4,fullfile(carpeta,'salidas_escalon.png'), ...
               'Resolution',300, ...
               'BackgroundColor','white');

%% ============================================================
%  GRAFICA COMPARATIVA DEL ANGULO
%  ============================================================

fig5 = figure('Name','Comparacion angular','Color','w');
set(fig5,'Position',[300 150 1200 600]);

plot(t,x_imp(1,:),'LineWidth',2.4);
hold on;
plot(t,x_step(1,:),'LineWidth',2.4);
grid on;

xlabel('Tiempo [s]', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

ylabel('$\theta(t)$ [rad]', ...
       'Interpreter','latex', ...
       'FontSize',14, ...
       'FontWeight','bold', ...
       'Color','k');

title('Comparacion de la respuesta angular', ...
      'Interpreter','latex', ...
      'FontSize',18, ...
      'FontWeight','bold', ...
      'Color','k');

legend({'Impulso unitario','Escalon unitario'}, ...
       'Interpreter','latex', ...
       'FontSize',13, ...
       'Location','best');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;
ax.XColor = 'k';
ax.YColor = 'k';
ax.GridAlpha = 0.25;

exportgraphics(fig5,fullfile(carpeta,'comparacion_theta.png'), ...
               'Resolution',300, ...
               'BackgroundColor','white');

%% ============================================================
%  MENSAJE FINAL
%  ============================================================

disp('Graficas generadas correctamente.');
disp('Las imagenes fueron guardadas en la carpeta:');
disp(carpeta);