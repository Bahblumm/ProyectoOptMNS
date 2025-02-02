%% Calculo de desarrollos de una bici mediante variaciones aleatorias

% Usa el mismo principio que la estrategia 2, pero en lugar de solo
% admitir cambios que mejoren la norma, dejamos una probabilidad de que se
% admitan cambios que no empeoren mucho las norma, y que esta probabilidad
% aumente a medida que pasamos mas iteraciones en la misma norma. Esto
% se hace con intención de evitar mínimos locales y que el algoritmo no se
% atasque en una solución no optima.

clc; clear;
tic;


bici.normr = 10; % Norma inicializada con un valor muy facil de mejorar.
mejorBici.normr = 10;
Niter = 100000; % Veces que intentamos cambios aleatorios de platos y/o pinones

% En esta estrategia se aprecia que el numero de iteraciones tiene un
% impacto mayor sobre el resultado, a medida que aumentamos Niter, la
% frecuencia con la que obtenemos como resultado la norma optima aumenta.

% Seleccion inicial aleatoria de platos y piñones
for i = 1:10
    N1 = randi(19)+31; % Escogemos aleatoriamente un conjunto de platos iniciales
    N2 = randi(51-N1)+N1;
    max48N2 = max(48,N2+1); % respetamos siempre las restricciones de orden de los platos
    N3 = randi(53-max48N2)+max48N2-1;
   
    M1 = ceil(N3/4); % Para forzar la condicion N3/M1 <= 4, usamos ceil() pues estamos trabando con enteros
    M7 = N1; % para que se cumpla N1/M7 = 1
    
    M2 = randi(M7-5-M1)+M1; % igual, respetamos el orden de pinones 
    M3 = randi(M7-4-M2)+M2;
    M4 = randi(M7-3-M3)+M3;
    M5 = randi(M7-2-M4)+M4;
    M6 = randi(M7-1-M5)+M5;
    
    platos = [N1,N2,N3];
    pinones = [M1,M2,M3,M4,M5,M6,M7];
    desarrollos =calcDesarrollo(platos,pinones);
    normrAux = normrBici(desarrollos);
    % Seleccionamos el mejor desarrollo de varios intentos inciales.
    if normrAux < bici.normr
       bici.normr = normrAux;
       bici.desarrollos = desarrollos;
       bici.platos = platos;
       bici.pinones = pinones;
    end
    
end
arrNorm = zeros(1,Niter); % inicializacion de un vector con las normas para cada iteracion
arrBestNorm = zeros(1,Niter);
%% Variaciación aleatoria de platos y piñones
% Ahora que tenemos un conjunto de platos y pinones inicial fijo, vamos a
% intentar mejorar la norma cambiando un solo plato o pinon y aceptando el
% cambio si da mejor norma( y respeta las restricciones)

% randi 1 randi 
stuck = 0; % Contador que nos dice cuantas iteraciones llevamos sin mejorar nuestra norma actual.
for  j = 1:Niter
   
   p = randi(8); % cuantos cambios diferentes vamos a hacer.
    
    boundCheck = false; % booleano para controlar si se respetan las restricciones
    while boundCheck == false % mientras no tengamos un cambio que respete las restricciones no pasamos al siguiente intento.
    
    if p<4 % p = 1,2,3 se traduce a cambiar el plato numero 1,2,3
        N = bici.platos;
        % N va a ser un vector auxiliar con los platos en esta iteracion,
        
        % Notese que estamos expresando los platos y pinones como vector
        % esta vez ya que tendremos que escoger uno de ellos aleatoriamente
        % y tenerlos indexados lo hace mas simple
        
        Np =randi(21)+31; % Escogemos un numero de dientes al azar
        
        if isempty(N(N==Np)) % comprobamos que Np no sea igual a algun otro plato
            N(p) = Np; 
            N = sort(N); % Reordenamos los platos para respetar el orden y las restricciones asociadas
            M = bici.pinones; 
            M(1)=ceil(N(3)/4); %imponemos las condiciones usuales
            M(7) = N(1);
            
            M26= M(2:end-1); % vector de pinones sin los extremos
            
            if length(M26(M26< M(7) & M26> M(1))) == 5 % comprobamos que M2-M6 estan comprendidos entre los nuevos M1,M7
                
                desarrollos = calcDesarrollo(N,M);
                normrAux = normrBici(desarrollos); % calculamos la norma del desarrollo de esta iteracion
                boundCheck = true; % Si el programa llega aquí es que se respetan las condiciones y puede pasar al siguiente intento
                
                if normrAux < bici.normr || ( rand()<stuck/50 && abs(bici.normr-normrAux)<0.1 ) % Actualiza la estructura si encontramos una norma mejor, y a veces aleatoriamente 
                    % actualizamos la estructura si la norma ha mejorado y
                    % tambien hay una posibilidad de que la cambiemos si no
                    % empeora mucho, y si llevamos muchas iteraciones con la
                    % misma norma
                    bici.platos = N;
                    bici.pinones = M;
                    bici.desarrollos = desarrollos;
                    bici.normr = normrAux;
                   stuck = 0; %  mejora, reiniciamos el contador stuck
                else
                   stuck = stuck+1; % no mejora, aumentamos el contador stuck, 
                   
                end
            end
        end
        
        
    else
        % si p = 4,5,6,7,8 se traduce a cambiar los pinones 2,3,4,5,6
        % los pinones 1 y 7 dependen de los platos 1 y 3 por lo que ya se
        % han tenido en cuenta la posibilidad de cambiarlos en codigo
        % anterior
        p=p-2;
        M = bici.pinones;
        
        Mp = randi([M(1)+1, M(7)-1]);
        % elegimos un nuevo pinon sabiendo que tiene que estar entre M1 y M7
        
        if isempty(M(M==Mp)) % nos aseguramos de que no se repitan pinones con el cambio
            M(p) = Mp;
            desarrollos = calcDesarrollo(bici.platos,M);
            normrAux = normrBici(desarrollos);
            boundCheck = true;
            % si todo las restricciones se respetan se calcula la norma y
            % se permite el paso al siguiente intento
            if normrAux < bici.normr || (rand()<stuck/50 && abs(bici.normr-normrAux)<0.1 )
                % actualizamos la estructura si la norma ha mejorado y
                % tambien hay una posibilidad de que la cambiemos si no
                % empeora mucho, y si llevamos muchas iteraciones con la
                % misma norma
                
                bici.pinones = M;
                bici.desarrollos = desarrollos;
                bici.normr = normrAux;
                stuck = 0;
            else
                stuck = stuck+1;
                
            end
        end
    end
    end
    
    arrNorm(j) = bici.normr; % guardamos la norma resultante para la iteracion actual j
    if bici.normr < mejorBici.normr
        mejorBici = bici; % comprobamos si hemos encontrado una norma mejor
    
    end
    arrBestNorm(j) = mejorBici.normr; 
end
toc;

fprintf('Platos:');
mejorBici.platos
fprintf('piñones:');
mejorBici.pinones
fprintf('Normr: %f \n',mejorBici.normr);

subplot(2,1,1);
plot(1:Niter,arrNorm) % representacion grafica simple de la evolucion de la norma
title('Evolución de la norma')
ylabel('normr')
xlabel('iteraciones')

subplot(2,1,2);
plot(1:Niter,arrBestNorm)
title('Evolución de la mejor norma')
ylabel('normr')
xlabel('iteraciones')
shg;

