function salida = ObtenerSalida(red, entrada, Beta)
    
    salida = entrada;
    for capa = 1:length(red)
        entrada = gpuArray([salida 1]);
        salida = tanh((entrada * red{capa}).*Beta);        
    end
    
end

