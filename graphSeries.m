function graph=graphSeries(data)
graph=figure();
hold on;
fields=fieldnames(data);
legendArray={};
for i=[1:length(fields)]
    specimen=data.(char(fields(i)));
    %legendArray{1,2*i}=char(fields(i));
    %legendArray{1,2*i+1}=char(char(fields(i),char(' Max:'),char(specimen.ultimatestress)));
    
    subplot(1,2,1);
    hold on;
    title('Stress-Strain Curve');
    xlabel('Engineering Strain');
    ylabel('Engineering Stress [Pa]');
    legend('show');
    scatter(specimen.strain,specimen.stress,'.');
    
    %Setting origin on stress-strain plot:
    ax=gca;
    disp(max(specimen.strain));
    ax.XLim=[0,1.1*max(specimen.strain)];
    ax.YLim=[0,1.1*max(specimen.stress)];
    
    plot(specimen.ultimatestrain,specimen.ultimatestress,'O');
    
    subplot(1,2,2);
    hold on;
    title('Youngs Modulus Determination');
    xlabel('Engineering Strain');
    ylabel('Modulus');
    legend('show');
    scatter(specimen.strain,specimen.modulus,'.');
end
end