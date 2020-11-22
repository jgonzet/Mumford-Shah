%sumG: suma los pixeles en una region
function sG=sumG(regionNumber, regions, image1)
  sG=sum(sum(image1(regions==regionNumber)));  
end