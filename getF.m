% getF:devuelve f, la aproximacion de g

function f = getF(regions, image1)
  f = zeros(size(image1));
  for r = sort(unique(regions))'
    f(regions==r) = sumG(r, regions, image1)/regionArea(r, regions);
  end
end