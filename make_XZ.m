function [X,Z] = make_XZ(u,v,Y)
X=(9*u*Y)/(4*v);
Z=(12-3*u-20*v)*Y/(4*v);
end