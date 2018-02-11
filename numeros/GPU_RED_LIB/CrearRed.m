% red = {capa 1, capa 2}
% capa = matriz donde cada fila es un  perceptron y las columnas los pesos
%        de su entrada

function red = CrearRed(estructura)
    
    red = cell(1,length(estructura)-1);
    for i = 2:length(estructura)
        entradas = estructura(i-1)+1;

        capa = (rand(entradas, estructura(i)) - 0.5)/5;
        capa = gpuArray(capa);
        red{i-1} = capa;
    end
    
end