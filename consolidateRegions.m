% consolidateRegions: reenumera las regiones
function regions=consolidateRegions(regions)
  ur=sort(unique(regions))';
  count=0;
  for i=ur
    if(i ~= count)
      regions(regions==i)=count;
    end
    count=count+1;
  end
end