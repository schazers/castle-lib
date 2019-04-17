require 'lib_tweet'
x,l=0,{32,45,67,110}
function _D()
  for i=1,#l do L(0,l[i]+hh,w,l[i]+hh,3) end
  for i=-w*8+x,9*w+x,w/3 do L(i,h,hw,hh-hh/6,3) end
  o=hh+31 RF(0,0,w,o) L(0,o,w,o,3)
end
function _U(dt) 
  for i=1,#l do f=l[i] l[i]=f>hh and 32 or f+f*f*.01*dt end
  x=x+LT()*w*dt-RT()*w*dt
end
