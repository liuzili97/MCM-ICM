# -*- coding: utf-8 -*-

import scipy.integrate as spi
import numpy as np
import pylab as pl

beta = 1.4247
gamma = 0.14286
TS = 1.0
ND = 70.0
S0 = 1 - 1e-6
I0 = 1e-6
INPUT = (S0, I0, 0.0)


def diff_eqs(INP, t):
    '''The main set of equations'''
    Y = np.zeros((3))
    V = INP
    Y[0] = - beta * V[0] * V[1]
    Y[1] = beta * V[0] * V[1] - gamma * V[1]
    Y[2] = gamma * V[1]
    return Y  # For odeint


t_start = 0.0;
t_end = ND;
t_inc = TS
t_range = np.arange(t_start, t_end + t_inc, t_inc)
RES = spi.odeint(diff_eqs, INPUT, t_range)

print(RES)

# Ploting
pl.plot(RES[:, 0], '-bs', label='Susceptibles', linewidth=1, markersize=3)  # I change -g to g--  # RES[:,0], '-g',
pl.plot(RES[:, 2], '-g^', label='Recovereds', linewidth=1, markersize=3)  # RES[:,2], '-k',
pl.plot(RES[:, 1], '-ro', label='Infectious', linewidth=1, markersize=3)
pl.legend(loc=0)
pl.title('SIR epidemic without births or deaths')
pl.xlabel('Time')
pl.ylabel('Susceptibles, Recovereds, and Infectious')
pl.savefig('2.1-SIR-high.png', dpi=900)  # This does, too
pl.show()