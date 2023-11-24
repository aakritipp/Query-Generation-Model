function T = recluster (x,y,tncl)

    T   = kmeans([x,y],tncl);

end