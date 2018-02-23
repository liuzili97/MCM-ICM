import numpy as np
from numpy import random as rm
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
"""一个服务台，病人到达时间服从时间参数为10min的泊松过程，即每个人到来的时间服从独立同分布的指数分布，
每个病人到来之后，下一个病人到来的时间服从独立同分布的指数分布，期望为10min。当一个病人到来以后，将等待直到医生有空。
服务台在每个病人上花费的时间是一个随机变量，在5min到11min之间正态。总共模拟4200分钟
    得到有多少个病人来诊所看病，其中有多少病人需要等待，平均等待时间是多少？
"""
def simulation(T=4200): # 模拟4200min
    t = 0;nA =0;nD=0;n=0;A=[];D=[];N=[];S=[]
    # t：当前时间，nA：来客人数，nD: ， n：等待的人数，A：客来时间序列，D：客走时间序列，N：系统中人数序列，S：服务时间
    tA = rm.exponential(10,1) # 客来时间服从lambda为10的指数分布
    tD = float("inf")  # 客走时间
    while True:
        # print tA,tD,n,S
        if  (tA <= tD)  & (tA <= T): # 客来时点早于上一个客走时点，且在营业（需要等）
            t = tA # 更新当前时间
            nA = nA + 1 # 更新来客人数
            n = n+1 # n保存服务系统中人数
            tA = t + rm.exponential(10,1) # 产生新的客来时间，服从lambda为10的指数分布
            if n==1: # 系统中只有一个客人时才更新tD
                tS = rm.normal(8,1,1) # 表示产生均值为8，标准差为1的大小为1的正态分布随机数
                tD = t + tS# 客走时间等于客来时间加服务时间
                S.append(tS)
            A.append(t) # 保存客来时间序列
        elif (tD <= tA) & (tD <=T):  #如果客来时点晚于客走时点（不需要等）
            t = tD; n= n-1
            nD = nD + 1
            if n==0:  tD = float("inf") #如果无人等待
            else:
                tS = rm.normal(8,1,1)
                tD = t + tS
                S.append(tS) # 保存每人服务时间长度
            D.append(t) #保存客走时间序列
            N.append(n) #保存系统中人数序列
        elif (tA>T) & (tD>T):  break # 过点关门
    while True:
        if n <=0:  break
        t = tD;n=n-1;nD=nD+1 #还有最后几个人在服务
        D.append(t)
        N.append(n)
        if n>0:
            tS = rm.normal(8,1,1)
            tD = t + tS
            S.append(tS)
    Tp = max(t-T,0) #关门时间
    # A表示客来时点，D表示客走时点，N表示客走时系统中还有几人，S表示此人服务时长
    raw = {'A':A,'D':D,'S':S,'N':N}
    data = pd.DataFrame(raw)
    return {'count': data.N.count(),'wcount':sum(data.N>0),'avgwait':float(pd.DataFrame.mean(data.D-data.A-data.S))}

# 模拟100次，将结果存为dataframe
res = [simulation() for i in range(100)]
res = pd.DataFrame(res)
print(res["avgwait"].mean()) # 输出平均等待时间

# 画出平均等待时间的直方图
sns.distplot(res["avgwait"], kde=True,label="Waiting Time")
plt.show()