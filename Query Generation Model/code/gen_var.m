 function gen_var
 
    delete *.asv *.mat; clear all; clear syms; close all; clc
    
    y           =   input('Length of Ground?        :- ');
    if isempty(y)
        display('Taking default Value "250"');
        y           = 250;
    end
    x           =   input('Width of Ground?         :- ');
    if isempty(x)
        display('Taking default Value "250"');
        x           = 250;
    end
    cvrg        =   input('Coverage radius?         :- ');
    if isempty(cvrg)
        display('Taking default Value "30"');
        cvrg           = 30;
    end
        enls           = 2160e-6;
        
% % % % % % % % % % % % Not to understand code % % % % % % % % % % % % % %
% % % % % % % % % % % Not to experiment or change% % % % % % % % % % % % %

%     ttla        =   x*y;                        % Ground area of test site
    
    tncl        =   ttlClstr(x,y,cvrg);
    n           =   tncl*8;
    
    rt          =   sqrt(n/(x*y));              % randomely distributing
    xnos        =   ceil(rt*x);                 % all available nodes over
    ynos        =   ceil(rt*y);                 % the whole ground area
    locx        =   linspace(0,x,xnos);         % uniformly....and storing 
    locy        =   linspace(0,y,ynos);         % their co-ordinates in loc
    xloc        =   ones(ynos,1)*locx;          % vectors.....
    yloc        =   ones(xnos,1)*locy;
    sloc        =   size(xloc);
    xloc        =   xloc(:);
    yloc        =   yloc';yloc = yloc(:);
    locx        =   (ceil(x/(2.5*xnos))*((rand(size(xloc))))-0.5) + xloc;
    locy        =   (ceil(y/(2.5*ynos))*((rand(size(yloc))))-0.5) + yloc;
    nodLocX     =   locx-((max(locx)+min(locx))/2);
    nodLocY     =   locy-((max(locy)+min(locy))/2);
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    
    nodEnergy   =   1.725*ones(size(locx));       % Matrix Telling Energy level of each node
    nodIdx      =   1:length(nodLocX);
    nodIdx      =   nodIdx(:);
    clstrIdx    = kmeans([nodLocX,nodLocY],tncl);
    
    save vars.mat nodLocX nodLocY nodIdx nodEnergy cvrg enls sloc clstrIdx
    pause(0.2)
    clear all; close all; clc;
 end