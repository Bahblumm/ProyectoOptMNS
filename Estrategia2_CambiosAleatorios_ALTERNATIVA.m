% Optimización de un cambio: mejora de una solución aleatoria

clear;clc;
tic;

% desarrollo = (dientes de un plato)/(dientes de un piñón) = N/M
% 3 platos x 7 piñones = conjuntos de 21 desarrolos
% platos de 32 a 52 dientes, piñones de 12 a 42. (bajo restricciones dadas)

Dkopt=1:0.15:4; % desarrollos óptimos a intervalos regulares

% primera elección de soporte: conjunto con menor número de dientes posible
ne=[32 33 48];
me=[12 13 14 15 16 17 32];
Dkp1=[ne(1)./me ne(2)./me ne(3)./me];
normas = zeros(1,100);
bici=struct('platos',ne,'pinones',me,'desarrollos',Dkp1,'normr',sqrt(sum((Dkp1-Dkopt).^2)));
     
% bucle para escoger la elección inicial de entre un conjunto de elecciones
% aleatorias
for j=1:10 
    n1=randi([32 42],1); 
    n2=randi([n1+1 51],1);
    n3=randi([max([n2+1 48]) 52],1);
    
    m7=n1;         % restricciones límites de los desarrollos
    m1=ceil(n3/4);
    
    m2=randi([m1+1 m7-5],1);
    m3=randi([m2+1 m7-4],1);
    m4=randi([m3+1 m7-3],1);
    m5=randi([m4+1 m7-2],1);
    m6=randi([m5+1 m7-1],1);
    
    np=[n1 n2 n3];                  % platos
    mp=[m1 m2 m3 m4 m5 m6 m7];      % piñones
    Dkpnew=[n1./mp n2./mp n3./mp];  % desarrollos
    Dknew=sort(Dkpnew);             % desarrollos ordenados de menor a mayor 
    Normnew=sqrt(sum((Dknew-Dkopt).^2)); % norma
    if Normnew < bici.normr % comparo con la norma anterior y retengo la mejor
       Dk=Dknew;
       normr=Normnew;
       n=np;
       m=mp;
       bici= struct('platos',n,'pinones',m,'desarrollos',Dk,'normr',normr);
    end
end


for i=1:100 % número de intentos, más intentos = mayor probabilidad de 
            % obtener un mejor conjunto
   
% defino las componentes de los vectores auxiliares sobre los que se hará el
% cambio aleatorio y que parte del mejor conjunto de vectores (platos y
% pinones) retenido que arroja la menor norma. En la primera iteración
% parte de la norma dada por la elección inicial.
    
    n1=n(1);  
    n2=n(2);
    n3=n(3);
    m1=m(1);
    m2=m(2);
    m3=m(3);
    m4=m(4);
    m5=m(5);
    m6=m(6);
    m7=m(7);

    p=randi(8); 
    
