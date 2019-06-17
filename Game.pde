//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃ゲーム本編                                                                  　　         　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Game {
  private Board board;                //ゲーム盤
  private Button optionbtn;              //リセット　ボタン
  private Button backbtn;              //リセット　ボタン
  private Button restartbtn;              //リセット　ボタン
  private boolean over;
  private int sizeX, sizeY;
  private float d;
  private String playerName;
  private String AIName;
  private String[] overMsg = { "引き分け", "黒勝", "白勝" };
  //-----------------------------------------------------------------------------
  //「初期化」タスク生成時に１回だけ行う処理
  //-----------------------------------------------------------------------------
  public Game() {
    //ゲーム盤の生成
    this.board = new Board();
    this.restartbtn=new Button(width/8*7, height/8*5, height/4, height/12, "RESTART", height/15);    
    this.optionbtn=new Button(width/8*7, height/8*6, height/4, height/12, "OPTION", height/15);
    this.backbtn=new Button(width/8*7, height/8*7, height/4, height/12, "BACK", height/15);
    setSize(option.getSize());
  
    this.playerName="Player";
    this.AIName="AI";
  }
  //-----------------------------------------------------------------------------
  //「実行」１フレーム毎に行う処理
  //-----------------------------------------------------------------------------
  public void update() {
    //ゲーム盤
    this.board.update();
    //ゲーム情報
    showInfo();
    this.restartbtn.update();
    this.optionbtn.update();
    this.backbtn.update();
    this.over=board.checkOver();
  }
  private void showInfo() {
    float d= height/6;

    pushMatrix();
    translate(width/6*0.8, height/2-height/5);
    stroke(0);
    line(-d, -d, d, -d);
    stroke(126);
    line(d, -d, d, d);
    stroke(255);
    line(d, d, -d, d);
    textSize(d/3);
    fill(255);
    stroke(255);
    ellipseMode(CENTER);
    ellipse(0, 0, height/4, height/4);
    fill(0);
    text(board.getT()==TURNB?this.AIName:this.playerName, 0, 0);
    popMatrix();

    pushMatrix();
    translate(width/6*0.8, height/2+height/5);
    stroke(0);
    line(-d, -d, d, -d);
    stroke(126);
    line(d, -d, d, d);
    stroke(255);
    line(d, d, -d, d);
    textSize(d/3);
    fill(0);
    stroke(0);
    ellipseMode(CENTER);
    ellipse(0, 0, height/4, height/4);
    fill(255);
    text(board.getT()==TURNB?this.playerName:this.AIName, 0, 0);
    popMatrix();

    pushMatrix();
    translate(width/4*3+width/24, height/15);
    line(0, 0, width/6, 0);
    stroke(126);
    line(width/6, 0, width/6, height/15*2);
    stroke(255);
    line(width/6, height/15*2, 0, height/15*2);
    stroke(0);
    textSize(height/30*2);
    textAlign(CENTER, CENTER);
    fill(board.getTurn()==TURNB?0:255);
    text(board.getTurn()==TURNB?"黒":"白", height/30*4, height/30*2);
    translate(0, height/15*2.5);
    line(0, 0, width/6, 0);
    stroke(126);
    line(width/6, 0, width/6, height/15*2);
    stroke(255);
    line(width/6, height/15*2, 0, height/15*2);
    stroke(0);
    textSize(height/30);
    fill(255);
    int[] score=board.getScore();
    text("空:"+score[0]+"\n黒:"+score[BLACK]+"　白:"+score[WHITE], height/30*4, height/30*2);
    translate(0, height/15*2.5);
    line(0, 0, width/6, 0);
    stroke(126);
    line(width/6, 0, width/6, height/15*2);
    stroke(255);
    line(width/6, height/15*2, 0, height/15*2);
    stroke(0);
    fill(255);
    textSize(height/30*1.5);
    text(check(), height/30*4, height/30*2);
    popMatrix();
  }
  //btn
  private void option() {
    Task=OPTION;
  }
  private void reStart() {
      this.over=false;
    board.NewGame();             //ゲーム盤リセット
  }
  private void back() {
    Task=TITLE;
  }
  private void btn() {
    //リセットボタンが押されたらゲームリセットする
    if (this.restartbtn.clicked()) {
      reStart();
    } else if (this.backbtn.clicked()) {
      back();
    } else if (this.optionbtn.clicked()) {
      option();
    }
    if ( mouseButton == LEFT) L();
  }
  private void L() {
    //範囲確認
    float sx=width/2-this.d*this.sizeX/2;
    float sy=height/2-this.d*this.sizeY/2;
    PVector pos=new PVector(mouseX, mouseY);
    if (pos.x >= 0+sx && pos.x <this.d*this.sizeX+sx &&
      pos.y >= 0+sy && pos.y < this.d*this.sizeY+sy) {
      //マス単位の座標に変える
      int x=(int)((pos.x-sx)/this.d);
      int y=(int)((pos.y-sy)/this.d);
      if (!this.over&&board.sameTurn()||(!board.sameTurn()&&board.getAI()==5)) {
        board.play(x, y);board. showBoard();//board.AI4();
       // println();
      //  println(board.getPoint());
      }
    }
  }
  private void key() {
    if (keyCode==112) {
      Task=TITLE;
    }
  }
  private String check() {
    if (this.over)return overMsg[board.getWinner()];
    return "PLAY";
  }
  public void setPlayerName(String playerName) {
    this.playerName=playerName;
  } 
  public void setAIName(String AIName) {
    this.AIName=AIName;
  }
  public String getAIName() {
    return this.AIName;
  }
  public void setSize(int size) {
    this.sizeX=size;
    this.sizeY=size;
    this.d=height/(this.sizeX+3);
    reStart();
  }
}