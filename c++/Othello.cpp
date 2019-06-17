//-----------------------------------------------------------------------------
//タイトル：  オセロ (キーボード操作)
//作成者：    SKYOKEN     
//作成日：    2018/12/11
//修正日：    2018/12/13
//
//2018/12/16 AIを削除し、二人対戦だけモードにする
//-----------------------------------------------------------------------------
#include <iostream>
#include<windows.h>
using namespace std;
//-----------------------------------------------------------------------------------------------
#define sizeX 8												//x
#define sizeY 8												//y
#define NONE 0												//空
#define BLACK 1												//黒
#define WHITE 2												//白
int num[sizeY][sizeX] = { 0 };								//盤面表示のデータ
int score[3] = { 0 };										//空、黒、白の駒数
const char* msg[] = { "・","●","○","？" };					//盤面表示の文字
const char* overMsg[] = { "引き分け","●の勝つ","〇の勝つ" };	//結果表示の文字
//-----------------------------------------------------------------------------------------------
#define TURNB 0												//手番　黒
#define TURNW 1												//手番　白(使ってないけど、一応書く)
int turn;													//手番
int position[8][2] = { {-1,-1},{0,-1},{1,-1},				//8方向の座標
						{-1,0},			{1,0},
						{-1,1},{0,1},{1,1} };

//-----------------------------------------------------------------------------------------------
void ini();													//初期化
void play();												//実行
bool check(int x, int y);									//駒の配置できる個所を探す
bool checkSub(int x, int y, int* p);						//指定された方向に探す
bool checkOver();											//関数3：（入力）盤面状態、手番　（出力）終了判定、終了の場合は点数の計算
void update(int x, int y);									//駒を置いた後、turn交代
void updateSub(int x, int y, int* p);						//指定された方向に異色の駒を裏返す
int getScore(int turn);										//駒数更新
void input();												//入力
void output();												//出力
															//関数1：（入力）盤面状態、手番　（出力）次の手
															//関数2：（入力）盤面状態、次の手　（出力）次の手を打った後の盤面状態

