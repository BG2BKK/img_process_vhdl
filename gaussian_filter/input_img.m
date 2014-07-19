clc;
clear;
close all;
sample = imread('stuff.jpg');
img=sample;
figure(1);
img = rgb2gray(sample);
img = imresize(img, 0.5);%try to make it 320 * 240
%img_noise = imnoise(img,'salt & pepper',0.02);
%imwrite(img, 'OpticalFlow1_gray.jpg','jpg');
%img = img_noise;
imshow(img);
%��ͼ�����ݴ洢Ϊ8λ����������������rom.dat���rom.dat��������Ϊfpga���̵�rom����

fid = fopen('img.dat','w');
[height, width] = size(img);
for row = 1:height
    for col = 1:width   
        tmp = img(row, col); 
        tmp = uint8(tmp);
        tmp = dec2bin(tmp);
        fprintf(fid,'%08s\n', tmp);        
    end
end
fclose(fid);

fid = fopen('rom.dat','w');
[height, width] = size(img);
for row = 1:height
    for col = 1:width   
       tmp = img(row, col); 
        tmp = uint8(tmp);
        tmp = dec2bin(tmp);
        fprintf(fid,'\"%08s\", ', tmp);        
    end
end

fclose(fid);
