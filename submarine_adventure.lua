require 'bits'
TS,N,X,Y,c,p,e,F=1,17,2,9,5,.06,0,{}
function _L() 
for i=1,N do F[i]={t=3,h=10} end 
end
function _D() 
BG(GO and 11 or 7)
for i=1,N do q=F[i] V(i,q.t,q.t+q.h,GO and 3 or 6) end
A(4,Y,c)
TEXT(GO and e or "",20,420,6,1)
end
function _U(dt)
q=F[4]
if not GO and Y>q.t and Y<q.t+q.h+0.5 then
if T(1)>.395 then c=9 end
if T(1)>.51715 then c=1 e=e+1 RT(1) end
p=p-.0015*dt
if T(2)>MAX(p,.033) then
for i=1,N-1 do F[i]=F[i+1] end
F[N]={t=CL(-2,F[N-1].t+RN(-1,1),N-3),h=CEIL(5+100*p)}
RT(2)
end
else DIE() c=1 end
end