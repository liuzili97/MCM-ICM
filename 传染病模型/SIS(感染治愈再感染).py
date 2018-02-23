# -*- coding: utf-8 -*-

import scipy.integrate as spi
import numpy as np
import pylab as pl

beta=1.4247
gamma=0.14286
I0=1e-6
ND=70
TS=1.0
INPUT = (1.0-I0, I0)

def diff_eqs(INP,t):
    '''The main set of equations'''
    Y=np.zeros((2))
    V = INP
    Y[0] = - beta * V[0] * V[1] + gamma * V[1]
    Y[1] = beta * V[0] * V[1] - gamma * V[1]
    return Y   # For odeint

t_start = 0.0; t_end = ND; t_inc = TS
t_range = np.arange(t_start, t_end+t_inc, t_inc)
RES = spi.odeint(diff_eqs,INPUT,t_range)

print(RES)

#Ploting
pl.plot(RES[:,0], '-bs', label='Susceptibles', linewidth=1, markersize=3)
pl.plot(RES[:,1], '-ro', label='Infectious', linewidth=1, markersize=3)
pl.legend(loc=0)
pl.title('SIS epidemic without births or deaths')
pl.xlabel('Time')
pl.ylabel('Susceptibles and Infectious')
pl.savefig('2.5-SIS-high.png', dpi=900) # This does increase the resolution.
pl.show()
