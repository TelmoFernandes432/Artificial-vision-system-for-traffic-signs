%imaqreset
function realVideo
imaqreset;
NumberFrameDisplayPerSecond=30;% Define o frame rate
 
hFigure=figure(1);% Abre uma figura
 
% Set-up da entrada de video

try
        vid = videoinput('winvideo', 1, 'MJPG_1280x720'); % para windows
catch
   try
       vid = videoinput('macvideo', 1); % para macs.
   catch
      errordlg('No webcam available');
   end
end
 
% define os parametros para o video
set(vid,'FramesPerTrigger',1);% adquire apenas um frame
set(vid,'TriggerRepeat',Inf);% adquire em continuo
set(vid,'ReturnedColorSpace','RGB');%adquire imagem do tipo RGB
triggerconfig(vid, 'Manual');
 
% cria um timer que chama a função Processamento
TimerData=timer('TimerFcn', {@Processamento,vid},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
 
start(vid); % inicia o video 
start(TimerData); % inicia o timer 
 
%  activa a função enquanto a janela da figura estiver aberta
uiwait(hFigure);

% Apaga os objectos criados
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% apaga as variaveis do tipo persistent
clear functions;
imaqreset;


%esta função é chamada de x em x segundos, valor estabelecido quando foi
%configurado o timer
function Processamento(obj, event,vidd)
%cria variaveis do tipo persistent para evitar estar sempre a alocar
%memoria
persistent IM;
persistent HSV;
persistent H;
persistent S;
persistent V;
% persistent out1;
% persistent out2;
% persistent out3;
% persistent out;
 
trigger(vidd);%dá um trigger
IM=getdata(vidd,1,'uint8');%lê os dados da imagem
 
%processamento
seCloser = strel('square',5);
seOpener = strel('disk', 5);
i = 0;
maskYellow = 0;
maskBlue = 0;
maskRed = 0;

%% Image treatment
% %Here i convert my RGB image to HSV
HSV = rgb2hsv(IM);
imshow (IM);
% %Isolating the HUE channel
H = HSV(:,:,1);
% %Isolating the Saturation channel
S = HSV(:,:,2);
% %Isolating the Value channel
V = HSV(:,:,3);
% %'adapthisteq' basically uses a Kernel to have a better histogram from the image
eq_s = adapthisteq(S);
% %'adapthisteq' basically uses a Kernel to have a better histogram from the image
eq_v = adapthisteq(V);    
% %Concatenate all channels to have the equalized HSV image
eq_hsv = cat(3,H,eq_s,eq_v);
% %Converts the image to the original format but with better quality
eq_rgb = hsv2rgb(eq_hsv);

while i<5
    close all;
    switch i
        case 0
            %disp('case 0 Yellow')
            %Create a yellow mask
            yellowMask = createYellowMask(eq_rgb);
            %Using morphological operator
            closeYellow = imclose(yellowMask, seCloser);
            %Filling the image
            filledYellow = imfill(closeYellow, 'holes');
            subplot(4,1,1);
            imshow(yellowMask);
            subplot(4,1,2);
            imshow(filledYellow);
            %indexing connected components
            CCYellowMask = bwconncomp(filledYellow);
            %Extracting information of the connected components
            yellowMaskInfo = regionprops(CCYellowMask, 'PixelIdxList','Area');
            %Finding the major area and save it with her idx anexed
            [maxYellowArea, idx0] = max([yellowMaskInfo.Area]);
            % maxYellowArea
         
            if maxYellowArea < 100000
                %disp('Entrou no i = i + 1 Yellow')
                i = i + 1;
            else
                %Creating a new image with the same size as the old 1
                filledYellowIdx = zeros(size(filledYellow,1),size(filledYellow,2));
                %Turn on the pixels of the object that we want
                filledYellowIdx(CCYellowMask.PixelIdxList{idx0}) = 1;
                subplot(4,1,3);
                imshow(filledYellowIdx);
                subplot(4,1,4)
                imshow(IM);
                maskYellow = 1;
                i = 4;
            end

          case 1
            %disp('case 1 Blue')
            %Create a blue maskredMask
            blueMask = createBlueMask(eq_rgb);
            %Using morphological operator
            closeBlue = imclose(blueMask, seCloser);
            %Filling the image
            filledblue = imfill(closeBlue, 'holes');
            subplot(4,1,1);
            imshow(blueMask);
            subplot(4,1,2);
            imshow(filledblue);
            %Indexing connected components
            CCblueMask = bwconncomp(filledblue);
            %Extracting information of the connected components
            blueMaskInfo = regionprops(CCblueMask, 'PixelIdxList','Area');
            %Finding the major area and save it with her idx anexed
            [maxBlueArea, idx1] = max([blueMaskInfo.Area]);
            %maxBlueArea
            if maxBlueArea < 100000
                %disp('Entrou no i = i + 1 blue ')
                i = i + 1;
            else
                %Creating a new image with the same size as the old 1
                filledBlueIdx = zeros(size(filledblue,1),size(filledblue,2));
                %Turn on the pixels of the object that we want
                filledBlueIdx(CCblueMask.PixelIdxList{idx1}) = 1;
                subplot(4,1,3);
                imshow(filledBlueIdx);
                subplot(4,1,4);
                imshow(IM);
                maskBlue = 1;
                i = 4;
            end

          case 2
            %disp('case 2 Red')
            %Create a red maskredMask
            redMask = createRedMask(eq_rgb);
            %Using morphological operator
            closeRed = imclose(redMask, seCloser);
            %Filling the image
            filledred = imfill(closeRed , 'holes');
            subplot(4,1,1);
            imshow(redMask);
            subplot(4,1,2);
            imshow(filledred);
            %Indexing connected components
            CCredMask = bwconncomp(filledred);
            %Extracting information of the connected components
            redMaskInfo = regionprops(CCredMask, 'PixelIdxList','Area');
            %Finding the major area and save it with her idx anexed
            [maxRedArea, idx1] = max([redMaskInfo.Area]);


            if maxRedArea < 100000
                %disp('Entrou no i = i + 1 red ')
                i = i + 1;
            else
                %Creating a new image with the same size as the old 1
                filledredIdx = zeros(size(filledred,1),size(filledred,2));
                %Turn on the pixels of the object that we want
                filledredIdx(CCredMask.PixelIdxList{idx1}) = 1;
                subplot(4,1,3);
                imshow(filledredIdx);
                subplot(4,1,4);
                imshow(IM);
                maskRed = 1;
                i = 4;
            end 
        case 3
           disp('Nenhum objecto')
           i = 5; %reset no while loop
        case 4
            
            
            %Amarelos
             if (maskYellow==1)
                 disp('Detetei um objeto--Amarelo--')
                 shapeYellow = detectShape(filledYellowIdx);
                 %shapeYellow
                 %pause(2)
              if (shapeYellow == "Circle")
                  disp('Bad Filter Yellow');
              end
              if(shapeYellow == "Triangle")
                disp('Bad Filter Yellow');
              end
              if (shapeYellow == "Square")
                 disp('Bad Filter Yellow');
              end
              if (shapeYellow == "Rectangle")
                 [counterYellow, img] = findSignYellow_v8(filledYellowIdx ,eq_rgb);% Pode ser o de lombas ou semaforo
                 if(counterYellow == 2 )
                     disp('entra')
                     sign = whatSignRed_v8(filledYellowIdx, img);
                     disp(sign);
                 end
              end
              if (shapeYellow == "Pentagono/hexagono")
                disp('Desvio de Vias');
              end
             end
            
            %Vermelhos
            if(maskRed==1)
                disp('Detetei um objeto--Vermelho--')
                filledredIdx = imopen (filledredIdx, seOpener);
                shapeRed = detectShape(filledredIdx);
                %shapeRed
                %pause(5)
                if(shapeRed == "Circle")
                [counterRed, img]= findSignRed_v8(filledredIdx ,eq_rgb);
                if (counterRed == 1)
                     disp('Sentido Unico');
                end
                 if (counterRed == 2)
                     sign = whatSign_v8(filledredIdx, img);
                     disp(sign);
                 end
                if(counterRed == 7 )
                     disp('100km');
                end
                end
                if(shapeRed == "Triangle")
                    counterRed = findSignRed_v8(filledredIdx ,eq_rgb);%Pode ser o de Passagem
                    % de peoes, ou de derrocada
                    if(counterRed == 7 )
                        disp('Perigo de Derrocada');
                    end
                    if(counterRed == 8 )
                        disp('Passagem de Peoes');
                    end
                end
                if(shapeRed == "Square")
                    disp('Bad Filter Red');
                end
                if(shapeRed == "Rectangle")
                    disp('Bad Filter Red');
                end
                if(shapeRed == "Pentagono/hexagono")
                    disp('Bad Filter Red');
                end
            end
            
            %Azuis
            if(maskBlue==1)
                disp('Detetei um objeto--Azul--')
                shapeBlue = detectShape(filledBlueIdx);
                %shapeBlue
            if(shapeBlue == "Circle")
                counterBlue = findSignBlue_v8(filledBlueIdx ,eq_rgb);
                 if(counterBlue == 1 )
                     disp('Contornar a placa');
                 end
                 if (counterBlue == 6)
                     disp('Luzes de cruzamento (Medios)');
                 end
            end
            if(shapeBlue == "Triangle")
                disp('Bad Filter Blue');
            end
            if(shapeBlue == "Square")
                disp('Bad Filter Blue');
            end
            if(shapeBlue == "Rectangle")
                disp('Estacionamento Autorizado');
            end
            if(shapeBlue == "Pentagono/hexagono")
                disp('Bad Filter Blue');
            end
            end
            break;
            case 5
                break;
                
    end
end