//-----------------------------------------------------------------------------------------------
int main() {
	system("color f0");
	ini();		//初期化
	play();		//ゲーム
	system("PAUSE");
	return 0;
}
//-----------------------------------------------------------------------------------------------
//初期化
//-----------------------------------------------------------------------------------------------
void ini() {
	//手番を黒にする（先手）
	turn = TURNB;
	//盤面中央4マスのデータを初期化
	num[sizeY / 2 - 1][sizeX / 2 - 1] = BLACK; num[sizeY / 2 - 1][sizeX / 2] = WHITE;			//●〇
	num[sizeY / 2][sizeX / 2 - 1] = WHITE; num[sizeY / 2][sizeX / 2] = BLACK;					//〇●
	
}
//-----------------------------------------------------------------------------------------------
//ゲーム実行
//-----------------------------------------------------------------------------------------------
void play() {
	while (!checkOver()) {	//ゲームが終わらないと、ずっと実行する
		input();
	}
}
//-----------------------------------------------------------------------------------------------
//駒の配置できる個所を探す
//-----------------------------------------------------------------------------------------------
bool check(int x, int y) {
	//if(そのマスに駒がすでに存在している)return;
	if (num[y][x] != 0)return false;
	// 8方向走査(縦、横、斜め)
	for (int i = 0; i < 8; i++) if (checkSub(x, y, position[i]))return true;
	return false;
}
//-----------------------------------------------------------------------------------------------
//指定された方向に探す
//-----------------------------------------------------------------------------------------------
bool checkSub(int x, int y, int* p) {
	//if(そのマスに駒がすでに存在している)return false;
	if (num[y][x] != 0)return false;
	//座標のコピー
	int x_ = x, y_ = y;
	//指定された方向に進んで、隣接している異色の駒の確認(異色の駒がなければ、止まる)
	while (x_ + p[0] >= 0 && x_ + p[0] < sizeX && y_ + p[1] >= 0 && y_ + p[1] < sizeY && num[y_ + p[1]][x_ + p[0]] == 3 - (turn + 1)) {
		x_ += p[0];
		y_ += p[1];
	}
	//if(指定された方向に進んでないなら(隣接している異色の駒がないということ))return false;
	if (x_ == x && y_ == y)return false;
	//if(止まったところに、隣接している駒は同色の駒)return true;
	if (x_ + p[0] >= 0 && x_ + p[0] < sizeX && y_ + p[1] >= 0 && y_ + p[1] < sizeY && num[y_ + p[1]][x_ + p[0]] == turn + 1)return true;
	return false;
}
//-----------------------------------------------------------------------------------------------
//駒を置く、手番交代
//-----------------------------------------------------------------------------------------------
void update(int x, int y) {
	//8方向に異色の駒を裏返す
	for (int i = 0; i < 8; i++)updateSub(x, y, position[i]);
	//指定された位置に駒を置く
	num[y][x] = turn + 1;
	//手番交代
	turn = 1 - turn;
}
//-----------------------------------------------------------------------------------------------
//指定された方向に異色の駒を裏返す
//-----------------------------------------------------------------------------------------------
void updateSub(int x, int y, int* p) {
	//if(指定された方向に裏返せる駒がない)return;
	if (!checkSub(x, y, p))return;
	//指定された方向に異色の駒を裏返す
	while (x + p[0] >= 0 && x + p[0] < sizeX && y + p[1] >= 0 && y + p[1] < sizeY && num[y + p[1]][x + p[0]] == 3 - (turn + 1)) {
		num[y + p[1]][x + p[0]] = turn + 1;
		x += p[0]; y += p[1];
	}
}
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//関数3：（入力）盤面状態、手番　（出力）終了判定、終了の場合は点数の計算
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
bool checkOver() {
	//終了判定
	//両方とも置く場所がない(盤面がすべてうまる)
	for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))return false;
	turn = 1 - turn;
	for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))return false;
	//盤面状態、手番
	output();
	//メッセージの表示
	printf("GAME OVER\n");
	//点数の計算
	printf("%s", overMsg[score[BLACK] < score[WHITE] ? 2 : (score[BLACK] > score[WHITE] ? 1 : 0)]);
	return true;
}
//-----------------------------------------------------------------------------------------------
//入力
//-----------------------------------------------------------------------------------------------
void input() {
	//盤面更新
	output();
	//メッセージ
	cout << "どこに置く？行（1-8）列（A-H）\n" << endl;
	//文字の入力
	char x, y;
	cin >> x >> y;		//x:アルファベット,y:数字
	//文字を座標に変換する(大文字と小文字、どっちでも構わない)
	int y_ = y - '1', x_ = (x >= 'A'&&x <= 'Z') ? x - 'A' : x - 'a';
	//正確に入力しない、ずっと入力を繰り返す。
	if (!check(x_, y_)) { cout << "エラー" << endl; Sleep(1000); return; }
	//正確に入力した後、駒を置く裏返せる駒も裏返す)、手番交代
	update(x_, y_);

}
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//関数1：（入力）盤面状態、手番　（出力）次の手
//関数2：（入力）盤面状態、次の手　（出力）次の手を打った後の盤面状態
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
void output() {
	//画面クリア
	system("cls");
	//盤面表示
	cout << "　";
	for (int x = 0; x < sizeX; x++) cout << char('A' + x) << " ";		//ABCDEFGH(サイズによって表示する)
	cout << endl;
	for (int y = 0; y < sizeY; y++) {
		cout << y + 1;		//12345678(サイズによって表示する)
		for (int x = 0; x < sizeX; x++) {
			//データを表示
			cout << (check(x, y) ? msg[3] : msg[num[y][x]]);		//0:・　1:●　2:〇　3:？(次に駒が置ける位置)
		}
		cout << endl;
	}
	//駒数表示
	for (int i = 0; i < 3; i++) { score[i] = getScore(i); }
	cout << "空：" << score[NONE] << "　●：" << score[BLACK] << "　○：" << score[WHITE] << endl;

	//手番：（出力）次の手
	cout << "次は" << msg[turn + 1] << "の番" << endl;
	//候補項
	cout << "候補項：";
	for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))cout << char('A' + x) << y + 1 << " ";
	cout << endl;
}
//-----------------------------------------------------------------------------------------------
//駒数更新
//-----------------------------------------------------------------------------------------------
int getScore(int turn) {
	int sum = 0;
	for (int y = 0; y < sizeY; y++) for (int x = 0; x < sizeX; x++) if (num[y][x] == turn)sum++;
	return sum;
}