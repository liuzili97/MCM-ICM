function ZDrawCells(cellspace,tcnum,x)
cellsize=size(cellspace);
cells=zeros(cellsize);
for y=1:cellsize(2)
    for z=1:cellsize(1)
        cell=cellspace{z,y};
        attr=cell(1);
        cells(z,y)=attr;
    end
end
figure(1);
pause(1);
imshow(cells,[],'InitialMagnification','fit')
%set(gcf,'position',[241 132 1000 800]);
%set(gcf,'doublebuffer','on');
str=['Throughput:',num2str(tcnum,'%d'),'  Simulation time:',num2str(x,'%d'),'  Traffic flow:',num2str(tcnum/x,'%.1f')];
title(str,'color','b');
end
%