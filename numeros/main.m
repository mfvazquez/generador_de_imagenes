clc
clear

addpath('GPU_RED_LIB');

if exist('datos totales.mat','file')
    disp('cargando datos guardados');
    load('datos totales.mat');
else   
    alto = 28;
    largo = 28;
    
    disp('leyendo imagenes');
    imagenes = LeerImagenesIDX3('numeros.idx3', [largo alto]);

    for x = 1:size(imagenes,3)
        imagen_actual = imagenes(:,:,x);
        aux = imagen_actual;
        imagen_actual(:,1:14) = aux(:,15:28);
        imagen_actual(:,15:28) = aux(:,1:14);
        imagenes(:,:,x) = imagen_actual;
    end

    aprendizaje = 0.1;
    Beta = 0.1;

    respuesta_afirmativa = 0.5;
    respuesta_negativa = -0.5;

    largo_entrada = 100;
    entradas_generador = (rand(length(imagenes),largo_entrada)-0.5);

    entradas_discriminador = cell(1,size(imagenes,3));

    for x = 1:size(imagenes,3)
        imagen = imagenes(:,:,x);
        resultado = (double(imagen(:))/255 - 0.5);
        entradas_discriminador{x} = resultado';
    end

    resolucion = alto*largo;

    estructura = [largo_entrada  400 resolucion];
    generador = CrearRed(estructura);

  
    estructura = estructura(end:-1:1);
    estructura(end) = 1;
    discriminador = CrearRed(estructura);         
    n = 0;
    discriminador_entrenado = false;
end

if ~discriminador_entrenado
    ciclos_necesarios = 0;
    continuar = true;
    while continuar
        disp('Entrenando discriminador');
        orden_discriminador = randperm(length(entradas_discriminador));
        orden_generador = randperm(length(entradas_discriminador));
        for y = 1:length(orden_discriminador)
            salida_generador = ObtenerSalida(generador, entradas_generador(orden_generador(y),:), Beta);
            discriminador = EntrenarRed(discriminador, aprendizaje, Beta, entradas_discriminador{orden_discriminador(y)}, respuesta_afirmativa);
            discriminador = EntrenarRed(discriminador, aprendizaje, Beta, salida_generador, respuesta_negativa);
        end

        disp('Evaluando discriminador');
        continuar = false;
        for y = randperm(length(entradas_discriminador))
            salida_generador = ObtenerSalida(generador, entradas_generador(y,:), Beta);
            veredicto_sintetico = ObtenerSalida(discriminador, salida_generador, Beta);
            veredicto_reales = ObtenerSalida(discriminador, entradas_discriminador{y}, Beta);

            if veredicto_sintetico > -0.4 || veredicto_reales < 0.4
                continuar = true;
            end

        end            
        ciclos_necesarios = ciclos_necesarios + 1
        save('datos totales');

    end
    discriminador_entrenado = true;
end


while true
    
    disp('entrenando discriminador')
    orden_discriminador = randperm(length(entradas_discriminador));
    orden_generador = randperm(length(entradas_discriminador));
    for y = 1:length(entradas_discriminador)

        salida_generador = ObtenerSalida(generador, entradas_generador(orden_generador(y),:), Beta);
        discriminador = EntrenarRed(discriminador, aprendizaje, Beta, entradas_discriminador{orden_discriminador(y)}, respuesta_afirmativa);
        discriminador = EntrenarRed(discriminador, aprendizaje, Beta, salida_generador, respuesta_negativa);

    end

    disp('entrenando generador')
    for y = randperm(size(entradas_generador,1))

        salida_generador = ObtenerSalida(generador, entradas_generador(y,:), Beta);
        error_entrada = ObtenerErrorEnEntrada(discriminador, Beta, salida_generador, respuesta_afirmativa);
        generador = PropagarError(generador, aprendizaje, Beta, entradas_generador(y,:), error_entrada);


    end
   
    n = n + 1;

    salida = ObtenerSalida(generador, entradas_generador(y,:), Beta);
    veredicto_sintetico = ObtenerSalida(discriminador, salida, Beta);
    imagen = reshape(uint8((salida + 0.5)*255), [alto, largo]);
    imwrite(gather(imagen),fullfile('resultados',[num2str(n) '_' num2str(veredicto_sintetico) '.jpg']))

    save('datos totales');
end

