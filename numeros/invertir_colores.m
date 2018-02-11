carpeta_imagenes = 'imagenes';
imagenes = ArchivosDeCarpeta(carpeta_imagenes, '*.jpg');


for x = 1:length(imagenes)
    imagen = fullfile(carpeta_imagenes,imagenes{x});
    imagen = imread(imagen);
    imagen = imagen(:,:,1);
    imagen = 255 - imagen;
    
    
    imwrite( imagen,fullfile(carpeta_imagenes, ['invertida_' imagenes{x} '.jpg']) )

end

