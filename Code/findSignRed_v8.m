function [out, img] = findSignRed_v8(bin, eq_rgb)
blackMask = createBlackMask(eq_rgb);
blackMask = bwpropfilt(blackMask, 'Area', [100 + eps(100), Inf]);
% %Multiplying for the original img to have the inside objects
sign = blackMask .* bin;
%Defining the Structural Element(seSign) for Kernel
seSign = strel('square', 2);
%Using a 'open' to improve the quality of the image, so is easier
%manipulate and extract properties
openSign = imopen(sign,seSign);
%Using a 'close' to improve the quality of the image, so is easier
%manipulate and extract properties
oficialImage = imclose(openSign, seSign);
% %Binarizing the image to ensure the logial format of the image
oficialImage = imbinarize(oficialImage);
figure, imshow(oficialImage); hold on;

PixelLessAreaRemoval = regionprops(oficialImage, 'PixelIdxList', 'Area');
Area = cat(1, PixelLessAreaRemoval.Area);
%Obter o numero de linhas cada vector(Uma vez que o numero de linhas é o numero de objectos detetados
[lines, ~] = size(Area); 
%lines
%display do vector, depois é para remover
%disp(Area)
%Contador numero de objectos acima do nivel de ruido, 100
counter = 0;

%Percorrer de o vector Area e verificar quais os objectos uma are superior que 100 caso nao seja consideramos ruido logo ficam a preto (=0);
for i = 1:lines
    if (Area(i) < 200)
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
img = ismember(bwlabel(oficialImage), find(Area >= 100));
figure , imshow(img);
%disp(counter);
out = counter;
end