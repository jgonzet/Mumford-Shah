clear all, close all, more off, clc;

nu=3;
image1 = rgb2gray(imread('test1.jpg')); %Si es .jpg hay que pasar a gris
%image1 = imread('test1.png');
dim = size(image1);
regions = defaultRegions(dim);
numRegions = max(unique(regions));

for r=0:numRegions       
    regions=mergeRegions(r, regions, image1, nu);
end

%regions=consolidateRegions(regions); % no se usa esta función

img=double(image1);
f=getF(regions, image1);
b=getBorder(regions)*255;
imwrite(b,'salida.png','png');






