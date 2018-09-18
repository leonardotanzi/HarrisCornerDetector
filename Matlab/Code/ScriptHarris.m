clear all
close all
clc

I = imread('/Users/leonardotanzi/Desktop/Fratture Computer Vision/Jpeg Notevoli/bone 2.jpg');
I = double(im2bw(I));
%I = double(rgb2gray(I));
imshow(I,imref2d(size(I)),'InitialMagnification','fit');
%imshow(I,imref2d(size(I)),[]);
hold on;

C = HarrisAlg(I,'FilterSize',5);

C.Location;
C.selectStrongest(3);
plot(C.selectStrongest(3));


figure;

I2 = imread('/Users/leonardotanzi/Desktop/Fratture Computer Vision/Jpeg Notevoli/bone 2.jpg');
I2 = double(im2bw(I2));
%I = double(rgb2gray(I));
imshow(I2,imref2d(size(I2)),'InitialMagnification','fit');
%imshow(I,imref2d(size(I)),[]);
hold on;

C2 = HarrisAlg(I2,'FilterSize',3);

C2.Location;
C2.selectStrongest(1);
plot(C2.selectStrongest(1));



% CON FILTER SIZE = 3 E K=0,197 FUNZIONA PERFETTO

