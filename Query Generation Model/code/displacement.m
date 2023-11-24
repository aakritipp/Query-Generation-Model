function var = displacement(mat,pt)

    var     = sqrt((mat(:,1)-pt(1)).^2 + (mat(:,2)-pt(2)).^2       );

end