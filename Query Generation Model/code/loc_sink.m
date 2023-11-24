function snkLoc = loc_sink(nodLocX,nodLocY)


    snkLocX     = 0;
    snkLocY     = max(nodLocY)+2;

%     li          =   randi([1,4]);
%     switch li
%         case 1
%             snkLocX        =   round(min(nodLocX));
%             snkLocY        =   randi(round([min(nodLocY),max(nodLocY)]));
% 
%         case 2
%             snkLocX        =   round(max(nodLocX));
%             snkLocY        =   randi(round([min(nodLocY),max(nodLocY)]));
% 
%         case 3
%             snkLocX        =   randi(round([min(nodLocX),max(nodLocX)]));
%             snkLocY        =   round(min(nodLocY));
% 
%         otherwise
%             snkLocX        =   randi(round([min(nodLocX),max(nodLocX)]));
%             snkLocY        =   round(max(nodLocY));

%     end
snkLoc  = [snkLocX,snkLocY];
end