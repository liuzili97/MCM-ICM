function cellspace=ZAddingNewCarsToEntry(cellspace,x,y,fp,tcinfo)
if rand()<fp
    cell=ZGenerateCell(4);
    if rand()<tcinfo(5)
        cell(4)=1;
    end
    cellspace{x,y}=cell;
end
end