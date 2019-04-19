require 'bits'
N,X,Y=51,25,25
f={}
z=0.15
function _L() for i=1,64 do f[#f+1]={RNN(),RNN()} end end
function _D()
  B(X,Y,5)
  for i=1,#f do B(f[i][1],f[i][2],7) end
  --if G(X,Y)==7 then DIE() end
end
function _U(dt)
  if T(1)>z then
    for i=1,#f do 
      a=f[i]
      a[1]=a[1]+RN(-1,1)
      a[2]=a[2]+RN(-1,1)
    end
    z=z-.0005
    RT(1)
  end
end