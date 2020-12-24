clc;
clear all;


%Appendix A: Algorithm Implimentation
% Algorithm Implementation for MATH648 Project
% written by Russell Valentine
% Requirements: Octave with Octave-Forge extentions
% See: http://www.gnu.org/software/octave/
%
% This Algorithm is a region merging algorithm
% using the simplified Mumford Shah.
%
% See: G. Koepfler, C. Lopez and J. Morel. A multiscale Algorithm for
% Image Segmentation by Variational method. SIAM Journal of Numerical
% Analysis, vol 31, pp 282-299, 1994.
%

% usage: img=makeGray(image1)
8
%
% Takes a RGB color image and returns a grayscaled version since we
% are only operate on single channels in this implementation.
% Arguments:
% image1 the RGB color image a n x m x 3 array.
%
function img=makeGray(image1)
img=(0.3*image1(:,:,1)+0.59*image1(:,:,2)+0.11*image1(:,:,3));
endfunction
% usage: area=regionArea(regionNumber, regions)
%
% Returns the number of pixels a region is covering.
% Arguments:
% regionNumber The region number to calculate the area for.
% regions The matrix containing the regions
function area=regionArea(regionNumber, regions)
dim=size(regions);
area=sum(sum(regions==regionNumber));
endfunction
% usage: sG=sumG(regionNumber, regions, image1)
%
% Returns the sum of pixel values in the actual image for a
% region.
% Arguments:
% regionNumber The region to sum over.
% regions A matrix containing the regions
% image1 The actual image matrix g
%
function sG=sumG(regionNumber, regions, image1)
sG=sum(sum(image1(regions==regionNumber)));
endfunction
% usage: length1=regionBorderLength(regionNumber, regions)
%
% Returns the length of the board of a region.
% Arguments:
% regionNumber The region to find the board length
% regions A matrix containing the regions
%
function length1=regionBorderLength(regionNumber, regions)
dim=size(regions);
length1=0;
for x=1:dim(1)
for y=1:dim(2)
if(regions(x,y)==regionNumber)
if((x>1) && (regions(x-1,y) != regionNumber))
length1++;
endif
if((x<dim(1)) && (regions(x+1,y) != regionNumber))
length1++;
endif
if((y>1) && (regions(x,y-1) != regionNumber))
9
length1++;
endif
if((y<dim(2)) && (regions(x,y+1) != regionNumber))
length1++;
endif
endif
endfor
endfor
endfunction
% usage: regions=defaultRegions(dim)
%
% Returns a default region matrix which each pixel is a region.
% Arguments:
% dim The size of our image
%
function regions=defaultRegions(dim)
regions=zeros(dim);
count=0;
for x=1:dim(1)
for y=1:dim(2)
regions(x,y)=count;
count++;
endfor
endfor
endfunction
% usage: [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
% regions, regionNum1, regionNum2, image1, nu,
% region1Stuff)
%
% Returns the calculated \Delta E and updates current working region
% data to save on work for next time we calculate \Delta E.
% Arguments:
% regions A matrix with our regions
% regionNum1 Our current working region
% regionNum2 The region we are merging with to see if it improves
% \Delta E
% image1 Our image matrix g
% nu The weight \nu parameter
% region1Stuff A matrix contains the current working region data
% it should include: [area1, sumg1, f1, borderLength1]
% Inside region1Stuff:
% area1 The current area for our working region
% sumg1 The sum of values from the image for our region
% f1 sumg1/area
% borderLength1 The length of the border for our working region
%
function [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
regions, regionNum1, regionNum2, image1, nu,
region1Stuff)
area1=region1Stuff(1);
sumg1=region1Stuff(2);
f1=region1Stuff(3);
borderLength1=region1Stuff(4);
10
area2=regionArea(regionNum2, regions);
sumg2=sumG(regionNum2, regions, image1);
f2=sumg2/area2;
oldlb2=regionBorderLength(regionNum2, regions);
newRegions=regions;
newRegions(newRegions==regionNum2)=regionNum1;
newlb=regionBorderLength(regionNum1, newRegions);
L=borderLength1+oldlb2-newlb;
normfs=abs(f1-f2);
dE=((area1*area2)/(area1+area2))*normfs-nu*L;
if(dE<0)
area1=area1+area2;
sumg1=sumg1+sumg2;
f1=sumg1/area1;
borderLength1=newlb;
regions=newRegions;
endif
endfunction
% usage: regions=mergeRegions(regionNumber, regions, image1, nu)
%
% Goes through and checks to see if a given region should merge with
% any of its surrounding regions. It returns the resulting region
% matrix from any merges.
% Arguments:
% regionsNumber The given region to see if any of its adjacent
% regions should be merged with it.
% regions A regions matrix
% image1 Our image matrix g
% nu The weight parameter \nu
%
function regions=mergeRegions(regionNumber, regions, image1, nu)
if(sum(sum(regions==regionNumber)) > 0)
dim=size(image1);
%Reset already tried if a region was added
regionAdded=1;
loop=0;
area1=regionArea(regionNumber, regions);
sumg1=sumG(regionNumber, regions, image1);
f1=sumg1/area1;
borderLength1=regionBorderLength(regionNumber, regions);
while(regionAdded)
alreadyTried=[];
regionAdded=0;
for x=1:dim(1)
for y=1:dim(2)
if(regions(x,y)==regionNumber)
if((x>1) && (regions(x-1,y)!=regionNumber) &&
(sum(alreadyTried==regions(x-1,y)) == 0))
regionNum2=regions(x-1,y);
[dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
regions,regionNumber, regionNum2, image1, nu,
[area1, sumg1, f1, borderLength1]);
if(dE<0)
alreadyTried=[];
regionAdded=1;
11
else
alreadyTried=[alreadyTried,regionNum2];
endif
endif
if((x<dim(1)) && (regions(x+1,y)!=regionNumber) &&
(sum(alreadyTried==regions(x+1,y)) == 0))
regionNum2=regions(x+1,y);
[dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
regions,regionNumber, regionNum2, image1, nu,
[area1, sumg1, f1, borderLength1]);
if(dE<0)
alreadyTried=[];
regionAdded=1;
else
alreadyTried=[alreadyTried,regionNum2];
endif
endif
if((y>1) && (regions(x,y-1)!=regionNumber) &&
(sum(alreadyTried==regions(x,y-1)) == 0))
regionNum2=regions(x,y-1);
[dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
regions,regionNumber, regionNum2, image1, nu,
[area1, sumg1, f1, borderLength1]);
if(dE<0)
alreadyTried=[];
regionAdded=1;
else
alreadyTried=[alreadyTried,regionNum2];
endif
endif
if((y<dim(2)) && (regions(x,y+1)!=regionNumber) &&
(sum(alreadyTried==regions(x,y+1)) == 0))
regionNum2=regions(x,y+1);
[dE, area1, sumg1, f1, borderLength1, regions]=deltaE(
regions,regionNumber, regionNum2, image1, nu,
[area1, sumg1, f1, borderLength1]);
if(dE<0)
alreadyTried=[];
regionAdded=1;
else
alreadyTried=[alreadyTried,regionNum2];
endif
endif
endif
endfor
endfor
endwhile
endif
endfunction
% usage: regions=consolidateRegions(regions)
%
% Returns a matrix of regions in which the region numbers are
% consolidated. For example after merging has been done the
% regions will be numbered 3, 200, 450, etc. This function renames
% them 0, 1, 2, ... We do this so it is easier to use the regions
12
% matrix in the future as there will be no gap in the region numbers.
% Arguments:
% regions A regions matrix
%
function regions=consolidateRegions(regions)
ur=sort(unique(regions));
count=0;
for i=ur
if(i != count)
regions(regions==i)=count;
endif
count++;
endfor
endfunction
% usage: f=getF(regions, image1)
%
% Returns our f function which is a approximation for our image g.
% It is a matrix the same size as our image.
% Arguments:
% regions A regions matrix
% image1 The image g
function f=getF(regions, image1)
f=zeros(size(image1));
for r=sort(unique(regions));
f(regions==r)=sumG(r, regions, image1)/regionArea(r, regions);
endfor
endfunction
% usage: boarder=getBorder(regions)
%
% Returns a border matrix the same size as our image g. It is a
% matrix where 1 is where the border is and 0 is not the border.
% The border is our \Gamma.
% Arguments:
% regions A regions matrix
%
function border=getBorder(regions)
border=ones(size(regions));
dim=size(regions);
for regionNumber=sort(unique(regions));
for x=1:dim(1);
for y=1:dim(2);
if(regions(x,y)==regionNumber)
if((x>1) && (regions(x-1,y) > regionNumber))
border(x,y)=0;
endif
if((x<dim(1)) && (regions(x+1,y) > regionNumber))
border(x,y)=0;
endif
if((y>1) && (regions(x,y-1) > regionNumber))
border(x,y)=0;
endif
if((y<dim(2)) && (regions(x,y+1) > regionNumber))
border(x,y)=0;
13
endif
endif
endfor
endfor
endfor
endfunction
%usage: [image1, regions]=segmentPNG(file, nu, statusOutput)
%
% Returns the grayscale intensity n by m image g and a segmented
% region matrix. This should be the function that gets called first.
% f and \Gamma (The border) could be generated with just these two,
% the image and the regions).
% Arguments:
% file The filename of a png file to segment
% nu The weight parameter \nu
% statusOutput 0 to not display anything while working, 1 to
% display percentage complete after going through a
% region. The percentage is not accurate as the
% later regions should move much faster. Also some
% regions would have been absorbed while working on
% a previous region, but it does give you a little
% idea of how far along you are.
%
function [image1, regions]=segmentPNG(file, nu, statusOutput)

image1=imread(file);


image1=makeGray(image1);
regions=defaultRegions(size(image1));
numRegions=max(unique(regions));
for r=0:numRegions
regions=mergeRegions(r, regions, image1, nu);
if(statusOutput > 0)
printf("%d%% Complete\n", (r/numRegions)*100)
endif
endfor
if(statusOutput > 0)
printf("Consolidating Regions...\n")
endif
regions=consolidateRegions(regions);
endfunction



% Example Usage:
 nu=10;
 filename="myimage";
 more off;
 [image1, regions]=segmentPNG([filename,".png"], nu, 1);
 img=double(image1);
 f=getF(regions, image1);
 b=getBorder(regions)*255;
 saveimage([filename,"-region-",int2str(nu),".img"], regions, "img");
 pngwrite([filename,"-grayG-",int2str(nu),".png"], img,img,img,
 ones(size(img))*255);
 pngwrite([filename,"-f-",int2str(nu),".png"], f,f,f,
 ones(size(f))*255);
 pngwrite([filename,"-border-",int2str(nu),".png"], b, b, b,
 ones(size(b))*255);
%