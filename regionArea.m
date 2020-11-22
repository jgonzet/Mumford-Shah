%regionArea: devuelve el area de una region
function area=regionArea(regionNumber, regions)
  dim=size(regions);
  area=sum(sum(regions==regionNumber));  
end