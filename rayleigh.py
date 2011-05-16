from numpy import *
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

# http://en.wikipedia.org/wiki/Rayleigh_distribution
ray = lambda t,sigma=1: t>0 and t/sigma**2*exp(-t**2/(2*sigma**2)) or 0.

dt = 1.
s = tm = 10
ts = linspace(-10,100,1000)
qs = array([1 + 40*ray(t,tm) for t in ts])
qmax = max(qs)
qmin = min(qs)
tmax = ts[argmax(qs)]
vs = cumsum(qs)
qv = array([qs,vs]).transpose()
qv1 = qv[ts<tmax]
qv2 = qv[ts>=tmax]
print "Qmax =",qmax, " at tmax =", tmax


undef = NaN

fg1 = plt.figure(1)
ax1 = fg1.add_subplot(111)
ax1.plot(ts,qs,'b-')


fg2 = plt.figure(2)
ax2 = fg2.add_subplot(111)
ax2.plot(qs,vs,'b-')
qt = linspace(qmin,qmax,100)[:-1]
assert all(diff(qv1[:,0])>=0), "Not increasing "
assert all(diff(qv2[:,0])<=0), "Not decreasing"
fv1 = lambda q: interp(q, qv1[:,0], qv1[:,1])
fv2 = lambda q: interp(q, qv2[::-1,0], qv2[::-1,1],left=undef,right=undef) # interp requires increasing

v1 = fv1(qt)
v2 = fv2(qt)
ax2.plot(qt, v2-v1, 'g-')

W = 350.
Qf = interp(W,(v2-v1)[::-1],qt[::-1],left=-undef,right=undef)
print "Qf =", Qf
ax2.plot([Qf,Qf],[0,fv2(Qf)],'r:', [Qf,Qf], [fv1(Qf),fv2(Qf)],'r-')
ax1.plot(ts,len(ts)*[Qf],'r:')
fcolor = 'cyan'
ax1.fill_between(ts,qs,Qf,where=qs>Qf,facecolor=fcolor,color=fcolor)
ax1.axis([-10,100,0,5])



fg1.savefig('qt.eps')
fg2.savefig('vq.eps')