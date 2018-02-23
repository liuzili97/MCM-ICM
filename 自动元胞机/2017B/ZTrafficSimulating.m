function ZTrafficSimulating(cellspace,fp,dt,nt,tcinfo)
ZDrawCells(cellspace,0,1);
cellsize=size(cellspace);
%T=[8,8,1,1,2,2,2,6,6,6,8,8];
%T=[8,8,6,6,2,1,1,2,2,6,8,8];
T=[8,8,1,1,1,1,1,1,1,1,8,8];
%T=[8,8,2,2,2,1,1,6,6,6,8,8];
%T=[8,8,6,2,2,1,1,2,2,6,8,8];
%T=[8,8,2,2,1,1,1,1,2,2,8,8];
NT=[0,0,0,0,0,0,0,0,0,0,0,0];
tcnum=0;
for x=1:dt:nt;
    for y=1:cellsize(2) %遍历cell的宽
        for z=1:cellsize(1) %遍历cell的长
            cell=cellspace{z,y};
            if cell(1)==2
                cellspace=ZCountingNextStepVehicleState(cellspace,z,y,tcinfo);
            end
            if (y==1)&&(cell(1)==3)
                cellspace=ZAddingNewCarsToEntry(cellspace,z,y,fp,tcinfo);
            end
        end
    end
    [cellspace,num]=ZUpdateCells(cellspace,tcinfo);
    tcnum=tcnum+num;
    %收费站模块
    [cellspace,T,NT]=ZChargeUpdateCells(cellspace,tcinfo,T,NT);
    ZDrawCells(cellspace,tcnum,x);
end
end