% Cambios aleatorios: se realiza un cambio aleatorio en el número de dientes 
% de un plato o piñón aleatorio cumpliendo las restricciones impuestas con 
% if y while. Tras esto, el vector que a sufrido el cambio (platos o 
% piñones) se reordena y se vuelve a imponer las restriciones límites necesarias 

    if p==1    % se escoge un plato al azar que se cambiará por el primero
       n11=randi([32 52],1);       
       while (n11==n2 || n11==n3)  % se vuelve a escoger si coincide con otro
          n11=randi([32 52],1);
       end
       nn=[n11 n2 n3]; % se reemplaza el anterior primer plato por el nuevo escogido aleatoriamente
       nnew=sort(nn);  % se ordena de menor a mayor el vector de platos
       n11=nnew(1);
       n22=nnew(2);
       n33=nnew(3);
       if n33<48       % se imponen las restricciones límites al nuevo conjunto de platos
           n33=48;
       end
       if n11>42       % segunda restricción límite
           n11=42;
       end
       
       % el nuevo vector de platos queda establecido, se repite el mismo
       % procedimiento para los demás posibles cambios aleatorios
       
       nn=[n11 n22 n33]; 
    elseif p==2
        n22=randi([32 52],1);
        while (n22==n1 || n22==n3)
            n22=randi([32 52],1);
        end
        nn=[n1 n22 n3];
        nnew=sort(nn);
        n11=nnew(1);
        n22=nnew(2);
        n33=nnew(3);
        if n33<48
        n33=48;
        end
        if n11>42
           n11=42;
        end
        nn=[n11 n22 n33];
    elseif p==3
        n33=randi([32 52],1);
        while (n33==n1 || n33==n2)
            n33=randi([32 52],1);
        end
        nn=[n1 n2 n33];
        nnew=sort(nn);
        n11=nnew(1);
        n22=nnew(2);
        n33=nnew(3);
        if n33<48
        n33=48;
        end
        if n11>42
           n11=42;
        end
        nn=[n11 n22 n33];
    else
        n11=n(1); 
        n22=n(2);
        n33=n(3);
        nn=[n11 n22 n33]; % definimos el vector aunque no sufra cambio
    end
    
    m77=n11;          % restricciones límites de los piñones
    m11=ceil(n33/4); % m77 y m11 quedan fijados por el conjunto de platos
    
    % Se lleva a cabo el mismo procedimiento de cambio en los piñones pero
    % imponiendo sus restricciones determinadas
    
    if p==4           
        m22=randi([m11+1 m77-1],1);    % piñón aleatorio
        while m22==m3 || m22==m4 || m22==m5 || m22==m6
            m22=randi([m11+1 m77-1],1);
        end
        mm=[m11 m22 m3 m4 m5 m6 m77];  % se reemplaza por el segundo piñon anterior
        mmnew=sort(mm);                % se ordena el vector
        
        m22=mmnew(2);    
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        
        mm=[m11 m22 m33 m44 m55 m66 m77]; % el vector queda establecido
    elseif p==5
        m33=randi([m11+1 m77-1],1);
        while m33==m2 || m33==m4 || m33==m5 || m33==m6
            m33=randi([m11+1 m77-1],1);
        end
        mm=[m11 m2 m33 m4 m5 m6 m77];
        mmnew=sort(mm);
        
        m22=mmnew(2);
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        
        mm=[m11 m22 m33 m44 m55 m66 m77];
    elseif p==6
        m44=randi([m11+1 m77-1],1);
        while m44==m2 || m44==m3 || m44==m5 || m44==m6
            m44=randi([m11+1 m77-1],1);
        end
        mm=[m11 m2 m3 m44 m5 m6 m77];
        mmnew=sort(mm);
        
        m22=mmnew(2);
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        
        mm=[m11 m22 m33 m44 m55 m66 m77];
    elseif p==7
        m55=randi([m11+1 m77-1],1);
        while m55==m2 || m55==m3 || m55==m4 || m55==m6
            m55=randi([m11+1 m77-1],1);
        end
        mm=[m11 m2 m3 m4 m55 m6 m77];
        mmnew=sort(mm);
        
        m22=mmnew(2);
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        
        mm=[m11 m22 m33 m44 m55 m66 m77];
    elseif p==8
        m66=randi([m11+1 m77-1],1);    
        while m66==m2 || m66==m3 || m66==m4 || m66==m5
            m66=randi([m11+1 m77-1],1);
        end
        mm=[m11 m2 m3 m4 m5 m66 m77];
        mmnew=sort(mm);
        
        m22=mmnew(2);
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        
        mm=[m11 m22 m33 m44 m55 m66 m77];
    else
        
        m22=m(2);
        m33=m(3);
        m44=m(4);
        m55=m(5);
        m66=m(6);
        mm=[m11 m22 m33 m44 m55 m66 m77]; 
        
        mmnew=sort(mm);
        m11=mmnew(1);
        m22=mmnew(2);
        m33=mmnew(3);
        m44=mmnew(4);
        m55=mmnew(5);
        m66=mmnew(6);
        m77=mmnew(7);
        mm=[m11 m22 m33 m44 m55 m66 m77]; % definimos el vector
        
    end
    
    Dkpnew=[n11./mm n22./mm n33./mm]; % nuevo desarrollo
    Dknew=sort(Dkpnew);               % ordeno el nuevo desarrollo
    Normnew=sqrt(sum((Dknew-Dkopt).^2)); % nueva norma
    
    normas(i)=Normnew;
    if Normnew < bici.normr % comparo con la norma anterior y retengo la mejor
       Dk=Dknew;
       normr=Normnew;
       n=nn;
       m=mm;
       platos=n;
       pinones=m;
       bici=struct('platos',n,'pinones',m,'desarrollos',Dk,'normr',normr);
       normas(i)=normr;
    else
       normas(i)=normr;
    end
    
    
    
    
end
plot(1:i,normas,'-') 
hold on
norma=bici.normr
hold off
title('Evolución de la norma')
ylabel('normr')
xlabel('iteraciones')
shg;
tiempo=toc;
% La estructura bici nos da los datos del mejor conjunto obtenido
