require 'lib_tweet'
function _D()
  RF(0,0,w,h,2)
  for i=1,20 do
    R(5*COS(T()*4)+i*w/50,
    5*SIN(T()*4+i)+i*h/50,
    5*-COS(T()*2.5)+w-i*w/50,
    5*SIN(T()*4+i)+ h-i*h/50,3)
  end
  o=w/16
  za=SIN(T())
  A(5*COS(TAN((3*T()*4)))+hw-o,
  5*TAN(za*T()*4)+hh-o,
  5*-TAN(za*4)+hw+o,
  5*SIN(TAN(T())*T()*4)+hh+o)
end