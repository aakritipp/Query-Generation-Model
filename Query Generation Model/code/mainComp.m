delete *.asv; clear all; clear syms; close all; clc;pause(0.001)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
if find(~exist('vars.mat','file'))
    gen_var
end

load vars.mat

snkLoc      = loc_sink(nodLocX,nodLocY);
snkLocX     = snkLoc(1);
snkLocY     = snkLoc(2);
tncl        = max(clstrIdx);
hedIdx      = findHeadall(clstrIdx,nodEnergy,nodIdx);
% 
% dstrb = 
figure(1);a = axes;
scatter(nodLocX,nodLocY,10,'y');set(a,'Color','k')
% saveas(dstrb,'dstrb.png')

% clstrFig = 
figure(2);a = axes;
scatter(nodLocX,nodLocY,10,clstrIdx,'y');set(a,'Color','k')
hold all;
scatter(nodLocX(hedIdx),nodLocY(hedIdx),100,'b','LineWidth',3)
scatter(snkLocX,snkLocY,300,'w');scatter(snkLocX,snkLocY,100,'w');scatter(snkLocX,snkLocY,10,'w')
text(snkLocX,snkLocY,'Sink','color','r')

hedLoc      = [nodLocX(hedIdx),nodLocY(hedIdx)];
display('clusterring')
for i = 1:tncl
    x           = nodLocX(clstrIdx==i);
    y           = nodLocY(clstrIdx==i);
    dt          = DelaunayTri(x,y);
    k           = convexHull(dt);
    plot(x(k), y(k),'y');
    text(hedLoc(i,1),hedLoc(i,2),num2str(i),'color','w','LineWidth',2)
    
end
hold off;
% saveas(clstrFig,'clstrFig.fig')
pause(0.02)

clear a dstrb dt i k x y


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


enrgyTh1    = 0.7*sum(nodEnergy)/length(nodEnergy);
enrgyDead   = 0.1*max(nodEnergy);
enrgyMat    = nodEnergy;
disp('now running')


nextRun     = true;
changeCount = 0;
cycle       = 0;
while nextRun
    
    cycle = cycle+1;
    
    sorcIdx             = hedIdx(randi([1,length(hedIdx)]));
    hop                 = sendRcv2(sorcIdx,hedIdx,hedLoc,snkLoc,cvrg);
    
    hopLog(:,cycle)     = hop(:,1);
    
    enrgyMat            = enrgyCalc2(enrgyMat,hop,clstrIdx);
    nodEnrgy            = enrgyMat(:,end);
    
    hoptmp              = hop(hop(:,1)~=0,:);
    enrgyIntrst         = nodEnrgy(hoptmp(:,1));
    minEnrgy            = min(enrgyIntrst);
    
    if minEnrgy <= enrgyDead 
        nextRun = false;
    end
    if rem(cycle,50)==0
%         enrgyLastFig = 
        figure(3);clf%;b = axes;set(b,'Color','k');pause(0.01)
        plot(1:length(nodEnrgy),nodEnrgy,'k');pause(0.001)
    end
end
axis([0,length(nodEnrgy),0,max(nodEnrgy)]);
xlabel('Serial no of node');ylabel('Energy in jouls')
title('without changing cluster head')
grid on;
maxUsdNod   = find(nodEnrgy==min(nodEnrgy));
maxUsdNod   = maxUsdNod(1);
% saveas(dstrb,'finalNodeEnergy.png')


% enrgyMaxNodFig = 
figure(4);% a = axes; set(a,'Color','k');pause(0.01)
plot(1:length(enrgyMat(maxUsdNod,:)),enrgyMat(maxUsdNod,:),'k');
axis([0,length(enrgyMat(maxUsdNod,:)),0,2])
xlabel('No. of Queries Passed');ylabel('Energy in jouls')
title(['Energy of node number' ,num2str(maxUsdNod), ' in Jouls'])
grid on;
hopex = true;
while hopex
    if sum(hopLog(end,:))>0
        hopex = false;
    else
        hopLog(end,:) = [];
    end
end

display(['total cycles to run are ', num2str(cycle)])
enrgyMatCom     = nodEnergy;

