clear all
close all
clc

w = 10;
numero_corner = 1;
larghezza_finestra = 7;


I = imread('GsImage.jpg');
I = double(rgb2gray(I));
imshow(I,imref2d(size(I)),[],'InitialMagnification','fit');
hold on;


A = imfilter(I,[-1 0 1] ,'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');


Corn = HarrisAlg(I,'FilterSize',larghezza_finestra);

C = Corn.selectStrongest(numero_corner).Location;
plot(Corn.selectStrongest(numero_corner));


numeri_casuali = 20;
%m = meshgrid([-w:2:w],[-w:2:w]);
R = repmat(C,numeri_casuali,1)+[randi([-numeri_casuali/2,numeri_casuali/2],numeri_casuali,1) randi([-numeri_casuali/2 numeri_casuali/2],numeri_casuali,1)];
Px = R(:,1);
Py = R(:,2);
Py = transpose(Py);

plot(Px, Py,'r*','LineStyle','none');


idx = 0;
for i=1:size(Px,1)
        idx = idx+1;
        P(idx,:) = [Px(i) Py(i)];
        Ix(i) = A(Py(i),Px(i));
        Iy(i) = B(Py(i),Px(i));
        Dp(idx,:) = [Ix(i) Iy(i)];
end

DpT = transpose(Dp);

num = 0;
den = 0;

for i=1:size(Dp,1)
    num = num + Dp(i,:)*DpT(:,i)*P(i,:);
    den = den + Dp(i,:)*DpT(:,i);
    %q_provvisorio = num / den;
    %plot(q_provvisorio(1),q_provvisorio(2),'m*','LineStyle','none');
   
end

%quiver(P(:,1),P(:,2),Dp(:,1),Dp(:,2))

q = num / den;

plot(q(1),q(2),'b*','LineStyle','none');

