clc
clear

addpath('GPU_RED_LIB');

if exist('datos totales caras.mat','file')
    disp('cargando datos guardados');
    load('datos totales caras.mat');
else
    carpeta_imagenes = 'imagenes_caras';
    imagenes = ArchivosDeCarpeta(carpeta_imagenes, '*.jpg');

    aprendizaje = 0.1;
    Beta = 0.1;

    respuesta_afirmativa = 0.5;
    respuesta_negativa = -0.5;

    largo_entrada = 100;
    entradas_generador = (rand(length(imagenes),largo_entrada)-0.5);

    entradas_discriminador = cell(1,length(imagenes));

    for x = 1:length(imagenes)
        imagen = fullfile(carpeta_imagenes,imagenes{x});
        imagen = imread(imagen);
        imagen = imagen(:,:,1);
        [alto, largo] = size(imagen);
        resultado = (double(imagen(:))/255 - 0.5);
        resultado = gpuArray(resultado);
        entradas_discriminador{x} = resultado';
    end

    resolucion = alto*largo;

    estructura = [largo_entrada  1000 resolucion];
    generador = CrearRed(estructura);
  
    if exist('discriminador caras.mat','file')
        disp('cargando discriminador');
        discriminador = load('discriminador.mat');
        discriminador = discriminador.red;
    else    
        estructura = estructura(end:-1:1);
        estructura(end) = 1;
        discriminador = CrearRed(estructura);
    end
    
    n = 0;
end


for z = 1:100
    z

    for y = randperm(length(entradas_discriminador))

        salida_generador = ObtenerSalida(generador, entradas_generador(y,:), Beta);
        discriminador = EntrenarRed(discriminador, aprendizaje, Beta, entradas_discriminador{y}, respuesta_afirmativa);
        discriminador = EntrenarRed(discriminador, aprendizaje, Beta, salida_generador, respuesta_negativa);
        
        veredicto_sintetico = ObtenerSalida(discriminador, salida_generador, Beta)
        veredicto_reales = ObtenerSalida(discriminador, entradas_discriminador{y}, Beta)

    end
end

save('datos totales');

while true
    
%     for x = 1:10
%         disp('entrenando discriminador')
        for y = randperm(length(entradas_discriminador))
            
            salida_generador = ObtenerSalida(generador, entradas_generador(y,:), Beta);
            discriminador = EntrenarRed(discriminador, aprendizaje, Beta, entradas_discriminador{y}, respuesta_afirmativa);
            discriminador = EntrenarRed(discriminador, aprendizaje, Beta, salida_generador, respuesta_negativa);

        end

%         disp('entrenando generador')
        for y = randperm(size(entradas_generador,1))
            
            salida_generador = ObtenerSalida(generador, entradas_generador(y,:), Beta);
            error_entrada = ObtenerErrorEnEntrada(discriminador, Beta, salida_generador, respuesta_afirmativa);
            generador = PropagarError(generador, aprendizaje, Beta, entradas_generador(y,:), error_entrada);


        end

%     end
    
    n = n + 1
    
    salida = ObtenerSalida(generador, entradas_generador(y,:), Beta);
    veredicto_sintetico = ObtenerSalida(discriminador, salida, Beta);
    imagen = reshape(uint8((salida + 0.5)*255), [alto, largo]);
    imwrite(gather(imagen),fullfile('resultados_caras',[num2str(n) '_' num2str(veredicto_sintetico) '.jpg']))

    save('datos totales caras');
    


end


% for y = randperm(size(entradas_generador,1))
%     salida = ObtenerSalida(generador, entradas_generador(y,:), Beta);
%     veredicto_sintetico = ObtenerSalida(discriminador, salida, Beta)
%     veredicto_reales = ObtenerSalida(discriminador, entradas_discriminador{y}, Beta)
%     imagen = reshape(uint8((salida + 0.5)*255), [alto, largo]);
%     figure(1);
%     imshow(imagen)
%     
% end

