function error_entrada = ObtenerErrorEnEntrada(red, Beta, entrada, resultado)
    % Obtiene el error en la entrada de la red utilizando el algoritmo de Backpropagation
    
    mapa_salidas = ObtenerMapaDeSalidas(red, entrada, Beta);
    error_salida = (resultado-mapa_salidas{end}) .* Beta .* (1 - (mapa_salidas{end}).^2);
    
    for capa = length(red):-1:1
               
        if capa < length(red)
            error_salida = error_entrada; % ahora el error en la salida es el error en la entrada
        end
        
        if capa == 1
            entrada_capa = gpuArray([entrada 1]');
        else 
            entrada_capa= gpuArray([mapa_salidas{capa-1} 1]');
        end
                
        error_entrada = (error_salida * red{capa}(1:end-1,:)') .* Beta .* (1 - (entrada_capa(1:end-1)').^2);

    end
    
end