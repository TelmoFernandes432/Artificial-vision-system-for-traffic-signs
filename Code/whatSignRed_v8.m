function [signName] = whatSignRed_v8(filledredIdx, img)

properties = regionprops(filledredIdx,'Centroid', 'Circularity', 'MajorAxisLength','MinorAxisLength', 'BoundingBox', 'Area');
signBoundingBox =  cat(1, properties.BoundingBox);
signCentroid =  cat(1, properties.Centroid);

signObjects = filledredIdx .* img;

%Indexing connected components
CCObjects = bwconncomp(signObjects);
%Extracting information of the connected components
objectsInfo = regionprops(CCObjects, 'PixelIdxList','MajorAxisLength','MinorAxisLength');
maxRatio = cat(1,objectsInfo.MajorAxisLength) - cat(1,objectsInfo.MinorAxisLength);
%Finding the major area and save it with her idx anexed
[objectsRatio, idx1] = max(maxRatio);
%Creating a new image with the same size as the old 1
objectsIdx = zeros(size(filledredIdx,1),size(filledredIdx,2));
%Turn on the pixels of the object that we want
objectsIdx(CCObjects.PixelIdxList{idx1}) = 1;
% G
% disp(objectsRatio);
filledObject = imfill(objectsIdx);
% binObject = imbinarize(objectsIdx);
% seImg = strel('disk', 2);
% closeImg = imclose(binObject, seImg);
% openImg = imopen(closeImg, seImg);
% figure, imshow(objectsIdx);
% hold on;
propsObjects = regionprops(filledObject, 'MajorAxisLength','MinorAxisLength','Circularity');

Ratio = cat(1,propsObjects.MajorAxisLength) - cat(1,propsObjects.MinorAxisLength);
circObjects = cat(1, propsObjects.Circularity);

%Comparação
if (circObjects < 0.5)
    signName = 'Lomba';
else
    signName = 'Semaforo';
end
% Ratio
% circObjects
% signName

end
% rightSideObjects = signObjects( signBoundingBox(2) : signBoundingBox(2) + signBoundingBox(4) , signCentroid(1) : signBoundingBox(1) + signBoundingBox(3) );
% filledObjects = imfill(rightSideObjects, 'holes');
% figure,imshow(filledObjects);
