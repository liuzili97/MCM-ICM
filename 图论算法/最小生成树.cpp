#define MAX 100
#define MAXCOST 0x3f3f3f3f
int graph[MAX][MAX];

int main(){
	int m, n;
	int cost;
	ifstream in("input.txt");
	cin >> m >> n; // m=顶点的个数，n=边的个数
	//初始化图G
	memset(graph, 0x3f, sizeof(graph));
	//构建图G
	for (int k = 1; k <= n; k++){
		cin >> i >> j >> cost;
		graph[i][j] = cost; graph[j][i] = cost;
	} // 本程序i和j均从1开始
	//求解最小生成树
	cost = prim(graph, m);
	//输出最小权值和
	cout << "最小权值和=" << cost << endl;
	system("pause");
	return 0;
}

int prim(int graph[][MAX], int m){
	int lowcost[MAX]; // 记录U-V中 点j到V中点的最小距离
	int mst[MAX]; // 记录U-V中 点j到V中距离最小的点i
	int min, minid, sum = 0;
	for (int i = 2; i <= m; i++){ // V中加入第一个结点
		lowcost[i] = graph[1][i];
		mst[i] = 1; // 都先初始化为1
	}
	mst[1] = 0;
	for (int i = 2; i <= m; i++){ // 依次遍历m-1
		min = MAXCOST;
		minid = 0;
		for (int j = 2; j <= m; j++) 
		// 从U-V中找出到V中任一点权值最小的点j		
			if (lowcost[j] < min && lowcost[j] != 0){
				min = lowcost[j]; // 记录权值
				minid = j;
			}
		cout << "V" << mst[minid] << "-V" << 
						minid << "=" << min << endl;
		sum += min; // 求累计的代价（权重）
		lowcost[minid] = 0; // 代表该结点已经加入V
		for (int j = 2; j <= m; j++) 
			if (graph[minid][j] < lowcost[j]){
				lowcost[j] = graph[minid][j]; // 更新值
				mst[j] = minid; 
				// 用新加入V的元素更新U的起点
			}
	}
	return sum;
}