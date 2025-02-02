%% Algoritmo por fuerza bruta para desarrollo optimo de platos/piñones en una bici

clear; clc;
tic;
count = 0;
bici.normr = 100; % valor inicial que cualquier combinación del algoritmo mejorará

% Bucles Anidados para recorrer todas las configuraciones diferentes de
% numero de dientes para los platos de la bici
for N1 = 32:42 % como N1 = M7, que esta comprendido entre 14 y 42, los valores de N1 mayores de 40 no interesan
   
   % al iterar desde el plato/piñon anterior +1 hasta el ultimo posible 
   % aseguramos que se respete la restriccion de orden.
    for N2 = N1+1:51 
        
        for N3 = max(N2+1,48):52 % N3 no puede ser menor que 48 si queremos que se cumpla siempre N3/M1 <=4
           
            M7 = N1; % Esto fuerza a que el menor desarrollo sea N1/M7 = 1
           
            M1 = ceil(N3/4);
            % usamos ceil() para redondear ya que N3/M1<=4 --> M1>=N3/4
            % y si dejamos que redondee M1 a la baja pueden salir desarrollos > 4
             
            % Bucles anidados para los pinones
            for M2 = M1+1:M7-5
                for M3 = M2+1:M7-4
                    for M4 = M3+1:M7-3
                        for M5 = M4+1:M7-2
                            for M6 = M5+1:M7-1
                              platos = [N1,N2,N3];                           
                              pinones = [M1,M2,M3,M4,M5,M6,M7];              
                              desarrollos = calcDesarrollo(platos,pinones);  % ordenamos y aplanamos los desarrollos en una funcion aparte
                              normrAux = normrBici(desarrollos); % Calculamos la norma del desarrollo actual
                              if bici.normr > normrAux % si la norma actual es mejor que la teniamos guardada, actualizamos la estructura bici.
                                 bici.platos = platos;
                                 bici.pinones = pinones;
                                 bici.desarrollos = desarrollos;
                                 bici.normr = normrAux;
                                 
                              end
                              count = count +1 % Contador para ver el progreso del algoritmo
                            end
                        end
                    end
                end
            end   
            
    
        end
    end
end
toc;


fprintf('Platos:');
bici.platos
fprintf('Piñones:');
bici.pinones
fprintf('Normr: %f \n',bici.normr);
