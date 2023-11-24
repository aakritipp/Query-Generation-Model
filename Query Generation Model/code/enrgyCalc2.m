function enrgyMat = enrgyCalc2(enrgyMat,hop,clstrIdx)

    sorcIdx             = hop(1);
    sorcClstr           = clstrIdx(sorcIdx);
    nodIntrst           = find(clstrIdx==sorcClstr);

    hopPos              = hop(hop(:,1)~=0,1);
    hopPos(1)           = [];
    hopPos              = [hopPos;nodIntrst];
    energyConsumption   = 0.0022;
    tmpValMat           = enrgyMat(:,end);
    consumedMat         = zeros(size(tmpValMat));
    consumedMat(hopPos) = 1;
    consumedMat         = consumedMat*energyConsumption;
    tmpValMat           = tmpValMat-consumedMat;
    enrgyMat            = [enrgyMat,tmpValMat];

end