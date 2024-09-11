function [out] = findSignBlue_v8(bin, eq_rgb)

% %Multiplying for the original img to have the inside objects
sign = bin .* eq_rgb;
% %Converting the resulting rgb image to gray scale
signGray = rgb2gray(sign);
% %Applying a manual threshold to the gray scale image
thresholdSign = (signGray > 102/255); % = 0.4
%Defining the Structural Element(seSign) for Kernel
seSign = strel('square', 2);
%Using a 'open' to improve the quality of the image, so is easier
%manipulate and extract properties
openSign = imopen(thresholdSign,seSign);
%Using a 'close' to improve the quality of the image, so is easier
%manipulate and extract properties
oficialImage = imclose(openSign, seSign);
 figure, imshow(oficialImage );
 pause(2);

PixelLessAreaRemoval = regionprops(oficialImage, 'PixelIdxList', 'Area');
Area = cat(1, PixelLessAreaRemoval.Area);

%Obter o numero de linhas cada vector(Uma vez que o numero de linhas é o numero de objectos detetados
[lines, ~] = size(Area); 
%display do vector, depois é para remover
%disp(Area)
%Contador numero de objectos acima do nivel de ruido, 100
counter = 0;

%Percorrer de o vector Area e verificar quais os objectos uma are superior que 100 caso nao seja consideramos ruido logo ficam a preto (=0);
for i = 1:lines
    if (Area(i) < 100)
        Area(i) = 0; % Remove pixels for small objects
    end
end
%disp(Area)

%Percorrer de novo o vector Area e verificar quais os objectos diferentes ~0 e contar
for i = 1:lines
    if (Area(i) ~= 0)
        counter = counter + 1; % Conta objectos acima de uma area de 100(Ruído)
    end
end

%disp(counter);

out = counter;

end
