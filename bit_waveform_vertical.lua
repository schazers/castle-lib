require 'bits'
N,X,Y=65,9,9
j,c,z=0,5,.05
function _D()
  BG(3)
  for i=0,N do H(i,17+RN(-11,11),49+RN(-11,11),(i+j)%7+5) end
end
function _U(dt)
  if T(1)>z then j=j-1 RT(1) end
end