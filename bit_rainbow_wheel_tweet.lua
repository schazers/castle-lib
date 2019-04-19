require 'bits'
N,X,Y=17,9,9
j,c,z=0,5,.5
function _D()
  BG(3)
  for i=0,N do H(i,5,13,(i+j)%7+5) end
  B(15,14,c)
  if z<0.04 then A(6,6,13,13) end
end
function _U(dt)
  if T(1)>z then j=j-1 RT(1) end
  if s==1 then
    if c==G(13,14) then c=RC()%7+5 z=z*.8 else z=z*1.3 end
  end
end