imagenes = LeerImagenesIDX3('numeros.idx3', [28 28]);

for x = 1:size(imagenes,3)
    imagen_actual = imagenes(:,:,x);
    aux = imagen_actual;
    imagen_actual(:,1:14) = aux(:,15:28);
    imagen_actual(:,15:28) = aux(:,1:14);
    
    imwrite(imagen_actual,fullfile('imagenes',[num2str(x) '.jpg']))

    
end


