//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃タイトル                                                                  　　         　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Title {
  private Button startbtn;        //START ボタン
  private Button introductionbtn;      //INTRODUCTION ボタン
  private Button exitbtn;      //EXIT ボタン
  public Title() {
    this.startbtn=new Button(width/2, height/8*5/*320*/, height/8*5, height/12, "START",height/15);                  //BACK　ボタンの生成
    this.introductionbtn=new Button(width/2, int(height/8*5.8), height/8*5, height/12, "INTRODUCTION",height/15);        //INTRODUCTION　ボタンの生成
    this.exitbtn=new Button(width/2, int(height/8*6.6), height/8*5, height/12, "EXIT",height/15);                    //EXIT　ボタンの生成
  } 
 //「実行」１フレーム毎に行う処理 
  public void update() {
    startbtn.update();
    introductionbtn.update();
    exitbtn.update();
    showTitle();
  }
  private void showTitle() {
    pushMatrix();
    translate(width/2, height/4);
    pushMatrix();
    
    translate(-width/2, -height/7);
    line(0, 0, width-2, 0);
    stroke(126);
    line(width-2, 0, width-2, height/4);
    stroke(255);
    line(width-2, height/4, 0, height/4);
    stroke(0);
    popMatrix();

    
    textAlign(CENTER, CENTER);  
    fill(255);
    textSize(height/4);
    text("Othello", 0, -height/15);
    popMatrix();
  }
  private void start_(){
    game.reStart();
    Task=OPTION;
  }
  public void key() {
    if (keyCode==112){  start_();  
  }
  }
  public void btn() {
    if (startbtn.clicked())start_();
    if (introductionbtn.clicked())Task=INTRODUCTION;
    if (exitbtn.clicked())exit();
  }
}