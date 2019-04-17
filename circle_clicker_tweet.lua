require 'lib_tweet'
c={}
function _D()
  I('pink.png',0,0,w,h)
  for i=1,#c do CF(c[i][1],c[i][2],20,4) end
end

function _U(dt)
  if RN(0,100)<0.1 then c[#c+1]={RN(0,w),RN(0,h)} end
  x,y = MP()
  if x~=nil then for i=1,#c do if PIC(x,y,c[i][1],c[i][2],20) then table.remove(c, i) end end end
end