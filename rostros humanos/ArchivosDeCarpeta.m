function archivos = ArchivosDeCarpeta(direccion, clave)
    archivos_aux = dir(fullfile(direccion, clave));
    
    archivos = {};
    for x = 1:length(archivos_aux)
        if archivos_aux(x).name(1) == '.'
            continue
        end
        archivos = [archivos archivos_aux(x).name];
    end
    
    archivos = natsort(archivos);
    
end