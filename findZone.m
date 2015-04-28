function z = findZone(x,y,nodes,varargin)

for i=1:length(nodes)
    d(i) = norm(nodes{i}.weight - [x;y]);
end

[~, z] = min(d);

