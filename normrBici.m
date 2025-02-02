function [sol] = normrBici(desarrollo) 
% función norma que compara un desarrollo dado con el optimo teórico. El
% desarrollo debe ser un vector fila de 21 componentes.

desarrolloOptimo = 1:0.15:4; % Desarrollo optimo teorico para la bici

sol = sqrt(sum((desarrollo-desarrolloOptimo).^2));