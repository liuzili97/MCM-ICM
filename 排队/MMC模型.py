def cal(lambda_, C, mu_):
    P0 = 0.0
    rou_ = lambda_/(C*mu_)
    if rou_>=1:
        return 10000,10000
    for k in range(1, C, 1):
        P0 += (float(1)/np.math.factorial(k))*((lambda_/mu_)**k)
    P0+=(float(1)/np.math.factorial(C))*(float(1)/(1-rou_))*((lambda_/mu_)**C)
    P0 = 1 / P0
    #print(str(P0)+ "--稳态系统所有服务台全部空闲的概率")
    Lq=(((C*rou_)**C*rou_)/(np.math.factorial(C)*(1-rou_)**2))*P0
    #print(str(Lq)+"--平均等待队长，即稳态系统任一时刻等待服务的顾客数的期望值")
    L=Lq+lambda_/mu_
    #print(str(L)+"--平均队长，即稳态系统任一时刻的所有顾客数的期望值")
    Wq=Lq/lambda_
    #print(str(Wq)+"--平均等待时间，即(在任意时刻)进入稳态系统的顾客等待时间的期望值")
    W=L/lambda_
    #print(str(W)+"--平均逗留时间，即(在任意时刻)进入稳态系统的顾客逗留时间的期望值")
    return Wq,Lq