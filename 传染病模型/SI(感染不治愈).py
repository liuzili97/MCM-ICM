# -*- coding: utf-8 -*-

import numpy as np
import pylab as pl
import scipy.integrate as spi

beta = 1.4247
"""the likelihood that the disease will be transmitted from an infected to a susceptible
individual in a unit time is β"""
gamma = 0
# gamma is the recovery rate and in SI model, gamma equals zero
I0 = 1e-6
# I0 is the initial fraction of infected individuals
ND = 70
# ND is the total time step
TS = 1.0
INPUT = (1.0 - I0, I0)


def diff_eqs(INP, t):
    '''The main set of equations'''
    Y = np.zeros((2))
    V = INP
    Y[0] = - beta * V[0] * V[1] + gamma * V[1]
    Y[1] = beta * V[0] * V[1] - gamma * V[1]
    return Y  # For odeint


t_start = 0.0;
t_end = ND;
t_inc = TS
t_range = np.arange(t_start, t_end + t_inc, t_inc)
RES = spi.odeint(diff_eqs, INPUT, t_range)
"""RES is the result of fraction of susceptibles and infectious individuals at each time step respectively"""
print(RES)

# Ploting
pl.plot(RES[:, 0], '-bs', label='Susceptibles', linewidth=1, markersize=3)
pl.plot(RES[:, 1], '-ro', label='Infectious', linewidth=1, markersize=3)
pl.legend(loc=0)
pl.title('SI epidemic without births or deaths')
pl.xlabel('Time')
pl.ylabel('Susceptibles and Infectious')
pl.savefig('2.5-SI-high.png', dpi=900)  # This does increase the resolution.
pl.show()
