clc;
clear;
close all;
%读取edge_dete.dat中的内容，该内容是FPGA工程的处理结果，将读取内容转为图片，并与matlab的edge_dete计算做对比。
input_image = imread('stuff.jpg');
input_image = imresize(input_image, 0.5);
img = rgb2gray(input_image);
%img=input_image;
[height, width] = size(img);
figure(1);
imshow(img);


edge_kernel=[1 0 -1; 1 0 -1; 1 0 -1]
tic;
edge_dete = conv2(double(img), edge_kernel);
toc;
subplot(2,2,1);
%figure(5);
%edge_dete = abs(edge_dete);
imshow(uint8(edge_dete));
title('matlab edge detector');

load edge_dete.dat;
tmp=reshape(edge_dete, width, height);
img = tmp';
mask = ones(size(img));
mask1 = bitand(round(img) , mask);
mask2 = bitand(round(img /10) , mask);
mask3 = bitand(round(img /100), mask);
mask4 = bitand(round(img /1000), mask);
mask5 = bitand(round(img /10000), mask);
mask6 = bitand(round(img /100000), mask);
mask7 = bitand(round(img /1000000), mask);
mask8 = bitand(round(img /10000000) , mask);

edge_dete_img = mask1 + mask2*2 + mask3*4 + mask4*8 + mask5*16  + mask6*32 + mask7*64 + mask8*128;
subplot(2,2,2);
%figure(4);
imshow(uint8(edge_dete_img))
title('fpga edge detector');


