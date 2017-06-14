function data = addData(gaugelength,startindex,olddata)

%number of specimens in the file
n=0;


[filename, pathname]=uigetfile('*');
path=strcat(pathname,filename);


[status,sheets] = xlsfinfo(path);

%Find number of specimens in the file
for sheet = sheets
    
    if contains(sheet,'Specimen')
        disp(sheet)
        n=n+1;
        disp(n);
    end
    
end



data=olddata;
for i=[1:n]
    temp=struct();
    
    cellname=strcat('F',num2str(i+2),':F',num2str(i+2));
    temp.area=xlsread(path,2,cellname);
    
    temp.time=xlsread(path,3+i,'A:A');
    temp.displacement=xlsread(path,3+i,'C:C');
    temp.force=xlsread(path,3+i,'D:D');
    temp.stress=temp.force./temp.area;
    temp.strain=temp.displacement./gaugelength;
    temp.modulus=getSlope(temp.strain,temp.stress);
    
    temp.ultimatestress=max(temp.stress);
    temp.ultimatestrain=temp.strain(find(temp.stress==temp.ultimatestress));
    
    temp.offset=min(abs(temp.stress));
    temp.strain=temp.strain-temp.offset;
    
    fieldname=strcat('specimen',num2str(i+startindex));
    data = setfield(data, fieldname, temp);
end
%query for more data
button = questdlg('Would you like to import another Zwick Excel file?','Yes','No');
if(strcmp(button,'Yes'))
    data=addData(gaugelength,n+startindex,data);
end