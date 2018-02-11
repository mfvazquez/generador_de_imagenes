clc
clear

addpath('GPU_RED_LIB');

carpeta_imagenes = 'imagenes';
imagenes = ArchivosDeCarpeta(carpeta_imagenes, '*.jpg');

fotos_emocion = 21;

aprendizaje = 0.1;
Beta = 0.1;

respuesta_afirmativa = 0.5;

entradas = cell(1,length(imagenes));

for x = 1:length(imagenes)
    imagen = fullfile(carpeta_imagenes,imagenes{x});
    imagen = imread(imagen);
    imagen = imagen(:,:,1);
    [alto, largo] = size(imagen);
    resultado = (double(imagen(:))/255 - 0.5);
    resultado = gpuArray(resultado);
    entradas{x} = resultado';
end

resolucion = alto*largo;



estructura = [length(respuesta_afirmativa) 100 100 1000 1000 resolucion];
estructura = estructura(end:-1:1);
red = CrearRed(estructura);

y = 1;
for z  = 1:100
    z
    for y = randperm(length(entradas))
        red = EntrenarRed(red, aprendizaje, Beta, entradas{y}, respuesta_afirmativa);
    end
end

save('discriminador', 'red');

for y = randperm(length(entradas))
    ObtenerSalida(red, entradas{y}, Beta)
end

