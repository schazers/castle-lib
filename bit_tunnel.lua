require 'bits'
N,X,Y,c,spd,A,sc,F=17,2,9,5,.06,11,0,{}
function _L()
  for i=1,N do F[i]={h=A,c=9} end
end
function _D()
  if GO then BG(3) else BG(6) B(3,Y,c) end
  for i=1,N do
    q=F[i] 
    wall_color = GO and 11 or 7
    V(i,0,q.c-q.h/2,wall_color) -- top of this wall
    V(i,q.c+CEIL(q.h/2),N,wall_color) -- bottom of this wall
  end
  TEXT(GO and sc or "",20,420,6,1)
end
function _U(dt)
  -- DIE
  --CB()
  dw=F[3]
  if CEIL(Y)<dw.c-dw.h/2+1 or FLR(Y)>dw.c+dw.h/2 then DIE() end

  if not GO then
    -- BPM flash
    if T(1)>0.395 then c=8 else c=5 end
    if T(1)>0.51715 then sc=sc+1 RT(1) end

    -- move F
    spd=spd-.0015*dt
    A=A-0.14*dt
    if T(2)>MAX(spd,.033) then
      for i=1,N-1 do F[i].c=F[i+1].c F[i].h=F[i+1].h end
      F[N]={c=CL(3, F[N-1].c+RN(-1,1), N-3),h=CEIL(5+100*spd)}
      RT(2)
    end
  end
end