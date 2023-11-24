function hop = sendRcv2(sorcIdx,hedIdx,hedLoc,snkLoc,cvrg)
crnt        = [sorcIdx,hedLoc(hedIdx==sorcIdx,:)]  ;
hed         = [hedIdx,hedLoc]  ;
tmpHed      = hed  ;
hop         = zeros(size(hed))  ;
for i = 1:size(hedIdx,1)
    hop(i,:)    = crnt  ;
    if displacement(crnt(:,2:3),snkLoc)<cvrg
        break;
    end 
    tmpHed      = tmpHed(tmpHed(:,1)~=crnt(1),:)  ;
    crntNdst    = displacement(tmpHed(:,2:3),crnt(:,2:3))  ;
    nxtNod      = tmpHed(crntNdst<cvrg,:)  ;
    snkDst      = displacement(nxtNod(:,2:3),snkLoc)  ;
    nodInt      = nxtNod(snkDst==min(snkDst),:)  ;
    crnt        = nodInt(1,:)  ;
end