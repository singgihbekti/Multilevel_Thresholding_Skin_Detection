clc; clear; close all; warning off all;

%1. read original image
I=imread('closed today.jpg');
figure; imshow(I);

%2. RGB to YCbCr
out=  uint8(zeros(size(I,1),size(I,2),size(I,3)));

%R,G,B component of the input image
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

%inverse of the avg values of the RBG
mR = 1/(mean(mean(R)));
mG = 1/(mean(mean(G)));
mB = 1/(mean(mean(B)));

% smallest avg value
maxRGB = max(max(mR, mG), mB);

%calculate the scaling factors
mR = mR/maxRGB;
mG = mG/maxRGB;
mB = mB/maxRGB;

%scale the values
out(:,:,1)=R*mR;
out(:,:,2)=G*mG;
out(:,:,3)=B*mB;

%convert the RGB image to YCbCr
img_ycbcr=rgb2ycbcr(out);
figure, imshow(img_ycbcr);

%3. Extracting each component
Y= img_ycbcr(:,:,1);
Cb= img_ycbcr(:,:,2);
Cr= img_ycbcr(:,:,3);

figure, imshow(Y);
figure, imshow(Cb);
figure, imshow(Cr);

%4. perform multi-level tresholding
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=193);
numind=size(r,1);

bin=false(size(I,1),size(I,2));

%mark skin pixels
for i=1:numind
    bin(r(i),c(i))=1;
end

figure, imshow(bin);

%5. performing MO (filling holes to fill empty object region)
bin = imfill(bin,'holes');
figure, imshow(bin);

%6. performing MO (opening area for eliminate noise)
bin=bwareaopen(bin,9000);
figure, imshow(bin);

%7. visualize the result of the skin segmentation on RBG image
R(~bin)=0;
G(~bin)=0;
B(~bin)=0;

out=cat(3,R,G,B);
figure, imshow(out);

%8. visualize the result in the form of bounding box
s=regionprops(bin, 'BoundingBox');
bbox=cat(1, s.BoundingBox);

RGB=insertShape(I,'rectangle',bbox,'LineWidth',4);
figure, imshow(RGB);






