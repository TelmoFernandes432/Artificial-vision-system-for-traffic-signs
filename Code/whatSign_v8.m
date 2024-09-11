function [signName] = whatSign_v8(filledredIdx, img)

properties = regionprops(filledredIdx,'Centroid', 'Circularity', 'MajorAxisLength','MinorAxisLength', 'BoundingBox', 'Area');
signBoundingBox =  cat(1, properties.BoundingBox);
signCentroid =  cat(1, properties.Centroid);

signObjects = filledredIdx .* img;
rightSideObjects = signObjects( signBoundingBox(2) : signBoundingBox(2) + signBoundingBox(4) , signCentroid(1) : signBoundingBox(1) + signBoundingBox(3) );
filledObjects = imfill(rightSideObjects, 'holes');
figure,imshow(filledObjects);

%Indexing connected components
CCObjects = bwconncomp(filledObjects);
%Extracting information of the connected components
objectsInfo = regionprops(CCObjects, 'PixelIdxList','Area');
%Finding the major area and save it with her idx anexed
[objectsArea, idx1] = max([objectsInfo.Area]);
%Creating a new image with the same size as the old 1
objectsIdx = zeros(size(filledObjects,1),size(filledObjects,2));
%Turn on the pixels of the object that we want
objectsIdx(CCObjects.PixelIdxList{idx1}) = 1;
% figure, imshow(objectsIdx);
% disp(objectsArea);

binObject = imbinarize(objectsIdx);
seImg = strel('disk', 3);
closeImg = imclose(binObject, seImg);
openImg = imopen(closeImg, seImg);
figure, imshow(openImg);
hold on;
propsRightObjects = regionprops(openImg, 'Circularity');

circRightObjects = cat(1, propsRightObjects.Circularity);

%Comparação
if circRightObjects > 0.8
    signName = '50Km';
else
    signName = 'ProibidoVirarADireita';
end
% circRightObjects
% signName

end

