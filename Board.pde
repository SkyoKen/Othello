//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃ゲーム盤                                                                           　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Board { 
  private int[][] data;          //盤面データ
  private int sizeX, sizeY;      //x,y
  private float d;               //d
  private int turn=TURNB;        //手番
  private int winner;            //勝利者
  private int t;                 //先手と後手を決める
  private int ai;                //難しさを決める
  private  PVector[] position={new PVector(-1, -1), new PVector(0, -1), new PVector(1, -1),    //8方向の座標   
                                new PVector(-1, 0),                     new PVector(1, 0), 
                                new PVector(-1, 1), new PVector(0, 1), new PVector(1, 1)};
  private int[][] EXPECT;        //評価関数
  /*private final int[][] EXPECT =                     
   {
   {500, -60, 10, 10, 10, 10, -60, 500}, 
   {-60, -80, 5, 5, 5, 5, -80, -60}, 
   {10, 5, 1, 1, 1, 1, 5, 10}, 
   {10, 5, 1, 1, 1, 1, 5, 10}, 
   {10, 5, 1, 1, 1, 1, 5, 10}, 
   {10, 5, 1, 1, 1, 1, 5, 10}, 
   {-60, -80, 5, 5, 5, 5, -80, -60}, 
   {500, -60, 10, 10, 10, 10, -60, 500}
   };*/
  //-----------------------------------------------------------------------------
  //「初期化」タスク生成時に１回だけ行う処理
  //-----------------------------------------------------------------------------
  public Board() {
    NewGame();
  }

  //-----------------------------------------------------------------------------
  //初期化
  //-----------------------------------------------------------------------------
  public void NewGame() {
    this.sizeX=option.getSize();    //x
    this.sizeY=option.getSize();    //y
    this.d=height/(this.sizeY+3);   //d
    this.turn=TURNB;                //手番を黒にする（先手）
    this.t=option.getTurn();        //プレイヤーの色を設定する
    this.ai=option.getAI();         //選んだ相手に設定する
    //data配列情報の初期化(boardをクリア)
    this.data=new int[this.sizeX][this.sizeY];
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
        this.data[y][x]=0;
      }
    }
    
  //盤面中央4マスのデータを初期化
    this.data[this.sizeY/2-1][this.sizeX/2-1]=BLACK;
    this.data[this.sizeY/2-1][this.sizeX/2]=WHITE;
    this.data[this.sizeY/2][this.sizeX/2-1]=WHITE;
    this.data[this.sizeY/2][this.sizeX/2]=BLACK;
    //評価関数初期化(4*4,6*6,8*8じゃなくても使える)
    EXPECT=new int[this.sizeY][this.sizeX];
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
        if (x>1 && x<this.sizeX-2 && y>1 && y<this.sizeY-2) {
          this.EXPECT[y][x]=1;
        } else if (x!=y && this.sizeX-x-1!=y && this.sizeY-1-y!=x && x!=0 && x!=this.sizeX-1 && y!=0 && y!=this.sizeY-1) {
          this.EXPECT[y][x]=5;
        } else {
          this.EXPECT[y][x]=10;
        }
      }
      this.EXPECT[0][0]=500;
      this.EXPECT[this.sizeY-1][0]=500;
      this.EXPECT[0][this.sizeX-1]=500;
      this.EXPECT[this.sizeY-1][this.sizeX-1]=500;
      this.EXPECT[0][1]=-60;
      this.EXPECT[this.sizeY-1][1]=-60;
      this.EXPECT[1][this.sizeX-1]=-60;
      this.EXPECT[this.sizeY-2][this.sizeX-1]=-60;
      this.EXPECT[1][0]=-60;
      this.EXPECT[this.sizeY-2][0]=-60;
      this.EXPECT[0][this.sizeX-2]=-60;
      this.EXPECT[this.sizeY-1][this.sizeX-2]=-60;
      if (this.sizeX>4) {
        this.EXPECT[1][1]=-80;
        this.EXPECT[this.sizeY-2][1]=-80;
        this.EXPECT[1][this.sizeX-2]=-80;
        this.EXPECT[this.sizeY-2][this.sizeX-2]=-80;
      }
    }
     for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
       print(EXPECT[y][x]+" ");
      }
      println();
     
   }
    this.turn=TURNB;
    this.winner=0;
  }

  //-----------------------------------------------------------------------------
  //「実行」１フレーム毎に行う処理
  //-----------------------------------------------------------------------------
  public void update() {
    
   // if(checkOver())return;
   //delay(1000);
    if(!checkOver()&&this.ai!=5){
    AI();
    delay(1000);}
    //描画
    showBoard();
  }
  //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  //関数：（入力）盤面状態　（出力）次の手を打った後の盤面状態
  //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  private void  showBoard(){

    pushMatrix();
    translate(width/2, height/2);
    rectMode(CENTER);
    //画面クリア
    fill(107, 142, 35);
   
   stroke(0);
     rect(0, 0, width/2, height-this.d);
    //盤面表示
    translate(-this.d*this.sizeX/2, -this.d*this.sizeY/2);

    for (int y=0; y<this.sizeY+1; y++) {
      for (int x=0; x<this.sizeX+1; x++) {
        stroke(0);
        line(0, this.d*y, this.d*this.sizeX, this.d*y);
        line(this.d*x, 0, this.d*x, this.d*this.sizeY);
      }
    }
    //1-8
    fill(255);
    textAlign(CENTER, CENTER);

    pushMatrix();
    textSize(this.d*0.8);
    translate(-this.d/2*0.8, this.d/2);
    for (int y=0; y<this.sizeY; y++) {
      text(y+1, 0, y*this.d);
    }
    popMatrix();

    //A-H
    pushMatrix();
    textSize(this.d*0.8);

    translate(this.d/2, -this.d/2*1.2);
    for (int x=0; x<this.sizeY; x++) {
      text(char(x+'A'), x*this.d, 0);
    }
    popMatrix();

    //駒
    color[] c={125, 0, 255};
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {

        if (this.data[y][x]!=0) {//1:●　2:〇
          fill(c[this.data[y][x]]);
          stroke(c[this.data[y][x]]);
          ellipseMode(CENTER);
          ellipse((x+0.5)*this.d, (y+0.5)*this.d, this.d*0.8, this.d*0.8);
        }
        if (check(x, y)) {//・(次に駒が置ける位置)
          fill(c[this.turn+1]);
          stroke(c[this.turn+1]);
          ellipseMode(CENTER);
          ellipse((x+0.5)*this.d, (y+0.5)*this.d, this.d*0.1, this.d*0.1);
        }
      }
    }

    popMatrix();
  }
  //-----------------------------------------------------------------------------------------------
  //駒数更新
  //-----------------------------------------------------------------------------------------------
  public int[] getScore() {
    int[] score=new int[3];
    Arrays.fill(score, 0, 3, 0);
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
        if (this.data[y][x]==BLACK) {
          score[1]++;
        } else if (this.data[y][x]==WHITE) {
          score[2]++;
        } else {
          score[0]++;
        }
      }
    }
    return score;
  }
  //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  //関数3：（入力）盤面状態、手番　（出力）終了判定、終了の場合は点数の計算
  //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  public boolean checkOver() {
    if(game.over)return true;
    //終了判定
    //両方とも置く場所がない(盤面がすべてうまる)
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y))return false;
    this.turn=1-turn;
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y))return false;
    //点数の計算
    int[] score=this.getScore();
    //盤面状態、手番
    this.winner=score[BLACK]==score[WHITE]?0:(score[BLACK]>score[WHITE]?BLACK:WHITE);
    showBoard();
    return true;
  }
  //-----------------------------------------------------------------------------------------------
  //駒の配置できる個所を探す
  //-----------------------------------------------------------------------------------------------
  public boolean check(int x, int y) {
    //if(そのマスに駒がすでに存在している)return;
    if (this.data[y][x]!=0)return false;
    // 8方向走査(縦、横、斜め)
    for (int i=0; i<8; i++)if (checkSub(x, y, position[i]))return true;
    return false;
  }
  //-----------------------------------------------------------------------------------------------
  //指定された方向に探す
  //-----------------------------------------------------------------------------------------------
  private boolean checkSub(int x, int y, PVector p) {
    //if(そのマスに駒がすでに存在している)return false;
    if (this.data[y][x]!=0)return false;
    //座標のコピー
    int x_=x, y_=y;
    //指定された方向に進んで、隣接している異色の駒の確認(異色の駒がなければ、止まる)
    int px=(int)p.x, py=(int)p.y;
    while (x_ + px >= 0 && x_ + px < this.sizeX && y_ + py >= 0 && y_ + py < this.sizeY && data[y_+py][x_+ px] == 3 - (this.turn+1)) {
      x_ += px;
      y_ += py;
    }
    //if(指定された方向に進んでないなら(隣接している異色の駒がないということ))return false;
    if (x_==x&&y_==y)return false;
    //if(止まったところに、隣接している駒は同色の駒)return true;
    if (x_ + px >= 0 && x_ + px < this.sizeX && y_ + py >= 0 && y_ + py < this.sizeY && data[y_ + py][x_ + px] == this.turn+1)return true;
    return false;
  }

  public void play(int x, int y) {
    if (!check(x, y))return;    
    boardUpdate(x, y);
  }; 
  //-----------------------------------------------------------------------------------------------
  //駒を置く、手番交代
  //-----------------------------------------------------------------------------------------------
  private void boardUpdate(int x, int y) {
    //8方向に異色の駒を裏返す
    for (int i=0; i<8; i++)boardUpdateSub(x, y, this.position[i]);
    //指定された位置に駒を置く
    this.data[y][x]=this.turn+1;
    //手番交代
    this.turn=1-turn;
  }  
  //-----------------------------------------------------------------------------------------------
  //指定された方向に異色の駒を裏返す
  //-----------------------------------------------------------------------------------------------
  private void boardUpdateSub(int x, int y, PVector p) {
    //if(指定された方向に裏返せる駒がない)return;
    if (!checkSub(x, y, p))return;
    //指定された方向に異色の駒を裏返す
    int px=(int)p.x, py=(int)p.y;
    while (x + px >= 0 && x + px < this.sizeX && y + py >= 0 && y + py < this.sizeY && this.data[y + py][x + px] == 3 - (this.turn+1)) {
      this.data[y + py][x + px] = this.turn+1;
      x += px; 
      y += py;
    }
  }
  public int getWinner() {
    return this.winner;
  }
  public int getTurn() {
    return this.turn;
  }
  //-----------------------------------------------------------------------------------------------
  //相手
  //-----------------------------------------------------------------------------------------------
  public void AI() {
    //プレイヤーの番なら、return
    if (this.turn==t)return;
    switch(this.ai) {
      //(マスが複数の場合、この中でランダムで選ぶ)
    case 0:
      AI0();
      break;   //AI 選べるマスを選ぶ
    case 1:
      AI1();
      break;   //AI 裏返せる駒の最大値のマスを選ぶ
    case 2:
      AI2();
      break;   //AI 最大優先度のマスを選ぶ
    case 3:
      AI3();
      break;   //AI 全盤面の評価関数が最大でとれるマスを選ぶ
    case 4:
      AI4();
      break;   //AI 全盤面の評価関数が最大でとれるマスを選ぶ(次に相手が駒を置いた後の状況も考える場合)
      default:return;
     
    }
  }
  //-----------------------------------------------------------------------------------------------
  //AI0 選べるマスを選ぶ
  //-----------------------------------------------------------------------------------------------
  public void AI0() {
    //選べる座標の取得
    PVector pos=getRandomPoint()[(int)random(getPointNum())];
    //駒を置く裏返せる駒も裏返す)、手番交代
    play((int)pos.x, (int)pos.y);
  }
  //選べるマス数
  private int getPointNum() {
    int sum=0;
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y))sum++;
    return sum;
  }
  //選べるマス(複数の場合、ランダムで選ぶ)
  private PVector[] getRandomPoint() {
    int x, y, i=0;
    PVector[] pos=new PVector[this.sizeX*this.sizeY];
    for (y=0; y<this.sizeY; y++) {
      for (x=0; x<this.sizeX; x++) {
        //     print(checkNum(x,y));
        if (check(x, y)) {
          pos[i]=new PVector(x, y);
          i++;
        }
      }
    }
    return pos;
  }
  //-----------------------------------------------------------------------------------------------
  //AI1　裏返せる駒の最大値のマスを選ぶ
  //-----------------------------------------------------------------------------------------------
  public void AI1() {
    //選べる座標の取得
    PVector pos=getMaxPoint()[(int)random(getMaxPointSum())];
    //駒を置く裏返せる駒も裏返す)、手番交代
    play((int)pos.x, (int)pos.y);
  }
  //8方向裏返せる駒数を数える
  private int checkNum(int x, int y) {
    //if(そのマスに駒がすでに存在している)return 0;
    if (this.data[y][x]!=0)return 0;
    int sum=0;
    // 8方向走査(縦、横、斜め)で数える
    for (int i=0; i<8; i++)sum+=checkNumSub(x, y, this.position[i]);

    return sum;
  }
  //指定された方向で裏返せる駒数を数える
  private int checkNumSub(int x, int y, PVector p) {
    //if(そのマスに駒がすでに存在している)return 0;
    if (this.data[y][x]!=0)return 0;
    // 指定された方向に査(縦、横、斜め)で数える
    int sum=0;
    //座標のコピー
    int x_=x, y_=y;
    //指定された方向に進んで、隣接している異色の駒の確認(異色の駒がなければ、止まる)
    int px=(int)p.x, py=(int)p.y;
    while (x_ + px >= 0 && x_ + px < this.sizeX && y_ + py >= 0 && y_ + py < this.sizeY && data[y_+py][x_+ px] == 3 - (this.turn+1)) {
      x_ += px;
      y_ += py;
      sum++;
    }    
    //if(指定された方向に進んでないなら(隣接している異色の駒がないということ))return 0;
    if (x_==x&&y_==y)return 0;
    //if(止まったところに、隣接している駒は同色の駒)return sum;
    if (x_ + px >= 0 && x_ + px < this.sizeX && y_ + py >= 0 && y_ + py < this.sizeY && data[y_ + py][x_ + px] == this.turn+1)return sum;
    return 0;
  }
  //裏返せる駒の最大値
  private int getMaxPointNum() {
    int x, y, max=0;
    for (y=0; y<this.sizeY; y++) {
      for (x=0; x<this.sizeX; x++) {
        //     print(checkNum(x,y));
        if (checkNum(x, y)>max) {
          max=checkNum(x, y);
        }
      }
    }

    return max;
  }
  //裏返せる駒の最大値のマス数
  private int getMaxPointSum() {
    int sum=0, max=getMaxPointNum();
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
        if (checkNum(x, y)==max) {
          sum++;
        }
      }
    }
    return sum;
  }
  //裏返せる駒の最大値のマス(複数の場合、ランダムで選ぶ)
  private PVector[] getMaxPoint() {
    int x, y, max=getMaxPointNum(), i=0;
    PVector[] pos=new PVector[this.sizeX*this.sizeY];
    for (y=0; y<this.sizeY; y++) {
      for (x=0; x<this.sizeX; x++) {
        //     print(checkNum(x,y));
        if (checkNum(x, y)==max) {
          pos[i]=new PVector(x, y);
          i++;
        }
      }
    }

    return pos;
  }
  //-----------------------------------------------------------------------------------------------
  //AI2 最大優先度のマスを選ぶ
  //-----------------------------------------------------------------------------------------------
  public void AI2() {
    //選べる座標の取得
    PVector pos=getMaxExpect()[(int)random(getMaxExpectNum())];
    //駒を置く裏返せる駒も裏返す)、手番交代
    play((int)pos.x, (int)pos.y);
  }
  //評価関数最大値
  private int getMaxExpectMax() {
    int max=-100;
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y)&&this.EXPECT[y][x]>=max)max=EXPECT[y][x];
    return max;
  }
  //評価関数最大値の数
  private int getMaxExpectNum() {
    int sum=0;
    final int max=getMaxExpectMax();
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y)&&this.EXPECT[y][x]>=max)sum++;
    return sum;
  }
  //評価関数最大値のマス（複数場合、ランダムで選ぶ）
  private PVector[] getMaxExpect() {
    int i=0;
    final int max=getMaxExpectMax();
    PVector[] pos=new PVector[this.sizeX*this.sizeY];
    for (int y=0; y<this.sizeY; y++) {
      for (int x=0; x<this.sizeX; x++) {
        if (check(x, y)&&this.EXPECT[y][x]==max) {
          pos[i]=new PVector(x, y);
          i++;
        }
      }
       }
    return pos;
  }
  //-----------------------------------------------------------------------------------------------
  //AI3 全盤面の評価関数がとれる最大値のマスを選ぶ
  //-----------------------------------------------------------------------------------------------
  public void AI3() {
    //選べる座標の取得
    PVector pos=getExpectSum()[(int)random(getExpectSumNum())];
    println(getExpectSumMax());
    //駒を置く裏返せる駒も裏返す)、手番交代
    play((int)pos.x, (int)pos.y);
  }
  //全盤面の評価関数がとれる最大値
  private int getExpectSumMax() {
    int max=-1000;
    int abc[][]=new int[this.sizeY][this.sizeX];
     for (int y=0; y<this.sizeY; y++) for (int x=0; x<this.sizeX; x++)abc[y][x]=0;
    int temp[][]=new int[this.sizeY][this.sizeX];
    for (int y=0; y<this.sizeY; y++) for (int x=0; x<this.sizeX; x++) temp[y][x]=this.data[y][x];
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y)) {
      boardUpdate(x, y);
      this.turn=1-this.turn;
      max=max(max, getPoint());
    abc[y][x]=getPoint();
      
      for (int j=0; j<this.sizeY; j++) for (int i=0; i<this.sizeX; i++)this.data[j][i]=temp[j][i];
      }
        
     for (int j=0; j<this.sizeY; j++){ for (int i=0; i<this.sizeX; i++){
       print(abc[j][i]+" ");
     }
   println();  
   }   
     
    return max;
  }
  //全盤面の評価関数がとれる最大値の数
  private int getExpectSumNum() {
    int num=0;
    final int max=getExpectSumMax();
    int temp[][]=new int[this.sizeY][this.sizeX];
    for (int y=0; y<this.sizeY; y++) for (int x=0; x<this.sizeX; x++) temp[y][x]=this.data[y][x];
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y)) {
      boardUpdate(x, y);
      this.turn=1-this.turn;
      if (max==getPoint())num++;

      for (int j=0; j<this.sizeY; j++) for (int i=0; i<this.sizeX; i++)this.data[j][i]=temp[j][i];
    }
    return num;
  }
  //全盤面の評価関数がとれる最大値のマスを選ぶ(複数場合、ランダムで選ぶ）
  private PVector[] getExpectSum() {
    int num=0;
    final int max=getExpectSumMax();
    int temp[][]=new int[this.sizeY][this.sizeX];
    for (int y=0; y<this.sizeY; y++) for (int x=0; x<this.sizeX; x++) temp[y][x]=this.data[y][x];
    PVector[] pos=new PVector[this.sizeX*this.sizeY];
    for (int y=0; y<this.sizeY; y++)for (int x=0; x<this.sizeX; x++)if (check(x, y)) {
      boardUpdate(x, y);
      this.turn=1-this.turn;
      if (max==getPoint()) {
        pos[num]=new PVector(x, y);
        num++;
      }
      for (int j=0; j<this.sizeY; j++) for (int i=0; i<this.sizeX; i++)this.data[j][i]=temp[j][i];
    }   
    return pos;
  }
  //全盤面の評価関数をとれた値
  private int getPoint()
  {
    int point = 0;
    for (int y = 0; y < sizeY; y++)for (int x = 0; x < sizeX; x++)
    {
      if (this.data[y][x] == turn+1)point += EXPECT[y][x];   //今の手番と合ってるなら、+
      if (this.data[y][x] == 3 -(turn+1)) point -= EXPECT[y][x];   //-
    }
    return point;
  }
  //-----------------------------------------------------------------------------------------------
  //AI4 全盤面の評価関数がとれる最大値のマスを選ぶ(次に相手が駒を置いた後の状況も考える場合)(複数場合、ランダムで選ぶ）
  //三、四回後の状況も計算したいけど、再帰の部分に苦しくて諦めた。
  //-----------------------------------------------------------------------------------------------
  public void AI4() {
    int tempt = this.turn;
    int depth =4, max=-1000;
    int[][] record=new int[this.sizeY][this.sizeX];        //全盤面の評価関数の変化値
    int[][] temp=new int[this.sizeY][this.sizeX] ;
    for (int y = 0; y < this.sizeY; y++) for (int x = 0; x < this.sizeX; x++) record[y][x] = -1000;
    for (int y = 0; y < this.sizeY; y++) for (int x = 0; x < this.sizeX; x++) temp[y][x] = this.data[y][x];
    for (int y = 0; y < this.sizeY; y++)for (int x = 0; x < this.sizeX; x++)if (check(x, y)) {
      boardUpdate(x, y);
      //現在選べる座標に全盤面の評価関数の変化値を記録する
      record[y][x]=saiki(x, y, tempt, depth);
      //最大値の記録
      max=max(record[y][x], max);
      //手番を戻る
      turn = 1 - turn;
      //盤面データを戻る
      for (int j = 0; j < this.sizeY; j++) for (int i = 0; i < this.sizeX; i++)this.data[j][i] = temp[j][i];
    }
    //選べる座標の記録
    int num=0;
    PVector[] pos=new PVector[this.sizeY*this.sizeX];  
    for (int y = 0; y < this.sizeY; y++) {
      for (int x = 0; x < this.sizeX; x++) {
        if (max==record[y][x]) {
          pos[num]=new PVector(x, y);
          
          num++;//println(max);
        }
        print(record[y][x]+" ");
      }
      println();
    }
    println(-getPoint());
    //選べる座標の取得
    PVector pos_=pos[(int)random(num)];
    //駒を置く裏返せる駒も裏返す)、手番交代
    play((int)pos_.x, (int)pos_.y);
  }
  //
  private int saiki(int x_, int y_, int tempt, int depth) {
    int num=-getPoint();
    if (depth==0)return num;
   
    int max=-1000;
    int[][] temp=new int[this.sizeY][this.sizeX] ;
    for (int y = 0; y < this.sizeY; y++) for (int x = 0; x < this.sizeX; x++) temp[y][x] = this.data[y][x];
    for (int y = 0; y < this.sizeY; y++)for (int x = 0; x < this.sizeX; x++)if (check(x, y)) {
      boardUpdate(x, y);
        if (this.turn!=tempt &&max<num) {
          max=num;       //保存された手番と同じなら、最大値を取る
        } else if(this.turn==tempt &&max<-num) {
          max=-num;  //最小値
        }
      
      //手番を戻る
      turn=1-turn;
      //盤面データを戻る
      for (int j = 0; j < this.sizeY; j++) for (int i = 0; i < this.sizeX; i++)this.data[j][i] = temp[j][i];
    } 
    //num+=max;
    return max;
  }
  /*テスト用関数、ソースコードを入力して中途半端です!
  void testAI(int turn,int depth,int alpth,int beta){
    int maxRank=0;
    PVector bestMove=new PVector(-1,-1);
    int bestMoveRank=-turn*maxRank;
    //int validMoves
    int xStart=(int)random(this.sizeX);
    int yStart=(int)random(this.sizeY);
    int i,j;
    for(j=0;j<this.sizeY;j++)for(i=0;i<this.sizeX;i++){
      int y=(yStart+j)%8;
      int x=(xStart+i)%8;
      if(check(x,y)){
        if(depth==1){//?????this.BeginInvoke(new UpdateStatusProgressDelegate(this.UpdateStatusProgress));
          PVector testMove=new PVector(x,y);
          int[][] testData=new int[this.sizeY][this.sizeX];
          for(int j_=0;j<this.sizeY;j++)for(int i_=0;i_<this.sizeX;i_++)testData[j_][i_]=data[j_][i_];
      }
  
    }
  }*/
  public void setAI(int ai) {
    this.ai=ai;
  }
  public int getAI() {
    return this.ai;
  }
  public boolean sameTurn() {
    return this.turn==this.t;
  }
  public int getT(){
    return this.t;
  }
  public int getSize() {
    return this.sizeX;
  }
}