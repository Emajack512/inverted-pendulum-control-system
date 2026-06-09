function SimulacionPenduloInvertido

clc;
close all;

%% PARAMETROS INICIALES

M0 = 0.75;
m0 = 0.33;
bp0 = 0.01;
bc0 = 0.01;
g0 = 9.81;
l0 = 0.3;
theta0_0 = 0.2;
tf0 = 5;

%% FIGURA PRINCIPAL

fig = figure('Name','Pendulo Invertido SIN COMPENSAR', ...
    'NumberTitle','off', ...
    'Position',[40 40 1600 900], ...
    'Color',[0.12 0.12 0.12]);

%% CONTROLES

uicontrol(fig,'Style','text','String','Parametros del sistema', ...
    'Units','normalized','Position',[0.04 0.95 0.25 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12], ...
    'ForegroundColor','w','FontWeight','bold','FontSize',11);

uicontrol(fig,'Style','text','String','M','Units','normalized', ...
    'Position',[0.04 0.91 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editM = uicontrol(fig,'Style','edit','String',num2str(M0), ...
    'Units','normalized','Position',[0.07 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','m','Units','normalized', ...
    'Position',[0.14 0.91 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editm = uicontrol(fig,'Style','edit','String',num2str(m0), ...
    'Units','normalized','Position',[0.17 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','bc','Units','normalized', ...
    'Position',[0.24 0.91 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editbc = uicontrol(fig,'Style','edit','String',num2str(bc0), ...
    'Units','normalized','Position',[0.27 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','bp','Units','normalized', ...
    'Position',[0.34 0.91 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editbp = uicontrol(fig,'Style','edit','String',num2str(bp0), ...
    'Units','normalized','Position',[0.37 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','l','Units','normalized', ...
    'Position',[0.04 0.87 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editl = uicontrol(fig,'Style','edit','String',num2str(l0), ...
    'Units','normalized','Position',[0.07 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','g','Units','normalized', ...
    'Position',[0.14 0.87 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editg = uicontrol(fig,'Style','edit','String',num2str(g0), ...
    'Units','normalized','Position',[0.17 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','theta0','Units','normalized', ...
    'Position',[0.24 0.87 0.05 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editTheta = uicontrol(fig,'Style','edit','String',num2str(theta0_0), ...
    'Units','normalized','Position',[0.29 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','Tf','Units','normalized', ...
    'Position',[0.36 0.87 0.03 0.03], ...
    'BackgroundColor',[0.12 0.12 0.12],'ForegroundColor','w');
editTf = uicontrol(fig,'Style','edit','String',num2str(tf0), ...
    'Units','normalized','Position',[0.39 0.87 0.05 0.03]);

uicontrol(fig,'Style','pushbutton','String','Actualizar', ...
    'Units','normalized','Position',[0.04 0.82 0.15 0.04], ...
    'FontWeight','bold','Callback',@actualizar);

txtFT = uicontrol(fig,'Style','text','String','', ...
    'Units','normalized','Position',[0.04 0.74 0.40 0.06], ...
    'BackgroundColor',[0.12 0.12 0.12], ...
    'ForegroundColor','w','HorizontalAlignment','left');

%% PESTAÑAS

tabs = uitabgroup(fig,'Units','normalized','Position',[0.04 0.05 0.92 0.74]);

tabSim   = uitab(tabs,'Title','Simulación');
tabResp  = uitab(tabs,'Title','Respuesta temporal');
tabBode  = uitab(tabs,'Title','Bode');
tabLGR   = uitab(tabs,'Title','LGR');
tabPolos = uitab(tabs,'Title','Polos y FT');

tabs.SelectedTab = tabSim;

axAnim = axes('Parent',tabSim,'Position',[0.08 0.10 0.84 0.82]);

axTheta = axes('Parent',tabResp,'Position',[0.08 0.56 0.84 0.34]);
axPos   = axes('Parent',tabResp,'Position',[0.08 0.10 0.84 0.34]);

panelBode = uipanel('Parent',tabBode, ...
    'Units','normalized', ...
    'Position',[0.03 0.05 0.94 0.90], ...
    'BackgroundColor',[0.12 0.12 0.12], ...
    'BorderType','none');

axLGR = axes('Parent',tabLGR,'Position',[0.08 0.10 0.84 0.82]);

txtPolos = uicontrol(tabPolos,'Style','edit', ...
    'Units','normalized', ...
    'Position',[0.05 0.08 0.90 0.84], ...
    'Max',20,'Min',1, ...
    'HorizontalAlignment','left', ...
    'BackgroundColor',[0.06 0.06 0.06], ...
    'ForegroundColor','w', ...
    'FontName','Consolas', ...
    'FontSize',10);

%% PREPARAR EJE DE ANIMACION

cla(axAnim)
axis(axAnim,'equal')
axis(axAnim,[-2 2 -1.2 2.2])
grid(axAnim,'on')
setDark(axAnim)
title(axAnim,'Simulacion del pendulo invertido SIN COMPENSAR', ...
    'Color','w','FontWeight','bold','FontSize',12)

drawnow;
actualizar();

%% FUNCION ACTUALIZAR

    function actualizar(~,~)

        M = str2double(get(editM,'String'));
        m = str2double(get(editm,'String'));
        bc = str2double(get(editbc,'String'));
        bp = str2double(get(editbp,'String'));
        l = str2double(get(editl,'String'));
        g = str2double(get(editg,'String'));
        theta0 = str2double(get(editTheta,'String'));
        tfinal = str2double(get(editTf,'String'));

        if any(isnan([M m bc bp l g theta0 tfinal])) || ...
                M <= 0 || m <= 0 || l <= 0 || g <= 0 || tfinal <= 0
            errordlg('Revisá los valores. M, m, l, g y Tf deben ser positivos.','Error');
            return
        end

        %% MODELO EN ESPACIO DE ESTADOS
        % Estados:
        % x1 = theta
        % x2 = theta_punto
        % x3 = x
        % x4 = x_punto

        A = [0, 1, 0, 0;
             ((M+m)*g)/(M*l), -((M+m)*bp)/(M*m*l^2), 0, bc/(M*l);
             0, 0, 0, 1;
             -(m*g)/M, bp/(M*l), 0, -bc/M];

        B = [0;
             -1/(M*l);
              0;
              1/M];

        C = eye(4);
        D = zeros(4,1);

        sys = ss(A,B,C,D);

        Ctheta = [1 0 0 0];
        Gtheta = tf(ss(A,B,Ctheta,0));

        G_bode = minreal(-Gtheta);
        G_LGR  = minreal(-Gtheta);

        x0 = [theta0; 0; 0; 0];
        t = 0:0.005:tfinal;

        [~,t,x] = initial(sys,x0,t);

        %% LIMPIEZA

        cla(axTheta);
        cla(axPos);
        cla(axLGR);
        cla(axAnim);
        delete(allchild(panelBode));

        %% RESPUESTA TEMPORAL - ANGULO

        plot(axTheta,t,x(:,1),'LineWidth',2)
        grid(axTheta,'on')
        title(axTheta,'Respuesta temporal del angulo','Color','w','FontWeight','bold')
        xlabel(axTheta,'Tiempo (s)','Color','w')
        ylabel(axTheta,'\theta (rad)','Color','w')
        setDark(axTheta)

        %% RESPUESTA TEMPORAL - POSICION

        plot(axPos,t,x(:,3),'LineWidth',2)
        grid(axPos,'on')
        title(axPos,'Posicion del carro','Color','w','FontWeight','bold')
        xlabel(axPos,'Tiempo (s)','Color','w')
        ylabel(axPos,'x (m)','Color','w')
        setDark(axPos)

        %% BODE EN PESTAÑA

        [mag,phase,w] = bode(G_bode);
        mag = squeeze(mag);
        phase = squeeze(phase);

        phase = mod(phase + 180,360) - 180;

        axBodeMag = axes('Parent',panelBode, ...
            'Units','normalized', ...
            'Position',[0.08 0.58 0.86 0.34]);

        semilogx(axBodeMag,w,20*log10(mag),'LineWidth',2)
        grid(axBodeMag,'on')
        title(axBodeMag,'Bode de \Theta(s)/[-U(s)]','Color','w','FontWeight','bold')
        ylabel(axBodeMag,'Magnitud (dB)','Color','w')
        setDark(axBodeMag)

        axBodePhase = axes('Parent',panelBode, ...
            'Units','normalized', ...
            'Position',[0.08 0.12 0.86 0.34]);

        semilogx(axBodePhase,w,phase,'LineWidth',2)
        grid(axBodePhase,'on')
        xlabel(axBodePhase,'Frecuencia (rad/s)','Color','w')
        ylabel(axBodePhase,'Fase (deg)','Color','w')
        setDark(axBodePhase)

        %% LGR CON RLOCUS

        axes(axLGR)
        rlocus(G_LGR)
        grid on

        title(axLGR,'LGR SIN COMPENSAR - G_{LGR}(s) = -G_\theta(s)', ...
            'Color','w','FontWeight','bold')
        xlabel(axLGR,'Eje real','Color','w')
        ylabel(axLGR,'Eje imaginario','Color','w')
        setDark(axLGR)

        %% FUNCION DE TRANSFERENCIA, POLOS Y CEROS

        [num,den] = tfdata(Gtheta,'v');

        set(txtFT,'String',sprintf('Gtheta(s) = theta(s)/F(s)\nNum: %s\nDen: %s', ...
            mat2str(num,4),mat2str(den,4)));

        polos = pole(G_LGR);
        ceros = zero(G_LGR);

        txtInfo = sprintf('FUNCION DE TRANSFERENCIA REAL\n\n');
        txtInfo = [txtInfo sprintf('Gtheta(s) = theta(s)/F(s)\n\n')];
        txtInfo = [txtInfo sprintf('Numerador:\n%s\n\n', mat2str(num,6))];
        txtInfo = [txtInfo sprintf('Denominador:\n%s\n\n', mat2str(den,6))];

        txtInfo = [txtInfo sprintf('\nPLANTA USADA PARA BODE Y LGR\n\n')];
        txtInfo = [txtInfo sprintf('G_bode(s) = G_LGR(s) = -Gtheta(s)\n\n')];

        txtInfo = [txtInfo sprintf('POLOS DE G_LGR:\n')];
        for i = 1:length(polos)
            txtInfo = [txtInfo sprintf('p%d = %.6f %+.6fj\n', i, real(polos(i)), imag(polos(i)))];
        end

        txtInfo = [txtInfo sprintf('\nCEROS DE G_LGR:\n')];
        for i = 1:length(ceros)
            txtInfo = [txtInfo sprintf('z%d = %.6f %+.6fj\n', i, real(ceros(i)), imag(ceros(i)))];
        end

        txtInfo = [txtInfo sprintf('\nAUTOVALORES DE A:\n')];
        autovalores = eig(A);
        for i = 1:length(autovalores)
            txtInfo = [txtInfo sprintf('lambda%d = %.6f %+.6fj\n', i, real(autovalores(i)), imag(autovalores(i)))];
        end

        set(txtPolos,'String',txtInfo);

        %% ANIMACION

        tabs.SelectedTab = tabSim;

        for k = 1:3:length(t)

            cla(axAnim)

            cart_x = x(k,3);

            cart_width = 0.9;
            cart_height = 0.32;
            cart_y = -0.12;

            joint_x = cart_x;
            joint_y = cart_y + cart_height;

            pend_x = joint_x + l*sin(x(k,1));
            pend_y = joint_y + l*cos(x(k,1));

            hold(axAnim,'on')

            plot(axAnim,[-2 2],[0 0],'k','LineWidth',3)

            rectangle(axAnim,'Position',[cart_x-cart_width/2,cart_y,cart_width,cart_height], ...
                'FaceColor',[0.05 0.25 1], ...
                'EdgeColor','k', ...
                'LineWidth',2)

            wheel_r = 0.09;

            rectangle(axAnim,'Position',[cart_x-0.32-wheel_r,cart_y-0.08-wheel_r,2*wheel_r,2*wheel_r], ...
                'Curvature',[1 1], ...
                'FaceColor','k', ...
                'EdgeColor','k')

            rectangle(axAnim,'Position',[cart_x+0.32-wheel_r,cart_y-0.08-wheel_r,2*wheel_r,2*wheel_r], ...
                'Curvature',[1 1], ...
                'FaceColor','k', ...
                'EdgeColor','k')

            plot(axAnim,[joint_x pend_x],[joint_y pend_y],'r','LineWidth',5)

            plot(axAnim,pend_x,pend_y,'ko','MarkerSize',22,'MarkerFaceColor','k')
            plot(axAnim,joint_x,joint_y,'ko','MarkerSize',9,'MarkerFaceColor','k')

            axis(axAnim,'equal')
            axis(axAnim,[-2 2 -1.2 2.2])
            grid(axAnim,'on')

            title(axAnim,'Simulacion del pendulo invertido SIN COMPENSAR', ...
                'Color','w','FontWeight','bold','FontSize',12)

            xlabel(axAnim,'Posicion horizontal (m)','Color','w')
            ylabel(axAnim,'Altura (m)','Color','w')

            setDark(axAnim)

            drawnow
        end

        disp('Funcion de transferencia actualizada:')
        Gtheta

        disp('Polos del sistema:')
        disp(eig(A))

    end

%% FUNCION PARA ESTILO OSCURO

    function setDark(ax)
        set(ax,'Color',[0.06 0.06 0.06], ...
            'XColor','w', ...
            'YColor','w', ...
            'GridColor',[0.7 0.7 0.7], ...
            'FontSize',9);
    end

end