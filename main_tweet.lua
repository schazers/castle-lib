require 'lib_tweet'
u,l=0,0
function _D()
  for i=1,1024 do P(RN(0,w),RN(0,h),{.3,.3,.3}) end
  R(0,0,hw,hh,4) R(hw,0,w,hh,3) R(0,hh,hw,h,7) R(hw,hh,w,h,8)
  a,b=l*hw,u*hh
  RF(a,b,hw+a,hh+b,5,0.5-2*tm())
end
function _U()
  x,y = MP()
  if x~=nil then rt() u=y<hh and 0 or 1 l=x<hw and 0 or 1 end
end
