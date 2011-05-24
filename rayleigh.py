from numpy import *
import sys
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

mode= 'save'
N = 100
M = 1000
s = tm = 10
a = -10
b = 100

# http://en.wikipedia.org/wiki/Rayleigh_distribution
# cumulative distribution: 1-exp(-x^2/(2*sigma**2))
ray = lambda t,sigma=1: t>0 and t/sigma**2*exp(-t**2/(2*sigma**2)) or 0.
pray = lambda t,sigma=1: t>0 and 1 - exp(-t**2/2/sigma**2) or 0.


ts = linspace(a,b,M)
qs = array([1 + 40*ray(t,tm) for t in ts])
tqs = array([ts,qs]).transpose()
qmax = max(qs)
qmin = min(qs)
tmax = ts[argmax(qs)]
print "qmax =",qmax, " at tmax =", tmax
tqs1 = tqs[ts<tmax,:]
tqs2 = tqs[ts>tmax,:]

assert all(diff(tqs1[:,1])>=0), "Not increasing"
assert all(diff(tqs2[:,1])<=0), "Not decreasing"

# Inverse interpolation to find t_{-+}(q)
undef = NaN
t1 = lambda q: interp(q, tqs1[:,1], tqs1[:,0],left=undef, right=undef)
t2 = lambda q: interp(q, tqs2[::-1,1], tqs2[::-1,0], left=undef, right=undef)

ys = linspace(0,qmax,N)[:-1]
dq = ys[1]-ys[0]
dt = t2(ys)-t1(ys)
#print dt
#assert all(dt>=0), "Negative dt"
#assert all(logical_or(isnan(diff(dt)), diff(dt)<=0)), "Non decreasing dt"
vy = cumsum(dq*dt[::-1]) # Start at the top

fg = plt.figure(1)
ax1 = fg.add_subplot(121)
ax2 = fg.add_subplot(122)
ax1.plot(ys[::-1],vy,'b-')

W = 22.
qf = interp(W,vy,ys[::-1])
print "W = ", W
print "Qf = ", qf
print "t1,t2 = ", t1(qf), t2(qf)
pq = tuple([t + 40*pray(t,tm) for t in (t1(qf),t2(qf))])
print "cumulative difference =",pq[1] - pq[0], (t2(qf) - t1(qf))*qf + W 
ax1.plot([1,qf,qf],[W,W,0],'g:')
ax2.plot(ts,qs,'b-')
ax2.plot([a,b],[qf,qf],'r:')
fcolor = 'cyan'
ax2.fill_between(ts,qs,qf,where=qs>qf,facecolor=fcolor,color=fcolor)
ax2.axis([a,b,0,5])



if mode == 'save':
	fg.savefig('cut.pdf')
else:
	plt.show()