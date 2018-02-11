function red = EntrenarRed(red, aprendizaje, Beta, entrada, resultado)
    % Entrena la red utilizando el algoritmo de Backpropagation
    
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

        incremento = aprendizaje .* (entrada_capa * error_salida); % mapa_salidas{x}'  seria la entrada de esta capa
        red{capa} = incremento + red{capa};


    end
    
end