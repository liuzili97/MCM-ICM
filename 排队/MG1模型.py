def cal(lambda_, mu_, sigma_):
    rou_ = lambda_/mu_
    if rou_>=1:
        return 10000,10000
    P0=1-rou_
    #print(str(P0)+ "--稳态系统所有服务台全部空闲的概率")
    Lq=(rou_**2+lambda_**2*sigma_**2)/(2*(1-rou_))
    #print(str(Lq)+"--平均等待队长，即稳态系统任一时刻等待服务的顾客数的期望值")
    L=Lq+lambda_/mu_
    #print(str(L)+"--平均队长，即稳态系统任一时刻的所有顾客数的期望值")
    Wq=(1/lambda_)*Lq
    #print(str(Wq)+"--平均等待时间，即(在任意时刻)进入稳态系统的顾客等待时间的期望值")
    W=(1/lambda_)*L
    #print(str(W)+"--平均逗留时间，即(在任意时刻)进入稳态系统的顾客逗留时间的期望值")
    return Wq,Lq