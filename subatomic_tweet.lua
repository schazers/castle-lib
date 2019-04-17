require 'lib_tweet'
function _D()
  for i=1,512 do P(RN(0,w),RN(0,h),5) end
  for j=1,2,0.5 do for i=1,24 do CF(hw+w/4*SIN(j/2*2*T()+i),hh+w/3*COS(SIN(j/2*3*T())+i),w/32,4) end end
  CF(hw,hh,w/8+w/32*SIN(3*T()),3)
end
function _U(dt) end
