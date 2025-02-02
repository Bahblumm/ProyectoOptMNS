% Optimización de un cambio: estrategia por fuerza bruta

clear;clc;
tic;
count=0;

% desarrollo = (dientes de un plato)/(dientes de un piñón) = N/M
% 3 platos x 7 piñones = conjuntos de 21 desarrolos
% platos de 32 a 52 dientes, piñones de 12 a 42. (bajo restricciones dadas)

Dkopt=1:0.15:4; % desarrollos óptimos a intervalos regulares

% primera elección de soporte: conjunto con menor número de dientes posible
ne=[32 33 48];
me=[12 13 14 15 16 17 32];
Dkp1=[ne(1)./me ne(2)./me ne(3)./me];
bici=struct('platos',ne,'pinones',me,'desarrollos',Dkp1,'normr',sqrt(sum((Dkp1-Dkopt).^2)));

% bucles que iteran sobre todos los posibles conjuntos de platos y piñones

for n1=32:42 % ERROR EN EL ENUNCIADO: n1 no puede tomar valores superiores 
             % a 42 porque no es compatible con la segunda restricción
    for n2=n1+1:51
        for n3= max([n2+1 48]):52 
            m7=n1;         % restricciones límites de los desarrollos
            m1=ceil(n3/4); % ERROR EN EL ENUNCIADO: usando round podemos 
                           % tener un desarrollo > 4 que viola dicha
                           % restricción (cuando n3=49), ceil lo soluciona 
                           % sin alterar los desarrollos válidos dados por
                           % round. ESTO SOLO VALE para el planteamiento
                           % concreto que queremos optimizar (ej: no nos
                           % valdría si pudiésemos escojer mas dientes)                                                                                
            for m2=m1+1:m7-5                       
                for m3=m2+1:m7-4
                    for m4=m3+1:m7-3
                        for m5=m4+1:m7-2
                            for m6=m5+1:m7-1
                                n=[n1 n2 n3];               % platos ordenados de menor a mayor
                                m=[m1 m2 m3 m4 m5 m6 m7];   % piñones ordenados de menor a mayor
                                Dkpnew=[n1./m n2./m n3./m]; % desarrollos de la iteración
                                Dknew=sort(Dkpnew);         % vector de desarrollos ordenado de menor a mayor     
                                Normnew=sqrt(sum((Dknew-Dkopt).^2)); % norma de la iteración
                                if Normnew < bici.normr     % comparo con la norma anterior y retengo la mejor
                                    Dk=Dknew;
                                    normr=Normnew
                                    bici= struct('platos',n,'pinones',m,'desarrollos',Dk,'normr',normr);
                                end
                                count=count+1
                            end
                        end
                    end
                end
            end
        end
    end
end

tiempo=toc;
% La estructura final dada contine el conjunto de platos (n) y piñones (m) 
% que minimiza la norma y por tanto optimiza el problema



 

