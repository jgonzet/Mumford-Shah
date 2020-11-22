%defaultRegions hace la particion maxima : cada pixel es una region
function regions=defaultRegions(dim)
  regions=zeros(dim);
  count=0;
  for x=1:dim(1)
    for y=1:dim(2)
      regions(x,y)=count;
      count=count+1;
    end
  end
end