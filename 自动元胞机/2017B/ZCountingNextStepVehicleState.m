function cellspace=ZCountingNextStepVehicleState(cellspace,x,y,tcinfo)
if (x>tcinfo(4)-15)&&(x<tcinfo(4))
    tcinfo(2)=1;
end
cellsize=size(cellspace);
d=y+1+tcinfo(2)*2;
for i=(y+1):cellsize(2)
    cell=cellspace{x,i};
    cellt=cell;
    if cell(1)~=3
        d=i;
        break;
    end
end
d=d-y-1;
%左右间距dl dr
dl=y+1+tcinfo(2)*2;
for i=y:cellsize(2)
    if x-1<1
        dl=0;
        break;
    end
    celll=cellspace{x-1,i};
    if celll(1)~=3
        dl=i;
        break;
    end
end
dl=max(dl-y-1,0);
dr=y+1+tcinfo(2)*2;
for i=y:cellsize(2)
    if x+1>cellsize(1)
        dr=0;
        break;
    end
    cellr=cellspace{x+1,i};
    if cellr(1)~=3
        dr=i;
        break;
    end
end
dr=max(dr-y-1,0);
%确定性加速
cell=cellspace{x,y};
cell(2)=min(cell(2)+1,tcinfo(2));
%左右后车预期距离dgl dgr
dgr=tcinfo(2);
dgrv=tcinfo(2);
for i=y-1:-1:1
    if x+1>cellsize(1)
        dgr=0;
        break;
    end
    cellr=cellspace{x+1,i};
    if cellr(1)==2
        dgr=y-i-1;
        dgrv=min(cellr(2)+1,tcinfo(2));
        break;
    end
    if y-i-1>=dgr
        break;
    end
end
dgl=tcinfo(2);
dglv=tcinfo(2);
for i=y-1:-1:1
    if x-1<1
        dgl=0;
        break;
    end
    celll=cellspace{x-1,i};
    if celll(1)==2
        dgl=y-i-1;
        dglv=min(celll(2)+1,tcinfo(2));
        break;
    end
    if y-i-1>=dgl
        break;
    end
end
%确定是否变道
if (cell(2)>=d)&&(d~=0||cellt(1)==1)
    if cellt(1)==1
        tcinfo(3)=1.1;
    end
    if (dgl-dglv>=0)&&(dl>d)
        if rand()<tcinfo(3)
            cell(3)=-1;
            cellspace{x,y}=cell;
            d=dl;
        end
    elseif (dgr-dgrv>=0)&&(dr>d)
        if rand()<tcinfo(3)
            cell(3)=1;
            cellspace{x,y}=cell;
            d=dr;
        end
    end
end
%确定性减速
cell(2)=min(cell(2),d);
%随机减速
if cell(4)==0
    if rand()<tcinfo(1)
        cell(2)=max(cell(2)-1,0);
    end
end
cellspace{x,y}=cell;
end