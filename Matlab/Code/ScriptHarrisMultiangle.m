clear all
close all
clc

w = 10;
numero_corner = 4;
larghezza_finestra = 7;

%I = imread('GsImage copia 2.jpg');
%I = imread('doppio angolo.jpg');
%I = imread('stella.jpg');
%I = imread('scacchi.jpg');
%I = imread('Cubi.jpg');
%I = imread('bahaus.jpg');
I = imread('dentro bianco.png');


I = double(rgb2gray(I));
imshow(I,imref2d(size(I)),[],'InitialMagnification','fit');
hold on;


A = imfilter(I,[-1 0 1] ,'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');


Corn = HarrisAlg(I,'FilterSize',larghezza_finestra); 


C = Corn.selectStrongest(numero_corner).Location;
plot(Corn.selectStrongest(numero_corner));

for k=1:numero_corner

    m = meshgrid([-w:1:w],[-w:1:w]); %costruisce quadrato di larghezza 2w con spazio fra i punti pari a 1
    Px = repmat(C(k,1),size(m,1),size(m,1))+m; %repmat(C(1),size(m,1),size(m,1)) crea matrice size(m,1) x size(m,1) tutta composta da C(1)(che è 172) poi sommandoci m si trova Px
    Py = repmat(C(k,2),size(m,1),size(m,1))+m;
    Py = transpose(Py);

    %plot(Px,Py,'r*','LineStyle','none');

    idx = 0;
    for i=1:size(Px,1)
        for j=1:size(Px,1)
            idx = idx+1;
            P(idx,:) = [Px(i,j) Py(i,j)]; %coordinate di tutti i punti considerati
            Ix(i,j) = A(Py(i,j),Px(i,j)); %valori dopo la convoluzione nei punti considerati
            Iy(i,j) = B(Py(i,j),Px(i,j)); 
            Dp(idx,:) = [Ix(i,j) Iy(i,j)]; %gradienti, cioè coppia Ix e Iy
        end
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

    CornWint = HarrisAlgWInterpolation(I,'FilterSize',larghezza_finestra);
    
    Cwint = CornWint.selectStrongest(numero_corner).Location;
    plot(Cwint(:,1),Cwint(:,2),'r+');
    
    k = k+1;
end