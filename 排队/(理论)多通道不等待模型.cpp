#include <iostream>
#include <cmath>
// http://blog.csdn.net/qq547276542/article/details/77689099
/*绝对通过能力A：单位时间内被服务被服务顾客的数学期望；相对通过能力Q：被服务顾客的顾客数与请求服务顾客的顾客数的比值
系统损失概率P损：服务系统满员的概率；队长L系：系统内顾客数量的数学期望值；排队长L队：系统内排队顾客数的数学期望值
逗留时间W系：顾客在系统内逗留时间的数学期望值；排队时间W队：系统内顾客排队等待服务时间的数学期望

某电话总机有3条中继线，平均每分钟有0.8次呼唤。如果每次通话时间平均为1.5分钟，
试求：系统状态的极限概率；绝对通过能力和相对通过能力；损失概率和占用通道的平均数。
输入：
	服务员个数：3
	顾客流强度：0.8
	服务台能力：0.667（即1.5/3）
*/
using namespace std;
const int maxn = 1007;
double jc(int k) { //阶乘
    double ans = 1;
    for (int i = 2; i <= k; i++) {
        ans *= i;
    }
    return ans;
}
int main() {
    double n = 3, lamda = 0.8, u = 0.667;
    double miu = lamda / u;
    double p0 = 1, cur = 0;
    for (int i = 0; i <= n; i++) {
        cur += pow(miu, i) / jc(i);
    }
    p0 /= cur;
    double p_sun = pow(miu, n) * p0 / jc(n);
    double Q = 1 - p_sun;
    double A = lamda * Q;
    double K = miu * (1 - p_sun);
    double zyl = K / n;
    cout<<"-----输入各项参数：-----\n";
    cout<<"服务员个数："<<n<<endl;
    cout<<"顾客流强度："<<lamda<<endl;
    cout<<"服务台能力："<<u<<endl;
    cout<<"-----系统效率指标：-----\n";
    cout<<"损失概率= "<<p_sun<<endl;
    cout<<"系统的相对通过能力= "<<Q<<endl;
    cout<<"系统的绝对通过能力= "<<A<<endl;
    cout<<"占用服务员的平均数= "<<K<<endl;
    cout<<"通道占用率= "<<zyl<<endl;
    return 0;
}
