function imagenes = LeerImagenesIDX3(nombre_archivo, dimensiones)

    fID = fopen(nombre_archivo);
    archivo = fread(fID,'uint8');
    resolucion = dimensiones(1)*dimensiones(2);
    cantidad_imagenes = length(archivo)/resolucion;
    imagenes = uint8(zeros(dimensiones(1),dimensiones(2), int64(cantidad_imagenes)));
    for x = 1:cantidad_imagenes    
        vector = archivo((x-1)*resolucion + 1  : x*resolucion);
        imagen = reshape(vector, dimensiones)';
        imagenes(:,:,x) = imagen;
    end

    fclose(fID);

end




