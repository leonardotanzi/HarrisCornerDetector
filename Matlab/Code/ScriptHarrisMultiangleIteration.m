clear all
close all
clc

w = 10;
numero_corner = 1;
larghezza_finestra = 7;
numero_iterazioni = 2;

I = imread('/Users/leonardotanzi/Desktop/Fratture Computer Vision/Jpeg Notevoli/bone 2.jpg');
%I = imread('doppio angolo.jpg');
%I = imread('stella.jpg');
%I = imread('scacchi.jpg');
%I = imread('Cubi.jpg');
I = double(rgb2gray(I));
imshow(I,imref2d(size(I)),[],'InitialMagnification','fit');
hold on;


A = imfilter(I,[-1 0 1] ,'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');


Corn = HarrisAlg(I,'FilterSize',larghezza_finestra); 


C = Corn.selectStrongest(numero_corner).Location;
plot(Corn.selectStrongest(numero_corner));

for u=1:numero_iterazioni

    for k=1:numero_corner
        
        m = meshgrid([-w:1:w],[-w:1:w]); %costruisce quadrato di larghezza 2w con spazio fra i punti pari a 1
        Px = repmat(C(k,1),size(m,1),size(m,1))+m; %repmat(C(1),size(m,1),size(m,1)) crea matrice size(m,1) x size(m,1) tutta composta da C(1)(che ? 172) poi sommandoci m si trova Px
        Py = repmat(C(k,2),size(m,1),size(m,1))+m;
        Py = transpose(Py);
        
        plot(Px,Py,'r*','LineStyle','none');
        
        idx = 0;
        for i=1:size(Px,1)
            for j=1:size(Px,1)
                idx = idx+1;
                P(idx,:) = [Px(i,j) Py(i,j)]; %coordinate di tutti i punti considerati
                Ix(i,j) = A(Py(i,j),Px(i,j)); %valori dopo la convoluzione nei punti considerati
                Iy(i,j) = B(Py(i,j),Px(i,j));
                Dp(idx,:) = [Ix(i,j) Iy(i,j)]; %gradienti, cio? coppia Ix e Iy
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
        
        if(u~=numero_iterazioni)
            plot(q(1),q(2),'b*','LineStyle','none');
        else
            plot(q(1),q(2),'m*','LineStyle','none');
        end
        
        
        
        CornWint = HarrisAlgWInterpolation(I,'FilterSize',larghezza_finestra);
        
        Cwint = CornWint.selectStrongest(numero_corner).Location;
        plot(Cwint(:,1),Cwint(:,2),'r+');
        
        C(k,1) = round(q(1));
        C(k,2) = round(q(2));
        
        plot(C(:,1),C(:,2),'w+');
        
        k = k+1;
        
        
        
    end
end
