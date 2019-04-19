require 'bits'
N,X,Y=17,9,7
c=5
function _D()
  BG(9)
  for i=1,N do B(i,9 + 8*SIN(i/2+T()*2),7) end
  H(9,0,17,7)
  V(2,0,17,7)
  B(X,Y,c)
end
function _U(dt)
  if T(1)>0.4 then c=8 else c=5 end
  if T(1)>0.5168 then RT(1) end
end