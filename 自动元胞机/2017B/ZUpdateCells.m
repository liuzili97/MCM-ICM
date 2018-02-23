function [cellspace,tcnum]=ZUpdateCells(cellspace,tcinfo)
cellsize=size(cellspace);
x=0;
P{1}=[0,0,0];
num=0;
change=0;
%单位时间吞吐量
tcnum=0;
for y=1:cellsize(2)
    for z=1:cellsize(1)
        cell=cellspace{z,y};
        attr=cell(1);
        v=cell(2);
        if attr==2
            cell(1)=3;
            change=cell(3);
            cell(3)=0;
            cellspace{z,y}=cell;
            if (y+v)<=(cellsize(2))
                num=num+1;
                x=x+1;                
                P{x}=[z+change,y+v,v,cell(4)];
            else
                tcnum=tcnum+1;
            end
        end
        if attr==4
            cell(1)=2;
            cellspace{z,y}=cell;
        end
    end
end
if num==0
    return;
end
for i=1:length(P)
    cell=P{i};
    y=cell(1);z=cell(2);v=cell(3);t=cell(4);
    cell=cellspace{y,z};
    cell(1)=2;
    cell(2)=v;
    cell(3)=0;
    cell(4)=t;
    cellspace{y,z}=cell;
end
end