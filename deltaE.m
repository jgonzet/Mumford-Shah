%deltaE: calcula DeltaE en una región y actualiza sus parámetros
function [dE,area1,sumg1,f1,borderLength1,regions]=deltaE(regions,regionNum1,regionNum2,image1,nu,region1Stuff)
  area1 = region1Stuff(1);
  sumg1 = region1Stuff(2);
  f1 = region1Stuff(3);
  borderLength1 = region1Stuff(4);

  area2 = regionArea(regionNum2, regions);
  sumg2 = sumG(regionNum2, regions, image1);
  f2 = sumg2/area2;
  oldlb2 = regionBorderLength(regionNum2, regions);
  newRegions = regions;
  newRegions(newRegions==regionNum2) = regionNum1;
  newlb = regionBorderLength(regionNum1,newRegions);
  L = borderLength1+oldlb2-newlb;
  normfs = abs(f1-f2);
  dE = ((area1*area2)/(area1+area2))*normfs-nu*L;
  
  if(dE<0)
    area1=area1+area2;
    sumg1=sumg1+sumg2;
    f1=sumg1/area1;
    borderLength1=newlb;
    regions=newRegions;
  end
end