function hedIdx    = findHeadall(clstrIdx,nodEnrgy,nodIdx)

    minval              = min(clstrIdx);
    maxval              = max(clstrIdx);
    
    valIdx              = minval:maxval;
    
    valIdx(valIdx==0)   =[];
    valIdx              = sort(valIdx)';
    hedIdx              = zeros(size(valIdx));
    for i = 1:length(valIdx)
        clstrNodEnrgy   = nodEnrgy(clstrIdx == i);
        clstrNodIdx     = nodIdx(clstrIdx == i);
        varmat          = sortrows([clstrNodIdx,clstrNodEnrgy],2);
        hedIdx(i)       = varmat(end,1);
    end
end