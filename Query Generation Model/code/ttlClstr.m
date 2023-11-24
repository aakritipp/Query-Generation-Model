function tncl =   ttlClstr(x,y,cvrg)

    horNos  = 2*x/cvrg;
    verNos  = 2*y/cvrg;
    tncl    = round(horNos*verNos);

end