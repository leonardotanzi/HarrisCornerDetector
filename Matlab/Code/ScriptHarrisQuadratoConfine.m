clear all
close all
clc

w = 10;

I = imread('GsImage.jpg');
I = double(rgb2gray(I));
imshow(I,imref2d(size(I)),[],'InitialMagnification','fit');
hold on;


A = imfilter(I,[-1 0 1] ,'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');


Corn = HarrisAlg(I,'FilterSize',31);

C = Corn.selectStrongest(1).Location;
plot(Corn.selectStrongest(1));



m = meshgrid([-w:2:w],[-w:2:w]);
Px = repmat(C(1),size(m,1),size(m,1))+m;
Py = repmat(C(2),size(m,1),size(m,1))+m;
Py = transpose(Py);

for i=2:size(Px,1)-1
    for j=2:size(Px,1)-1
        Px(i,j) = 0;
        Py(i,j) = 0;
    end
end

plot(Px,Py,'r*','LineStyle','none');

idx = 0;
for i=1:size(Px,1)
    for j=1:size(Px,1)
        if(Px(i,j) ~= 0)
            idx = idx+1;
            P(idx,:) = [Px(i,j) Py(i,j)];
            Ix(i,j) = A(Py(i,j),Px(i,j));
            Iy(i,j) = B(Py(i,j),Px(i,j));
            Dp(idx,:) = [Ix(i,j) Iy(i,j)];
        end
    end
end

DpT = transpose(Dp);

num = 0;
den = 0;

for i=1:size(Dp,1)
    num = num + Dp(i,:)*DpT(:,i)*P(i,:);
    den = den + Dp(i,:)*DpT(:,i);
end

quiver(P(:,1),P(:,2),Dp(:,1),Dp(:,2))

q = num / den;

plot(q(1),q(2),'b*','LineStyle','none');

