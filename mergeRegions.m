%mergeRegions:recorre y chequea si una region se deberia fusionar con una vecina

function regions=mergeRegions(regionNumber, regions, image1, nu)
  if(sum(sum(regions==regionNumber))>0)
    dim=size(image1);
    regionAdded=1;
    
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
            if((x>1)&& (regions(x-1,y)~=regionNumber)&&(sum(alreadyTried==regions(x-1,y))==0))
              regionNum2=regions(x-1,y);
              [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
              if(dE<0)
                alreadyTried=[];
                regionAdded=1;
              else
                alreadyTried=[alreadyTried,regionNum2];
              end
            end
            if((x<dim(1)) && (regions(x+1,y)~=regionNumber)&&(sum(alreadyTried==regions(x+1,y))==0))
              regionNum2=regions(x+1,y);
              [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
              if(dE<0)
                alreadyTried=[];
                regionAdded=1;
              else
                alreadyTried=[alreadyTried,regionNum2];
              end
            end
            if((y>1) && (regions(x,y-1)~=regionNumber)&&(sum(alreadyTried==regions(x,y-1))==0))
              regionNum2=regions(x,y-1);
              [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
              if(dE<0)
                alreadyTried=[];
                regionAdded=1;
              else
                alreadyTried=[alreadyTried,regionNum2];
              end
            end
            if((y<dim(2)) && (regions(x,y+1)~=regionNumber)&&(sum(alreadyTried==regions(x,y+1))==0))
              regionNum2=regions(x,y+1);
              [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
              if(dE<0)
                alreadyTried=[];
                regionAdded=1;
              else
                alreadyTried=[alreadyTried,regionNum2];
              end
            end
          end
        end
      end
    end
  end
end

