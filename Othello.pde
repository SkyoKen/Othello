//-----------------------------------------------------------------------------
//タイトル：  オセロ (マウス操作)
//作成者：    SkyoKen
//作成日：    2018/12/07
//修正日：    2018/12/20
//-----------------------------------------------------------------------------
//●ソースコードが整理されてない状態です。

//ゲーム注意点：
//※オプションの画面で、AI,手番、盤面サイズが変更可能ですが、混乱させないため、盤面サイズを変更しないと手番を変更することができません。
//※ゲーム途中でAIが変更可能です。
//-----------------------------------------------------------------------------
import java.util.Arrays;
final int NONE=0;            //空
final int BLACK=1;           //黒
final int WHITE=2;           //白
final int TURNB=0;           //手番　黒
final int TURNW=1;           //手番　白
String[] AIName={"AI0","AI1","AI2","AI3","AI4","P2"};  

PFont font;                  //文字フォント
int Task;
final int TITLE =0;
final int GAME=1;
final int OPTION=2;
final int INTRODUCTION=3;

boolean pressKey=false;
boolean pressMouse=false;
Title title;
Game game;
Option option;
Introduction introduction;
//-----------------------------------------------------------------------------
//「初期化」タスク生成時に１回だけ行う処理
//-----------------------------------------------------------------------------
void setup() {
  fullScreen();
  //size(960, 540);           //ウインドウ設定
   strokeWeight(height/540*2);  
 
  fill(0, 0, 0);              //塗りつぶし初期値
  //font = createFont("MS Gothic", height*0.1, true);
  font = createFont("./data/mplus-1m-medium.ttf", 1);
  textFont(font);
  title=new Title();
  option=new Option();
  game=new Game();
  introduction=new Introduction();
  Task=TITLE;
}

//-----------------------------------------------------------------------------
//「実行」１フレーム毎に行う処理
//-----------------------------------------------------------------------------
void draw() {
  background(107, 142, 35);            // 背景の初期化(フラッシュ)
  update();
}

//-----------------------------------------------------------------------------
//「キーボードから指が離れたときに呼び出される関数」
//-----------------------------------------------------------------------------
void keyReleased() {
  pressKey=!pressKey;
 switch(Task) {
  default:
    break;
  case INTRODUCTION:
    introduction.key();
    break;
  case OPTION:
    option.key();
    break;
  case GAME:
    game.key();
    break;
  case TITLE:
    title.key();
    break;
  }
 pressKey=false;
}
//-----------------------------------------------------------------------------
//「マウスボタンから指が離れたときに呼び出される関数」
//-----------------------------------------------------------------------------

void mouseReleased() {
  pressMouse=!pressKey;
  switch(Task) {
  default:
    break;
  case INTRODUCTION:
    introduction.btn();
    break;
  case OPTION:
    option.btn();
    break;
  case GAME:
    game.btn();
    break;
  case TITLE:
    title.btn();
  }
  pressMouse=false;
}

void update() {
  switch(Task) {
  case TITLE:
    title.update();
    break;
  case GAME:
    game.update();
    break;
  case OPTION:
    option.update();
    break;
  case INTRODUCTION:
    introduction.update();
    break;
  default:
    break;
  }
}