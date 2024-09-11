function [BW,maskedRGBImage] = createYellowMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 18-Oct-2023
%------------------------------------------------------

%% Casa Barcelos

% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.129;
channel1Max = 0.191;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.386;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.208;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end

%% Casa Povoa
% % Convert RGB image to chosen color space
% I = rgb2hsv(RGB);
% 
% % Define thresholds for channel 1 based on histogram settings
% channel1Min = 0.073;
% channel1Max = 0.224;
% 
% % Define thresholds for channel 2 based on histogram settings
% channel2Min = 0.202;
% channel2Max = 1.000;
% 
% % Define thresholds for channel 3 based on histogram settings
% channel3Min = 0.000;
% channel3Max = 1.000;
% 
% % Create mask based on chosen histogram thresholds
% sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%     (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%     (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
% BW = sliderBW;
% 
% % Initialize output masked image based on input image.
% maskedRGBImage = RGB;
% 
% % Set background pixels where BW is false to zero.
% maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
% 
% end

%% Imagens todas juntas
% % Convert RGB image to chosen color space
% I = rgb2hsv(RGB);
% 
% % Define thresholds for channel 1 based on histogram settings
% channel1Min = 0.095;
% channel1Max = 0.209;
% 
% % Define thresholds for channel 2 based on histogram settings
% channel2Min = 0.584;
% channel2Max = 1.000;
% 
% % Define thresholds for channel 3 based on histogram settings
% channel3Min = 0.652;
% channel3Max = 1.000;
% 
% % Create mask based on chosen histogram thresholds
% sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%     (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%     (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
% BW = sliderBW;
% 
% % Initialize output masked image based on input image.
% maskedRGBImage = RGB;
% 
% % Set background pixels where BW is false to zero.
% maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
% 
% end
