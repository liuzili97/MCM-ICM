function cellspace=ZGenerateCellSpace(nl,nc,tcinfo)
%nl:车道长度;nc:车道数目;
%tcinfo:随机慢化概率、元胞最大速度、随机换道概率、收费站位置、自动驾驶汽车比例
hmax=nc+2*4;
for x=1:nl %这里通过x遍历整个道路长度
    for i=1:hmax %遍历每一条道
        if (i>4)&&(i<9) %i只能取5,6,7,8,共4车道
            cellspace{i,x}=ZGenerateCell(3);
        else
            cellspace{i,x}=ZGenerateCell(1); %为1表示不是路(黑色区域)
        end
    end
end
%可在下面对元胞空间进行手动修改
for x=3:10 %这里通过x遍历车道宽的方向
    for y=(tcinfo(4)-16):(tcinfo(4)+16) %收费站长度占32个元胞
        cell=cellspace{x,y};
        cell(1)=3; %收费站部分的两边是路
        cellspace{x,y}=cell;
    end
end
for x=1:hmax; %把收费站中心的一列涂黑
    cell=cellspace{x,tcinfo(4)};
    cell(1)=1;
    cellspace{x,tcinfo(4)}=cell;
end
cell=cellspace{x,tcinfo(4)};
cell(1)=1;
for y=9:16
cellspace{3,tcinfo(4)-y}=cell;cellspace{3,tcinfo(4)+y}=cell;
cellspace{10,tcinfo(4)-y}=cell;cellspace{10,tcinfo(4)+y}=cell;    
end
end