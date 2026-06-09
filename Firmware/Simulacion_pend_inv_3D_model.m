function SimulacionPenduloInvertidov13_LentoHelicoptero

clc;
close all;

%% PARAMETROS INICIALES

M0 = 0.75;        % masa del bloque [kg]
m0 = 0.33;        % masa de la pelota [kg]
bp0 = 0.01;       % friccion pendulo
bc0 = 0.01;       % friccion carro
g0 = 9.81;        % gravedad [m/s^2]
l0 = 0.30;        % largo del brazo [m]
theta0_0 = 0;   % condicion inicial angular [rad]
tf0 = 0.8;          % tiempo final [s]
uAmp0 = 1;        % Escalon: N | Impulso: N*s

%% FIGURA PRINCIPAL

fig = figure('Name','Pendulo Invertido - Planta no compensada - GIF lento y giro lineal', ...
    'NumberTitle','off', ...
    'Position',[40 40 1600 900], ...
    'Color','w');

runID = 0;
lastSim = [];

%% CONTROLES

uicontrol(fig,'Style','text','String','Parametros del sistema', ...
    'Units','normalized','Position',[0.04 0.95 0.25 0.03], ...
    'BackgroundColor','w', ...
    'ForegroundColor','k','FontWeight','bold','FontSize',11);

