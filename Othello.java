import java.util.Scanner;
public class Othello {
	private static int sizeX=8;				//8にしても遊べる
	private static int sizeY=8;
	private static final int NONE=0;
	private static final int BLACK=1;
	private static final int WHITE=2;
	private static final int TURNB=0;
	private static final int TURNW=1;
	private static int[][] data=new int[sizeX][sizeY];
	private static int[][] position= { {-1,-1},{0,-1},{1,-1},
										{-1,0},{1,0},
										{-1,1},{0,1},{1,1} };
	private static int turn;
	
	public static void main(String[] args) {
		ini();
		while (!checkOver())play();
	}
	//-----------------------------------------------------------------------------------------------
	//初期化
	//-----------------------------------------------------------------------------------------------
	private static void ini() {
		for(int y=0;y<sizeY;y++)for(int x=0;x<sizeX;x++)data[y][x]=0;
		turn=TURNB;
		data[sizeY/2-1][sizeX/2-1]=BLACK;data[sizeY/2-1][sizeX/2]=WHITE;
		data[sizeY/2][sizeX/2-1]=WHITE;data[sizeY/2][sizeX/2]=BLACK;
	}
	//-----------------------------------------------------------------------------------------------
	//実行
	//-----------------------------------------------------------------------------------------------
	public static void play() {
		output();
		input();
	}
	//-----------------------------------------------------------------------------------------------
	//入力
	//-----------------------------------------------------------------------------------------------
	private static void input() {
		Scanner scan = new Scanner(System.in);
		System.out.println("どこに置く？	(行1-8列A-H)	例：3D");
            String str1= scan.next();
		if(str1.length()==1){System.out.println("短く過ぎる");return;}
      int y =str1.charAt(0) - '1';
      int x = (str1.charAt(1) >= 'A'&&str1.charAt(1) <= 'Z') ? str1.charAt(1) - 'A' : str1.charAt(1) - 'a';
		if(x<0 || x>sizeX || y<0 || y>sizeY){System.out.println("エラー");return;}
		if (!check(x, y)) { System.out.println("エラー");return;}
		update(x, y); return;
	}
	//-----------------------------------------------------------------------------------------------
	//次の手を打った後の盤面状態
	//-----------------------------------------------------------------------------------------------
	private static void output() {
		System.out.print("　");
		String A="ABCDEFGH";
		for(int x=0;x<sizeX;x++) {
			System.out.print(A.charAt(x)+" ");
		}
		System.out.println();

		String[] msg= { "・","●","○","？" };
		for (int y = 0; y < sizeY; y++) {
			System.out.print(y+1);
			for (int x = 0; x < sizeX; x++) {
				System.out.print(check(x, y) ? msg[3] : msg[data[y][x]]);
			}
			System.out.println();
		}
		//駒数更新
		System.out.println("無：" +getScore(NONE)+"　●："+getScore(BLACK)+"　○："+getScore(WHITE));
		//（出力）次の手
		System.out.println(msg[turn+1]+"の番");
		//候補項
		System.out.print("候補項：");
		for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))System.out.print("("+(y + 1)+","+A.charAt(x)+") ");
		System.out.println();

	}
	//-----------------------------------------------------------------------------------------------
	//駒の配置できる個所を探す
	//-----------------------------------------------------------------------------------------------
	private static boolean check(int x,int y) {
		//if(そのマスに駒がすでに存在している)return;
		if (data[y][x] != 0)return false;
		// 8方向走査(縦、横、斜め)
		for (int i = 0; i < 8; i++) if (checkSub(x, y, position[i]))return true;
		return false;
	}
	//-----------------------------------------------------------------------------------------------
	//指定された方向に探す
	//-----------------------------------------------------------------------------------------------
	private static boolean checkSub(int x,int y,int[]p) {
		//if(そのマスに駒がすでに存在している)return false;
		if (data[y][x] != 0)return false;
		//座標のコピー
		int x_ = x, y_ = y;
		//指定された方向に進んで、隣接している異色の駒の確認(異色の駒がなければ、止まる)
		while (x_ + p[0] >= 0 && x_ + p[0] < sizeX && y_ + p[1] >= 0 && y_ + p[1] < sizeY && data[y_ + p[1]][x_ + p[0]] == 3 - (turn+1)) {
			x_ += p[0];
			y_ += p[1];
		}
		//if(指定された方向に進んでないなら(隣接している異色の駒がないということ))return false;
		if (x_ == x && y_ == y)return false;
		//if(止まったところに、隣接している駒は同色の駒)return true;
		if (x_ + p[0] >= 0 && x_ + p[0] < sizeX && y_ + p[1] >= 0 && y_ + p[1] < sizeY && data[y_ + p[1]][x_ + p[0]] == turn+1)return true;
		return false;
	}
	//-----------------------------------------------------------------------------
	//駒を置いた後、turn交代
	//-----------------------------------------------------------------------------
	private static void update(int x, int y) {
		//8方向に色の駒を裏返す
		for (int i = 0; i < 8; i++)updateSub(x, y, position[i]);
		//指定された位置に駒を置く
		data[y][x] = turn+1;
		//turn交代
		turn = 1 - turn;
	}
	//-----------------------------------------------------------------------------
	//指定された方向に異色の駒を裏返す
	//-----------------------------------------------------------------------------
	private static void updateSub(int x, int y, int[] p) {
		//if(指定された方向に裏返せる駒がない)return;
		if (!checkSub(x, y, p))return;
		//指定された方向に異色の駒を裏返す
		while (x + p[0] >= 0 && x + p[0] < sizeX && y + p[1] >= 0 && y + p[1] < sizeY && data[y + p[1]][x + p[0]] == 3 - (turn+1)) {
			data[y + p[1]][x + p[0]] = turn+1;
			x += p[0]; y += p[1];
		}
	}
	

	//-----------------------------------------------------------------------------
	//終了判定、終了の場合は点数の計算
	//-----------------------------------------------------------------------------
	private static boolean checkOver() {
		//両方とも置く場所がない/盤面がすべてうまる
		for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))return false;
		turn = 1 - turn;
		for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)if (check(x, y))return false;
		//盤面更新
		output();
		//メッセージの表示
		System.out.println("GAME OVER");
		System.out.println(getScore(BLACK) < getScore(WHITE) ? "〇の勝つ" : (getScore(BLACK) > getScore(WHITE) ? "●の勝つ" : "引き分け"));
		//点数の計算
		System.out.println(getScore(BLACK) < getScore(WHITE) ?"　●："+getScore(BLACK)+"　○："+(getScore(WHITE)+getScore(NONE)):"　●："+(getScore(BLACK)+getScore(NONE))+"　○："+getScore(WHITE));
		return true;
	}

	//-----------------------------------------------------------------------------------------------
	//駒数更新
	//-----------------------------------------------------------------------------------------------
	private static int getScore(int turn) {
		int sum=0;
		for(int y=0;y<sizeY;y++)for(int x=0;x<sizeX;x++)if(data[y][x]==turn)sum++;
		return sum;
	}
}