for count = 1:cycle
    
    sorcIdx             = hedIdx(randi([1,length(hedIdx)]));
    hop                 = sendRcv2(sorcIdx,hedIdx,hedLoc,snkLoc,cvrg);
    
    hopLogCom(:,cycle)  = hop(:,1);
    
    enrgyMatCom         = enrgyCalc2(enrgyMatCom,hop,clstrIdx);
    nodEnrgy            = enrgyMatCom(:,end);
    
    hoptmp              = hop(hop(:,1)~=0,:);
    enrgyIntrst         = nodEnrgy(hoptmp(:,1));
    minEnrgy            = min(enrgyIntrst);
    
    if minEnrgy <= enrgyTh1
        nodIntrst           = hoptmp(enrgyIntrst==minEnrgy,1);
        
        for idx = 1:length(nodIntrst)
            hedIntrst       = nodIntrst(idx);
            clstrIntrst     = clstrIdx(hedIntrst);
            nodsClstrIntrst = nodIdx(clstrIdx==clstrIntrst);
            nodEnrgyIntrst  = nodEnrgy(nodsClstrIntrst);
            
            hedIdxIntrst    = findHead(nodsClstrIntrst,nodEnrgyIntrst);
            
            hedIdx(hedIdx==hedIntrst)=hedIdxIntrst;
            display(['At query number ',num2str(count),'  the Energy of ',...
                      'node number ', num2str(hedIntrst),' falls below the threshold ',...
                      'Hence the cluster head for cluster number ', num2str(clstrIntrst),...
                      ' is changed from node ', num2str(hedIntrst),' to node ',...
                      num2str(hedIdxIntrst),])
            changeCount = changeCount+1;
        end
    end
    
    if rem(count,50)==0
%         enrgyLastFig = 
        figure(5);clf%;b = axes;set(b,'Color','k');pause(0.01)
        plot(1:length(nodEnrgy),nodEnrgy,'k');pause(0.001)
    end
end
axis([0,length(nodEnrgy),0,max(nodEnrgy)])
xlabel('Serial no of node');ylabel('Energy in jouls')
title('Proposed method')
grid on;
maxUsdNod   = find(nodEnrgy==min(nodEnrgy));
maxUsdNod   = maxUsdNod(1);
% enrgyMaxNodFig = 
figure(6);% a = axes; set(a,'Color','k');pause(0.01)
plot(1:length(enrgyMatCom(maxUsdNod,:)),enrgyMatCom(maxUsdNod,:),'k');
axis([0,length(enrgyMatCom(maxUsdNod,:)),0,2])
xlabel('No. of Queries Passed');ylabel('Energy in jouls')
title(['Energy of node number' ,num2str(maxUsdNod), ' in Jouls'])
grid on;
hopex = true;
while hopex
    if sum(hopLogCom(end,:))>0
        hopex = false;
    else
        hopLogCom(end,:) = [];
    end
end


X   = reshape(nodLocX,sloc(1),sloc(2));
Y   = reshape(nodLocY,sloc(1),sloc(2));
Ec  = reshape(enrgyMat(:,end),sloc(1),sloc(2));
Ep  = reshape(enrgyMatCom(:,end),sloc(1),sloc(2));

figure(7)
meshc(X,Y,1.725-Ec)
axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y)),0,2])
title(['Energy usage of nodes for ',num2str(cycle),' Queries, When CH is Constant'])
xlabel('Length of Service Area (in Meters)')
ylabel('Width of Service Area (in Meters)')
zlabel('Energy (in Joules)')
grid on;
figure(8)
meshc(X,Y,1.725-Ep)
axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y)),0,2])
title(['Energy usage of nodes for ',num2str(cycle),' Queries, For Proposed Method'])
xlabel('Length of Service Area (in Meters)')
ylabel('Width of Service Area (in Meters)')
zlabel('Energy (in Joules)')
grid on;

figure(9)
meshc(X,Y,Ec)
axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y)),0,2])
title(['Energy Levels of nodes after ',num2str(cycle),' Queries, When CH is Constant'])
xlabel('Length of Service Area (in Meters)')
ylabel('Width of Service Area (in Meters)')
zlabel('Energy (in Joules)')
grid on;
figure(10)
meshc(X,Y,Ep)
axis([min(min(X)),max(max(X)),min(min(Y)),max(max(Y)),0,2])
title(['Energy Levels of nodes after ',num2str(cycle),' Queries, For Proposed Method'])
xlabel('Length of Service Area (in Meters)')
ylabel('Width of Service Area (in Meters)')
zlabel('Energy (in Joules)')
grid on;