require 'bits'
N,X,Y,W=17,9,9,2
tx,ty,px,py,x,y=9,9,9,9,9,9
function _D()
  RB(x-W,y-W,x+W,y+W,10)
  B(X,Y,4)
end
function _U(dt)
  if T(1)>0.02 then
    if tx-x<.1 and ty-y<.1 then
      px,py=tx,ty
      tx,ty=RN(3,14),RNN(3,14)
      print(tx,ty)
    else
      x=x+(tx-px)*.01
      y=y+(ty-py)*.01
    end
    RT(1)
  end
end