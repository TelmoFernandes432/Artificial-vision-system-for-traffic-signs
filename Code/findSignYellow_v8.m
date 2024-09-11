function [out, img] = findSignYellow_v8(bin, eq_rgb)

% %Multiplying for the original img to have the inside objects
sign = bin .* eq_rgb;
% %Converting the resulting rgb image to gray scale
signGray = rgb2gray(sign);
% %Applying a manual threshold to the gray scale image
thresholdSign = (signGray > 51/255); % = 0.4 
% %Inverting the binary values of the image, this means 1's becomes 0's,
% %and 0's becomes 1's. Pixels on go off, and Pixels off go on.
negativeSign = ~thresholdSign.*(bin);
% %Binarizing the image to ensure the logial format of the image so i can
% %do some quality treatment
binSign = imbinarize(negativeSign);
%Defining the Structural Element(seSign) for Kernel
seSign = strel('square', 2);
%Using a 'open' to improve the quality of the image, cleanning residual
%pixels
openSign = imopen(binSign,seSign);
%Using a 'close' to improve the quality of the image, so is easier to
%identify the objects
oficialImage = imclose(openSign, seSign);
% figure, imshow(oficialImage);
% pause(2);


PixelLessAreaRemoval = regionprops(oficialImage, 'PixelIdxList', 'Area');
Area = cat(1, PixelLessAreaRemoval.Area);
%Obter o numero de linhas cada vector(Uma vez que o numero de linhas é o numero de objectos detetados
[lines, ~] = size(Area); 
%display do vector, depois é para remover
%disp(Area)
%Contador numero de objectos acima do nivel de ruido, 100
counter = 0;

%Percorrer de o vector Area e verificar quais os objectos uma are superiorque 100 caso nao seja consideramos ruido logo ficam a preto (=0);
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

img = ismember(bwlabel(oficialImage), find(Area >= 100));
figure , imshow(img);
%disp(counter);


out = counter;

end

