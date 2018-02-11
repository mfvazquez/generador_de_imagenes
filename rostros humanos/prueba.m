clc
clear

addpath('GPU_RED_LIB');

aprendizaje = 0.1;
Beta = 0.1;


estructura = [2 1];
red = CrearRed(estructura);

for z  = 1:1000
    red = EntrenarRed(red, aprendizaje, Beta, [0.5 0.5], -0.5);
   red = EntrenarRed(red, aprendizaje, Beta, [-0.5 -0.5], 0.5);
end

ObtenerSalida(red, [0.5 0.5], Beta)
ObtenerSalida(red, [-0.5 -0.5], Beta)
