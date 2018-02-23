function [plaza,v]=create_plaza(B,plazalength);

plaza=zeros(plazalength,B+2);
v=zeros(plazalength,B+2); 

plaza(1:plazalength,[1,2+B])=-1; %禁用第一条和最后一条道