uicontrol(fig,'Style','text','String','M','Units','normalized', ...
    'Position',[0.04 0.91 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editM = uicontrol(fig,'Style','edit','String',num2str(M0), ...
    'Units','normalized','Position',[0.07 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','m','Units','normalized', ...
    'Position',[0.14 0.91 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editm = uicontrol(fig,'Style','edit','String',num2str(m0), ...
    'Units','normalized','Position',[0.17 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','bc','Units','normalized', ...
    'Position',[0.24 0.91 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editbc = uicontrol(fig,'Style','edit','String',num2str(bc0), ...
    'Units','normalized','Position',[0.27 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','bp','Units','normalized', ...
    'Position',[0.34 0.91 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editbp = uicontrol(fig,'Style','edit','String',num2str(bp0), ...
    'Units','normalized','Position',[0.37 0.91 0.05 0.03]);

uicontrol(fig,'Style','text','String','l','Units','normalized', ...
    'Position',[0.04 0.87 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editl = uicontrol(fig,'Style','edit','String',num2str(l0), ...
    'Units','normalized','Position',[0.07 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','g','Units','normalized', ...
    'Position',[0.14 0.87 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editg = uicontrol(fig,'Style','edit','String',num2str(g0), ...
    'Units','normalized','Position',[0.17 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','theta0','Units','normalized', ...
    'Position',[0.24 0.87 0.05 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editTheta = uicontrol(fig,'Style','edit','String',num2str(theta0_0), ...
    'Units','normalized','Position',[0.29 0.87 0.05 0.03]);

uicontrol(fig,'Style','text','String','Tf','Units','normalized', ...
    'Position',[0.36 0.87 0.03 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');
editTf = uicontrol(fig,'Style','edit','String',num2str(tf0), ...
    'Units','normalized','Position',[0.39 0.87 0.05 0.03], ...
    'Callback',@actualizar, ...
    'Interruptible','on','BusyAction','queue');

uicontrol(fig,'Style','text','String','Simulacion','Units','normalized', ...
    'Position',[0.48 0.91 0.08 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');

popupModo = uicontrol(fig,'Style','popupmenu', ...
    'String',{'Sistema no compensado','Entrada escalon','Entrada impulso'}, ...
    'Value',1, ...
    'Units','normalized','Position',[0.56 0.91 0.14 0.03], ...
    'Callback',@actualizar, ...
    'Interruptible','on','BusyAction','queue');

uicontrol(fig,'Style','text','String','Amp / Area','Units','normalized', ...
    'Position',[0.48 0.87 0.08 0.03], ...
    'BackgroundColor','w','ForegroundColor','k');

editAmp = uicontrol(fig,'Style','edit','String',num2str(uAmp0), ...
    'Units','normalized','Position',[0.56 0.87 0.08 0.03], ...
    'Callback',@actualizar, ...
    'Interruptible','on','BusyAction','queue');

txtEntrada = uicontrol(fig,'Style','text','String','Escalon: fuerza [N] | Impulso: area [N*s]', ...
    'Units','normalized','Position',[0.72 0.87 0.24 0.03], ...
    'BackgroundColor','w', ...
    'ForegroundColor','k', ...
    'HorizontalAlignment','left');

uicontrol(fig,'Style','pushbutton','String','Actualizar', ...
    'Units','normalized','Position',[0.04 0.82 0.13 0.04], ...
    'FontWeight','bold','Callback',@actualizar, ...
    'Interruptible','on','BusyAction','queue');

uicontrol(fig,'Style','pushbutton','String','Guardar GIF actual lento', ...
    'Units','normalized','Position',[0.19 0.82 0.15 0.04], ...
    'FontWeight','bold','Callback',@guardarGifActual, ...
    'Interruptible','on','BusyAction','queue');

uicontrol(fig,'Style','pushbutton','String','GIF escalon + impulso', ...
    'Units','normalized','Position',[0.36 0.82 0.20 0.04], ...
    'FontWeight','bold','Callback',@exportarEscalonImpulso, ...
    'Interruptible','on','BusyAction','queue');

txtFT = uicontrol(fig,'Style','text','String','', ...
    'Units','normalized','Position',[0.04 0.74 0.52 0.06], ...
    'BackgroundColor','w', ...
    'ForegroundColor','k','HorizontalAlignment','left');

%% PESTAÑAS

tabs = uitabgroup(fig,'Units','normalized','Position',[0.04 0.05 0.92 0.74]);

tabSim   = uitab(tabs,'Title','Simulacion 3D');
tabResp  = uitab(tabs,'Title','Respuesta temporal');
tabBode  = uitab(tabs,'Title','Bode');
tabLGR   = uitab(tabs,'Title','LGR');
tabPolos = uitab(tabs,'Title','Polos y FT');

tabs.SelectedTab = tabSim;

axAnim = axes('Parent',tabSim,'Position',[0.05 0.08 0.90 0.86]);

axTheta = axes('Parent',tabResp,'Position',[0.08 0.56 0.84 0.34]);
axPos   = axes('Parent',tabResp,'Position',[0.08 0.10 0.84 0.34]);

panelBode = uipanel('Parent',tabBode, ...
    'Units','normalized', ...
    'Position',[0.03 0.05 0.94 0.90], ...
    'BackgroundColor','w', ...
    'BorderType','none');

axLGR = axes('Parent',tabLGR,'Position',[0.08 0.10 0.84 0.82]);

txtPolos = uicontrol(tabPolos,'Style','edit', ...
    'Units','normalized', ...
    'Position',[0.05 0.08 0.90 0.84], ...
    'Max',20,'Min',1, ...
    'HorizontalAlignment','left', ...
    'BackgroundColor','w', ...
    'ForegroundColor','k', ...
    'FontName','Consolas', ...
    'FontSize',10);

aplicarTemaClaro();
actualizar();

%% ACTUALIZAR

    function actualizar(~,~)

        runID = runID + 1;
        thisRunID = runID;

        S = simularSistema();
        if isempty(S)
            return
        end

        lastSim = S;

        cla(axTheta);
        cla(axPos);
        cla(axLGR);
        cla(axAnim);
        delete(allchild(panelBode));

        %% RESPUESTA TEMPORAL - ANGULO

        plot(axTheta,S.t,S.x(:,1),'LineWidth',2)
        grid(axTheta,'on')
        title(axTheta,['Respuesta temporal del angulo - ' S.textoEntrada], ...
            'Color','k','FontWeight','bold')
        xlabel(axTheta,'Tiempo (s)','Color','k')
        ylabel(axTheta,'\theta (rad)','Color','k')
        setDark(axTheta)
        xlim(axTheta,[0 min(0.5,S.tfinal)])

        %% RESPUESTA TEMPORAL - POSICION

        plot(axPos,S.t,S.x(:,3),'LineWidth',2)
        grid(axPos,'on')
        title(axPos,'Posicion del carro','Color','k','FontWeight','bold')
        xlabel(axPos,'Tiempo (s)','Color','k')
        ylabel(axPos,'x (m)','Color','k')
        setDark(axPos)
        xlim(axPos,[0 min(0.5,S.tfinal)])

        %% BODE

        [mag,phase,w] = bode(S.G_bode);
        mag = squeeze(mag);
        phase = squeeze(phase);
        phase = mod(phase + 180,360) - 180;

        axBodeMag = axes('Parent',panelBode, ...
            'Units','normalized', ...
            'Position',[0.08 0.58 0.86 0.34]);

        semilogx(axBodeMag,w,20*log10(mag),'LineWidth',2)
        grid(axBodeMag,'on')
        title(axBodeMag,'Bode de \Theta(s)/[-F(s)]', ...
            'Color','k','FontWeight','bold')
        ylabel(axBodeMag,'Magnitud (dB)','Color','k')
        setDark(axBodeMag)

        axBodePhase = axes('Parent',panelBode, ...
            'Units','normalized', ...
            'Position',[0.08 0.12 0.86 0.34]);

        semilogx(axBodePhase,w,phase,'LineWidth',2)
        grid(axBodePhase,'on')
        xlabel(axBodePhase,'Frecuencia (rad/s)','Color','k')
        ylabel(axBodePhase,'Fase (deg)','Color','k')
        setDark(axBodePhase)

        %% LGR

        axes(axLGR)
        rlocus(S.G_LGR)
        grid on
        title(axLGR,'LGR SIN COMPENSAR - G_{LGR}(s) = -G_\theta(s)', ...
            'Color','k','FontWeight','bold')
        xlabel(axLGR,'Eje real','Color','k')
        ylabel(axLGR,'Eje imaginario','Color','k')
        setDark(axLGR)

        %% FT, POLOS Y CEROS

        [num,den] = tfdata(S.Gtheta,'v');

        set(txtFT,'String',sprintf('%s\nGtheta(s) = theta(s)/F(s)\nNum: %s\nDen: %s', ...
            S.textoEntrada, mat2str(num,4),mat2str(den,4)));

        polos = pole(S.G_LGR);
        ceros = zero(S.G_LGR);

        txtInfo = sprintf('ENTRADA SIMULADA\n%s\n\nFUNCION DE TRANSFERENCIA REAL\n\n', S.textoEntrada);
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
        autovalores = eig(S.A);
        for i = 1:length(autovalores)
            txtInfo = [txtInfo sprintf('lambda%d = %.6f %+.6fj\n', i, real(autovalores(i)), imag(autovalores(i)))];
        end

        set(txtPolos,'String',txtInfo);

        %% ANIMACION EN PESTAÑA

        tabs.SelectedTab = tabSim;

        nFramesAnim = 300;
        nAnimFinal = min(S.idxAnimEnd,numel(S.t));
        idxAnim = unique(round(linspace(1,nAnimFinal,min(nFramesAnim,nAnimFinal))));
        idxAnim = idxAnim(:);

        for ii = 1:numel(idxAnim)

            if thisRunID ~= runID || ~ishandle(fig) || ~ishandle(axAnim)
                break
            end

            tfUsuario = str2double(get(editTf,'String'));
            if ~isnan(tfUsuario) && tfUsuario > 0 && abs(tfUsuario - S.tfinal) > 1e-12
                actualizar();
                break
            end

            k = idxAnim(ii);
            dibujarFrame3D(axAnim,S,k);

            drawnow limitrate

            if thisRunID ~= runID
                break
            end
        end

        disp('Funcion de transferencia actualizada:')
        S.Gtheta

        disp('Polos del sistema:')
        disp(eig(S.A))

    end

%% SIMULAR SISTEMA

    function S = simularSistema()

        M = str2double(get(editM,'String'));
        m = str2double(get(editm,'String'));
        bc = str2double(get(editbc,'String'));
        bp = str2double(get(editbp,'String'));
        l = str2double(get(editl,'String'));
        g = str2double(get(editg,'String'));
        theta0 = str2double(get(editTheta,'String'));
        tfinal = str2double(get(editTf,'String'));
        uAmp = str2double(get(editAmp,'String'));

        listaModos = get(popupModo,'String');
        tipoModo = listaModos{get(popupModo,'Value')};

        if any(isnan([M m bc bp l g theta0 tfinal uAmp])) || ...
                M <= 0 || m <= 0 || l <= 0 || g <= 0 || tfinal <= 0
            errordlg('Revisa los valores. M, m, l, g y Tf deben ser positivos. Amp/Area debe ser numerico.','Error');
            S = [];
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

        dt = 0.005;
        t = 0:dt:tfinal;

        switch tipoModo

            case 'Sistema no compensado'
                x0 = [theta0; 0; 0; 0];
                u = zeros(size(t));
                textoEntrada = sprintf('Sistema no compensado: theta0 = %.4g rad, u(t)=0', theta0);
                modoFlecha = 'ninguna';
                nombreGif = sprintf('pendulo_invertido_no_compensado_theta0_%srad.gif', numeroArchivo(theta0));

            case 'Entrada escalon'
                x0 = zeros(4,1);
                u = uAmp*ones(size(t));
                textoEntrada = sprintf('Entrada escalon: F = %.4g N', uAmp);
                modoFlecha = 'escalon';
                nombreGif = sprintf('pendulo_invertido_escalon_%sN.gif', numeroArchivo(uAmp));

            case 'Entrada impulso'
                x0 = zeros(4,1);
                u = zeros(size(t));

                % Impulso aproximado por pulso rectangular.
                % Area = fuerza * tiempo = uAmp [N*s]
                anchoImpulso = 0.02;
                nImp = max(1,round(anchoImpulso/dt));
                nImp = min(nImp,numel(t));
                u(1:nImp) = uAmp/(nImp*dt);

                textoEntrada = sprintf('Entrada impulso: J = %.4g N*s', uAmp);
                modoFlecha = 'impulso';
                nombreGif = sprintf('pendulo_invertido_impulso_%sNs.gif', numeroArchivo(uAmp));
        end

        set(txtEntrada,'String',sprintf('Tf = %.3g s | Graficas: 0 a %.1f s | GIF con flecha para escalon/impulso', ...
            tfinal, min(0.5,tfinal)));

        [~,t,x] = lsim(sys,u,t,x0);

        % Limites fisicos usados por el render.
        % La planta lineal sigue calculandose completa, pero la animacion
        % muestra la dinamica real hasta el primer choque con un tope.
        cartW_col = 0.16;
        xMinFisico = -0.64 + cartW_col/2;
        xMaxFisico =  0.82 - cartW_col/2;
        idxCol = find(x(:,3) < xMinFisico | x(:,3) > xMaxFisico,1,'first');

        % La animacion y el GIF se exportan hasta el final de Tf.
        % Si el carro choca con un tope, visualmente queda detenido contra el tope,
        % pero theta sigue usando la dinamica lineal completa. Asi se ve el giro
        % tipo "helicoptero" luego del impacto.
        idxAnimEnd = numel(t);

        S.M = M;
        S.m = m;
        S.bc = bc;
        S.bp = bp;
        S.l = l;
        S.g = g;
        S.theta0 = theta0;
        S.tfinal = tfinal;
        S.uAmp = uAmp;
        S.dt = dt;
        S.t = t;
        S.x = x;
        S.u = u;
        S.A = A;
        S.B = B;
        S.sys = sys;
        S.Gtheta = Gtheta;
        S.G_bode = G_bode;
        S.G_LGR = G_LGR;
        S.textoEntrada = textoEntrada;
        S.tipoModo = tipoModo;
        S.modoFlecha = modoFlecha;
        S.nombreGif = nombreGif;
        S.xMinFisico = xMinFisico;
        S.xMaxFisico = xMaxFisico;
        S.idxCol = idxCol;
        S.idxAnimEnd = idxAnimEnd;

    end

%% GUARDAR GIF ACTUAL

    function guardarGifActual(~,~)

        S = simularSistema();
        if isempty(S)
            return
        end

        lastSim = S;
        tabs.SelectedTab = tabSim;
        drawnow;

        gifname = fullfile(pwd,S.nombreGif);
        exportarGif(S,gifname);

        msgbox(sprintf('GIF guardado como:\n%s',gifname),'GIF listo');

    end

%% EXPORTAR ESCALON + IMPULSO DE 1

    function exportarEscalonImpulso(~,~)

        valorOriginal = get(popupModo,'Value');
        ampOriginal = get(editAmp,'String');

        gif1 = '';
        gif2 = '';

        tabs.SelectedTab = tabSim;
        drawnow;

        set(editAmp,'String','1');

        set(popupModo,'Value',2);
        S1 = simularSistema();
        if ~isempty(S1)
            gif1 = fullfile(pwd,S1.nombreGif);
            exportarGif(S1,gif1);
        end

        set(popupModo,'Value',3);
        S2 = simularSistema();
        if ~isempty(S2)
            gif2 = fullfile(pwd,S2.nombreGif);
            exportarGif(S2,gif2);
        end

        set(popupModo,'Value',valorOriginal);
        set(editAmp,'String',ampOriginal);

        aplicarTemaClaro();
        actualizar();

        msgbox(sprintf('GIFs guardados en:\n%s\n%s',gif1,gif2),'GIFs listos');

    end

%% EXPORTAR GIF

    function exportarGif(S,gifname)

        fpsGif = 25;
        factorLentitudGif = 3;      % 3 = GIF tres veces mas lento que el original
        delay = factorLentitudGif/fpsGif;

        nFrames = max(2,ceil(S.t(end)*fpsGif));
        idxGif = unique(round(linspace(1,numel(S.t),nFrames)));
        idxGif = idxGif(:);

        % Figura limpia para exportar el GIF
        figGif = figure('Color','w', ...
            'Units','pixels', ...
            'Position',[100 100 1600 900], ...
            'MenuBar','none', ...
            'ToolBar','none', ...
            'Resize','off', ...
            'Visible','on');

        axGif = axes('Parent',figGif, ...
            'Units','normalized', ...
            'Position',[0.01 0.01 0.98 0.96]);

        for ii = 1:numel(idxGif)

            if ~ishandle(figGif)
                return
            end

            k = idxGif(ii);

            dibujarFrame3D(axGif,S,k);

            % Reencuadre especial SOLO para el GIF
            axis(axGif,'equal');
            axis(axGif,[-1.15 1.25 -0.75 0.55 -0.35 0.90]);
            view(axGif,[45 24]); %isometrica
            %view(axGif,[0 0]); %frontal
            camproj(axGif,'orthographic');
            axis(axGif,'off');

            drawnow;

            frame = getframe(figGif);
            im = frame2im(frame);
            [Aind,map] = rgb2ind(im,256);

            if ii == 1
                imwrite(Aind,map,gifname,'gif','LoopCount',inf,'DelayTime',delay);
            else
                imwrite(Aind,map,gifname,'gif','WriteMode','append','DelayTime',delay);
            end

        end

        close(figGif);

    end
%% DIBUJAR FRAME 3D

    function dibujarFrame3D(ax,S,k)

        cla(ax);
        hold(ax,'on');

        set(ax,'Color','w', ...
            'XColor','k', ...
            'YColor','k', ...
            'ZColor','k');

        % Vista isometrica ortografica para que se entienda la profundidad.
        axis(ax,'equal');
        axis(ax,[-1.06 1.16 -0.38 0.30 -0.30 0.62]);
        view(ax,[45 24]);
        camproj(ax,'orthographic');
        grid(ax,'off');
        axis(ax,'off');

        camlight(ax,'headlight');
        camlight(ax,'right');
        lighting(ax,'gouraud');

        tNow = S.t(k);

        xModelo = S.x(k,3);
        thetaModelo = S.x(k,1);

        if ~isfinite(xModelo) || ~isfinite(thetaModelo)
            text(ax,0.50,0.50,'La simulacion divergio numericamente', ...
                'Units','normalized', ...
                'Color','r','FontWeight','bold','FontSize',14, ...
                'HorizontalAlignment','center');
            return
        end

        %% GEOMETRIA GENERAL

        cartW = 0.16;
        cartD = 0.18;
        cartH = 0.20;

        xMinFisico = S.xMinFisico;
        xMaxFisico = S.xMaxFisico;

        % La visualizacion usa la dinamica real hasta el choque.
        % Despues del choque se mantiene la pose de impacto, porque fisicamente
        % el carrito no podria atravesar el tope.
        hayChoque = ~isempty(S.idxCol) && k >= S.idxCol;

        if hayChoque
            % El carro no atraviesa el tope: queda visualmente en la posicion de impacto.
            % Pero el pendulo NO se congela: thetaVisual sigue siendo thetaModelo del
            % instante actual para mostrar la dinamica lineal completa.
            xVisual = S.x(S.idxCol,3);
        else
            xVisual = xModelo;
        end

        thetaVisual = thetaModelo;   % sin recorte angular: rota libre incluso despues del choque

        xCart = min(max(xVisual,xMinFisico),xMaxFisico);
        fueraEscala = (xModelo < xMinFisico) || (xModelo > xMaxFisico);

        cartZ0 = 0.005;
        cartZ1 = cartZ0 + cartH;

        % Dos barras/rieles que atraviesan el carrito.
        railZ  = cartZ0 + 0.070;
        railY1 = -0.045;
        railY2 =  0.045;
        railR  = 0.008;

        % El pivote se ubica sobre la cara frontal del carrito, no arriba.
        % Esto copia mejor la referencia 3D: pivote a media altura y pendulo
        % trabajando por fuera del cuerpo, sin colision visual con rieles.
        pendY  = -cartD/2 - 0.045;
        jointX = xCart;
        jointY = pendY;
        jointZ = cartZ0 + 0.120;

        ballR = 0.038;
        rodR  = 0.006;

        ballX = jointX + S.l*sin(thetaVisual);
        ballY = pendY;
        ballZ = jointZ + S.l*cos(thetaVisual);

        %% BASE / GUIA INFERIOR
        % Transparente para que la pelota siga viendose aun si baja del piso.

        patch(ax,[-0.88 1.02 1.02 -0.88],[-0.115 -0.115 0.115 0.115], ...
            [-0.045 -0.045 -0.045 -0.045], ...
            [0.70 0.70 0.70], ...
            'EdgeColor',[0.70 0.70 0.70], ...
            'FaceAlpha',0.25);

        % Patines laterales bajos de la base
        cubo3D(ax,[-0.90 1.04],[-0.118 -0.105],[-0.055 -0.030], ...
            [0.62 0.62 0.62],[0.62 0.62 0.62]);
        cubo3D(ax,[-0.90 1.04],[0.105 0.118],[-0.055 -0.030], ...
            [0.62 0.62 0.62],[0.62 0.62 0.62]);

        %% TOPES FISICOS LATERALES

        cubo3D(ax,[-0.78 -0.64],[-0.115 0.115],[-0.050 0.205], ...
            [0.16 0.16 0.16],[0.02 0.02 0.02]);

        cubo3D(ax,[0.82 0.96],[-0.115 0.115],[-0.050 0.205], ...
            [0.16 0.16 0.16],[0.02 0.02 0.02]);

        % bases/plintos de topes
        cubo3D(ax,[-0.80 -0.62],[-0.130 0.130],[-0.070 -0.050], ...
            [0.70 0.70 0.70],[0.55 0.55 0.55]);
        cubo3D(ax,[0.80 0.98],[-0.130 0.130],[-0.070 -0.050], ...
            [0.70 0.70 0.70],[0.55 0.55 0.55]);

        %% RIELES METALICOS
        % Cilindros reales, no lineas: se ven como barras en isometrica.

        cilindroEntre(ax,[-0.74 railY1 railZ],[0.92 railY1 railZ],railR,[0.08 0.08 0.08],28);
        cilindroEntre(ax,[-0.74 railY2 railZ],[0.92 railY2 railZ],railR,[0.08 0.08 0.08],28);

        % Brillos de los rieles
        cilindroEntre(ax,[-0.74 railY1 railZ+0.007],[0.92 railY1 railZ+0.007],0.0025,[0.72 0.72 0.72],16);
        cilindroEntre(ax,[-0.74 railY2 railZ+0.007],[0.92 railY2 railZ+0.007],0.0025,[0.72 0.72 0.72],16);

        %% BUJES DE RIELES EN TOPES

        cilindroEntre(ax,[-0.655 railY1 railZ],[-0.610 railY1 railZ],0.018,[0.06 0.06 0.06],28);
        cilindroEntre(ax,[-0.655 railY2 railZ],[-0.610 railY2 railZ],0.018,[0.06 0.06 0.06],28);
        cilindroEntre(ax,[0.790 railY1 railZ],[0.835 railY1 railZ],0.018,[0.06 0.06 0.06],28);
        cilindroEntre(ax,[0.790 railY2 railZ],[0.835 railY2 railZ],0.018,[0.06 0.06 0.06],28);

        %% CARRITO / BLOQUE PRINCIPAL

        cubo3D(ax,[xCart-cartW/2 xCart+cartW/2],[-cartD/2 cartD/2],[cartZ0 cartZ1], ...
            [0.88 0.88 0.84],[0.16 0.16 0.16]);

        % tapa superior oscura
        %cubo3D(ax,[xCart-cartW/2 xCart+cartW/2],[-cartD/2 cartD/2],[cartZ1 cartZ1+0.018], ...
         %   [0.22 0.22 0.22],[0.08 0.08 0.08]);

        % placa trasera oscura, parecida al modelo
        %cubo3D(ax,[xCart-cartW/2 xCart+cartW/2],[cartD/2-0.015 cartD/2+0.010],[cartZ0 cartZ1+0.012], ...
         %   [0.25 0.25 0.25],[0.10 0.10 0.10]);

        % Sin conectores/etiquetas celestes: se elimina ese detalle porque
        % no corresponde al modelo real de referencia.

        %% PIVOTE Y SOPORTE DEL PENDULO

        % Soporte lateral corto saliendo de la cara frontal
        %cubo3D(ax,[jointX-0.045 jointX+0.045],[pendY+0.010 -cartD/2],[jointZ-0.020 jointZ+0.020], ...
         %   [0.36 0.36 0.36],[0.12 0.12 0.12]);

        % Buje exterior circular del pivote, eje en Y
        cilindroEntre(ax,[jointX pendY-0.020 jointZ],[jointX pendY+0.025 jointZ],0.030,[0.96 0.96 0.93],36);
        cilindroEntre(ax,[jointX pendY-0.026 jointZ],[jointX pendY-0.018 jointZ],0.019,[0.02 0.02 0.02],36);
        % Sin aro azul en el eje: el pivote queda neutro, como en el modelo 3D.

        %% PENDULO
        % La varilla y la pelota se dibujan al final para que se vean siempre.

        cilindroEntre(ax,[jointX jointY jointZ],[ballX ballY ballZ],rodR,[0.02 0.02 0.02],18);
        esfera3D(ax,ballX,ballY,ballZ,ballR,[1.00 1.00 0.96]);

        %% FLECHA DE FUERZA

        mostrarFlecha = false;
        labelF = '';

        switch S.modoFlecha
            case 'escalon'
                mostrarFlecha = true;
                labelF = sprintf('F = %.3g N',S.uAmp);

            case 'impulso'
                if tNow <= 0.20
                    mostrarFlecha = true;
                    labelF = sprintf('J = %.3g N*s',S.uAmp);
                end
        end

        if mostrarFlecha
            dir = sign(S.uAmp);
            if dir == 0
                dir = 1;
            end

            if dir > 0
                x0 = xCart - 0.34;
                dx = 0.24;
                textX = xCart - 0.36;
            else
                x0 = xCart + 0.34;
                dx = -0.24;
                textX = xCart + 0.16;
            end

            quiver3(ax,x0,pendY+0.13,cartZ1-0.045,dx,0,0,0, ...
                'Color',[0.90 0.02 0.02], ...
                'LineWidth',4, ...
                'MaxHeadSize',1.6);

            text(ax,textX,pendY,cartZ1+0.115,labelF, ...
                'Color',[0.80 0 0], ...
                'FontWeight','bold', ...
                'FontSize',11);
        end

        %% TEXTOS SIN SUPERPOSICION

        titulo = sprintf('Pendulo invertido - planta no compensada | %s',S.textoEntrada);
        title(ax,titulo,'Color','k','FontWeight','bold','FontSize',13);

        text(ax,0.03,0.94,sprintf('t = %.2f s',tNow), ...
            'Units','normalized', ...
            'Color','k','FontWeight','bold','FontSize',11);

        if hayChoque
            textoEstado = sprintf('x modelo = %.3g m | x visual = tope\n\\theta dinamica = %.2f rad = %.1f deg', ...
                xModelo,thetaVisual,rad2deg(thetaVisual));
        else
            textoEstado = sprintf('\\theta = %.2f rad = %.1f deg\nx = %.3g m', ...
                thetaModelo,rad2deg(thetaModelo),xModelo);
        end

        text(ax,0.03,0.89,textoEstado, ...
            'Units','normalized', ...
            'Color','k','FontSize',10, ...
            'VerticalAlignment','top');

        text(ax,0.03,0.81,sprintf('M = %.2f kg | m = %.2f kg | L = %.2f m',S.M,S.m,S.l), ...
            'Units','normalized', ...
            'Color','k','FontSize',10);

        status = {};
        if abs(thetaModelo) > deg2rad(60)
            status{end+1} = 'INESTABLE';
        end
        if fueraEscala
            if hayChoque
                status{end+1} = sprintf('CHOQUE CON TOPE FISICO: x modelo = %.3e m',xModelo);
            else
                status{end+1} = sprintf('FUERA DE ESCALA: x real = %.3e m',xModelo);
            end
        end

        if ~isempty(status)
            text(ax,0.64,0.9,strjoin(status,newline), ...
                'Units','normalized', ...
                'Color','r', ...
                'FontWeight','bold', ...
                'FontSize',12, ...
                'VerticalAlignment','top', ...
                'HorizontalAlignment','left');
        end

        hold(ax,'off');

    end


%% TEMA CLARO

    function aplicarTemaClaro()

        set(fig,'Color','w');

        try
            set(tabSim,'BackgroundColor','w');
            set(tabResp,'BackgroundColor','w');
            set(tabBode,'BackgroundColor','w');
            set(tabLGR,'BackgroundColor','w');
            set(tabPolos,'BackgroundColor','w');
            set(panelBode,'BackgroundColor','w');
        catch
        end

        controles = findall(fig,'Type','uicontrol');

        for i = 1:length(controles)

            h = controles(i);
            estilo = get(h,'Style');

            switch estilo
                case 'text'
                    set(h,'BackgroundColor','w', ...
                        'ForegroundColor','k');

                case {'edit','popupmenu','pushbutton'}
                    set(h,'BackgroundColor',[0.98 0.98 0.98], ...
                        'ForegroundColor','k');
            end
        end

        set(txtFT,'BackgroundColor','w','ForegroundColor','k');

        set(txtPolos,'BackgroundColor','w', ...
            'ForegroundColor','k', ...
            'FontName','Consolas');

    end


%% CILINDRO ENTRE DOS PUNTOS

    function cilindroEntre(ax,p1,p2,r,color,n)

        p1 = p1(:);
        p2 = p2(:);
        v = p2 - p1;
        L = norm(v);

        if L < eps
            return
        end

        ez = v/L;

        if abs(dot(ez,[0;0;1])) < 0.95
            ex = cross(ez,[0;0;1]);
        else
            ex = cross(ez,[0;1;0]);
        end

        ex = ex/norm(ex);
        ey = cross(ez,ex);

        theta = linspace(0,2*pi,n);
        z = [0 L];

        [Theta,Z] = meshgrid(theta,z);

        X = p1(1) + ez(1)*Z + r*(ex(1)*cos(Theta) + ey(1)*sin(Theta));
        Y = p1(2) + ez(2)*Z + r*(ex(2)*cos(Theta) + ey(2)*sin(Theta));
        Zc = p1(3) + ez(3)*Z + r*(ex(3)*cos(Theta) + ey(3)*sin(Theta));

        surf(ax,X,Y,Zc, ...
            'FaceColor',color, ...
            'EdgeColor','none');

        % Tapas del cilindro
        X1 = p1(1) + r*(ex(1)*cos(theta) + ey(1)*sin(theta));
        Y1 = p1(2) + r*(ex(2)*cos(theta) + ey(2)*sin(theta));
        Z1 = p1(3) + r*(ex(3)*cos(theta) + ey(3)*sin(theta));

        X2 = p2(1) + r*(ex(1)*cos(theta) + ey(1)*sin(theta));
        Y2 = p2(2) + r*(ex(2)*cos(theta) + ey(2)*sin(theta));
        Z2 = p2(3) + r*(ex(3)*cos(theta) + ey(3)*sin(theta));

        patch(ax,X1,Y1,Z1,color,'EdgeColor','none');
        patch(ax,X2,Y2,Z2,color,'EdgeColor','none');

    end


%% CUBO 3D

    function cubo3D(ax,xr,yr,zr,faceColor,edgeColor)

        x1 = xr(1); x2 = xr(2);
        y1 = yr(1); y2 = yr(2);
        z1 = zr(1); z2 = zr(2);

        V = [x1 y1 z1;
             x2 y1 z1;
             x2 y2 z1;
             x1 y2 z1;
             x1 y1 z2;
             x2 y1 z2;
             x2 y2 z2;
             x1 y2 z2];

        F = [1 2 3 4;
             5 6 7 8;
             1 2 6 5;
             2 3 7 6;
             3 4 8 7;
             4 1 5 8];

        patch(ax,'Vertices',V,'Faces',F, ...
            'FaceColor',faceColor, ...
            'EdgeColor',edgeColor, ...
            'LineWidth',0.8);

    end

%% ESFERA 3D

    function esfera3D(ax,xc,yc,zc,r,color)

        [Xs,Ys,Zs] = sphere(28);

        surf(ax,xc + r*Xs, yc + r*Ys, zc + r*Zs, ...
            'FaceColor',color, ...
            'EdgeColor','none');

    end

%% ESTILO PARA GRAFICAS

    function setDark(ax)

        set(ax,'Color','w', ...
            'XColor','k', ...
            'YColor','k', ...
            'ZColor','k', ...
            'GridColor',[0.65 0.65 0.65], ...
            'FontSize',9);

        set(get(ax,'Title'),'Color','k');
        set(get(ax,'XLabel'),'Color','k');
        set(get(ax,'YLabel'),'Color','k');
        set(get(ax,'ZLabel'),'Color','k');

    end

%% NOMBRE DE ARCHIVO LIMPIO

    function s = numeroArchivo(v)

        if v < 0
            pref = 'neg';
        else
            pref = '';
        end

        s = sprintf('%.4g',abs(v));
        s = strrep(s,'.','p');
        s = strrep(s,'+','');
        s = strrep(s,'-','m');
        s = [pref s];

    end

end
