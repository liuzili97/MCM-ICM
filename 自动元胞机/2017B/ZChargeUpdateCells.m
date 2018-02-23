function [cellspace,T,NT]=ZChargeUpdateCells(cellspace,tcinfo,T,NT)
cellsize=size(cellspace);
y=tcinfo(4)-1;
for x=1:cellsize(1)
    cell=cellspace{x,y};
    if cell(1)==2
        if NT(x)==0
            NT(x)=T(x);
            continue;
        end
        if NT(x)==1
            cell2=cellspace{x,y+2};
            if cell2(1)==3
                cell(1)=2;cell(3)=0;cell(2)=0;cellspace{x,y+2}=cell;
                cell(1)=3;cellspace{x,y}=cell;
                NT(x)=0;
            end
            continue;
        end
        NT(x)=NT(x)-1;
    end
end
end