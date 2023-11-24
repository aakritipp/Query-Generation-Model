function clstrhed    = findHead(nodIdx,nodEnrgy)

    nodIdx      = nodIdx(:);
    nodEnrgy    = nodEnrgy(:);
    varmat      = [nodIdx,nodEnrgy];
    varmat      = sortrows(varmat,2);
    clstrhed    = varmat(end,1);

end