function mapa_de_salidas = ObtenerMapaDeSalidas(red, entrada, Beta)
    
    mapa_de_salidas = cell(1,length(red));
    salida = entrada;
    for capa = 1:length(red)
        entrada = gpuArray([salida 1]);
        salida = tanh((entrada * red{capa}).*Beta);        
        mapa_de_salidas{capa} = gpuArray(salida);
    end
    
end