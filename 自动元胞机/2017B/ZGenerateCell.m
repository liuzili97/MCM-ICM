function cell=ZGenerateCell(num)
ex=importdata('cellinfo.txt');
%元胞类型，速度，换道标识，车辆类型
cell=[num,ex.data,0,0];
end