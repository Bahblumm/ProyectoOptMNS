function [sol] = calcDesarrollo(platos,pinones)
 invPinones = 1./pinones; 
 MatrizDesarrollos = platos'*invPinones;
 sol = sort(reshape(MatrizDesarrollos,[1,21]));
end