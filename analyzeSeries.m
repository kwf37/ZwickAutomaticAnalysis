function data = analyzeSeries(gaugelength)

%number of specimens in the file
n=0;


[filename, pathname]=uigetfile('*');
path=strcat(pathname,filename);


[status,sheets] = xlsfinfo(path);

%Find number of specimens in the file
for sheet = sheets
    
    if contains(sheet,'Specimen')
        n=n+1;
    end
    
end



data=struct();
for i=[1:n]
    temp=struct();
    
    %Parsing Excel data
    cellname=strcat('F',num2str(i+2),':F',num2str(i+2));
    temp.area=xlsread(path,2,cellname);
    temp.time=xlsread(path,3+i,'A:A');
    temp.displacement=xlsread(path,3+i,'C:C');
    temp.force=xlsread(path,3+i,'D:D');
    
    %Calculating stress and strain arrays
    temp.stress=temp.force./temp.area;
    temp.stress=temp.stress.*1000000 %converting to pascals
    temp.strain=temp.displacement./gaugelength;
    
    %Storing ultimate stress coordinates- note that ultimate strain is
    %technically very very incorrect, but was an easy to remember name. It
    %is just the strain corresponding to the ultimate stress.
    temp.ultimatestress=max(temp.stress);
    temp.ultimatestrain=temp.strain(find(temp.stress==temp.ultimatestress));
    
    %Normalizing stress and strain on graph. Considers negative force to be
    %compression, so the offset zeros the zero stress point
    temp.offset=temp.strain(find(temp.stress==min(abs(temp.stress))));
    temp.strain=temp.strain-temp.offset;
    
    %Calculating toughness using trapezoidal approximation
    temp.toughness=trapz(temp.strain,temp.stress);
    
    %Calculating Young's Modulus
    temp.curve=polyfit(temp.strain(1:find(temp.strain==temp.ultimatestrain)),temp.stress(1:find(temp.stress==temp.ultimatestress)),5)
    temp.derivative=polyder(temp.curve);
    temp.slopes=polyval(temp.derivative,
    
    %Storing in temp in data structure
    fieldname=strcat('specimen',num2str(i));
    data = setfield(data, fieldname, temp);
end

%query for more data
button = questdlg('Would you like to import another Zwick Excel file?','Yes','No');
if(strcmp(button,'Yes'))
    data=addData(gaugelength,n,data);
end