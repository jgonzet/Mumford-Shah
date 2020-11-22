% getBorder:devuelve una matriz con los bordes de la imagen

function border=getBorder(regions)
  border=ones(size(regions));
  dim=size(regions);
  for regionNumber=sort(unique(regions))'
    for x=1:dim(1);
      for y=1:dim(2);
        if(regions(x,y)==regionNumber)
          if((x>1) && (regions(x-1,y) > regionNumber))
            border(x,y)=0;
          end
          if((x<dim(1)) && (regions(x+1,y) > regionNumber))
            border(x,y)=0;
          end
          if((y>1) && (regions(x,y-1) > regionNumber))
            border(x,y)=0;
          end
          if((y<dim(2)) && (regions(x,y+1) > regionNumber))
            border(x,y)=0;
          end
        end
      end
    end
  end
end