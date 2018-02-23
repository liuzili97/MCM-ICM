import  numpy as np
"""
电影结束之后会有20个人想上厕所；
这20个人会在0到10分钟之内全部到达厕所（第2,3条使用了均匀分布，追求严谨的简友们可以用正态分布）；
每个人上厕所时间在1-3分钟之间。
模拟最简单的情况，厕所只有一个位置，不考虑两人共用的情况则每人必须等上一人出恭完毕方可进行。
"""
arrivingtime = np.random.uniform(0,10,size = 20)
arrivingtime.sort()
working = np.random.standard_normal(20)*0.3+0.5
startingtime = [0 for i in range(20)]
finishtime = [0 for i in range(20)]
waitingtime = [0 for i in range(20)]
emptytime = [0 for i in range(20)]
startingtime[0] = arrivingtime[0]
finishtime[0] = startingtime[0] + working[0]
waitingtime[0] = startingtime[0]-arrivingtime[0]

for i in range(1,len(arrivingtime)):
    if finishtime[i-1] > arrivingtime[i]:#如果下一个到了这个人还没有结束
        startingtime[i] = finishtime[i-1]#没结束的话要等上一人结束之后方可开始
    else:
        startingtime[i] = arrivingtime[i]
        emptytime[i] = startingtime[i] - finishtime[i-1]

for i in range(1,len(arrivingtime)):
    if finishtime[i-1] > arrivingtime[i]:
        startingtime[i] = finishtime[i-1]
    else:
        startingtime[i] = arrivingtime[i]
        emptytime[i] = startingtime[i] - finishtime[i-1]
    finishtime[i] = startingtime[i] + working[i]
    waitingtime[i] = startingtime[i] - arrivingtime[i]
    print(waitingtime[i])
print("average waiting time is %f" % np.mean(waitingtime))
