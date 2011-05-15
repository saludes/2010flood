from numpy import *
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

#http://en.wikipedia.org/wiki/Rayleigh_distribution
ray = lambda x,sigma=1: x/sigma**2*exp(-x**2/(2*sigma**2))

dt = 1.
s = tm = 10.
t = linspace(0,100,dt)
q = ray(t,s)
v = cumsum(q)
tqv = array([t,q,v])
print tqv.shape
d1 = tqv[t<tm]
d2 = tqv[t>=tm]
vq1 = lambda q: interp1(d1[:,1],d1[:,2], q)
vq2 = lambda q: interp1(d2[:,1],d2[:,2], q)