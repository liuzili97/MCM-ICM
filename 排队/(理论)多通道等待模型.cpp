// http://blog.csdn.net/qq547276542/article/details/77689099
/*某临时假设的公路简便桥，桥上不容许同时又两辆汽车通过。若汽车到达流为泊松流，其强度为λ=2.1辆/分钟。
通过时间为指数分布，平均每辆的通过时间为0.4分钟，试求系统的效率指标。*/
#include <cmath>
#include <iostream>
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
    double n = 1, lamda = 2.1, u = 2.5;
    double miu = lamda / u;
    double p0 = 1-miu;
    double p_sun = 0;
    double Q = 1 - p_sun;
    double A = lamda * Q;
    double L_dui = pow(miu, n + 1) *p0 / (n * jc(n)) ;
    L_dui /= (1 - miu / n) * (1 - miu / n);
    double W_dui = L_dui / lamda;
    double K = miu * (1 - p_sun);
    double L_xi = L_dui + miu;
    double W_xi = L_xi/lamda;
    cout << "-----输入各项参数：-----\n";
    cout << "服务员个数：" << n << endl;
    cout << "顾客流强度：" << lamda << endl;
    cout << "服务台能力：" << u << endl;
    cout << "-----系统效率指标：-----\n";
    cout << "损失概率= " << p_sun << endl;
    cout << "系统的相对通过能力= " << Q << endl;
    cout << "系统的绝对通过能力= " << A << endl;
    cout << "系统内排队顾客的平均数= " << L_dui << endl;
    cout << "顾客的平均排队时间= " << W_dui << endl;
    cout << "占用服务员的平均数= " << K << endl;
    cout << "系统内顾客的平均数= " << L_xi << endl;
    cout << "顾客在系统中平均逗留时间= " << W_xi << endl;
    return 0;
}