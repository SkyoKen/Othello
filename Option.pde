
//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃オプション                                                                         　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Option {
  private Button backbtn;            //BACK ボタン
  private Button OKbtn;              //OK ボタン
  private Button[] AIbtn;            //AIボタン
  private Button[] sizebtn;
  private Button[] turnbtn;
  private final int nameMax=7;
  private int ai;
  private int size;
  private int turn;
  private String[] name=new String[this.nameMax];
  private String[] aimsg={"1.AI0:\n選べるマスからランダムで選びます。", "2.AI1:\n裏返せる駒の最大値のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます。", "3.AI2:\n最大優先度のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます。", "4.AI3:\n全盤面の評価関数がとれる最大値のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます。\n(駒を置いた後の評価関数を計算します。「同色のは加算、異色のは減算」)", "5.AI4:\n全盤面の評価関数がとれる最大値のマス(次に相手が駒を置いた後の状況も考える場合)を探して、複数の結果を取った場合、結果の中でランダムで選びます", "6.P2:\n二人対戦"};
  private int nameNum;
  public Option() {
    //okbtn
    this.OKbtn=new Button(width/4*3, int(height/8*6.4), height/8*5, height/12, "OK", height/15);     
    //backbtn
    this.backbtn=new Button(width/4*3, int(height/8*7.2), height/8*5, height/12, "BACK", height/15);                //BACK　ボタンの生成
    //aibtn
    this.AIbtn=new Button[6];
    for (int i=0; i<6; i++) {
      this.AIbtn[i]=new Button(width/7*(i+1), height/4, height/5, height/4, AIName[i], height/15);
    }
    this.AIbtn[5].isChangeColor();
    this.ai=5;
    //sizebtn  
    this.sizebtn=new Button[3];
    for (int i=0; i<3; i++) {
      this.sizebtn[i]=new Button(width/8*(i+1), height/8*7, height/5, height/10, 2*(i+2)+"x"+2*(i+2), height/15);
    }
    this.sizebtn[2].isChangeColor();
    this.size=2;
    //turnbtn
    this.turnbtn=new Button[2];
    for (int i=0; i<2; i++) {
      this.turnbtn[i]=new Button(width/8*(i+1), height/8*6, height/5, height/10, i==0?"先手":"後手", height/15);
    }
    this.turnbtn[0].isChangeColor();
    this.turn=0;
    //名前
    for (int i=0; i<this.nameMax; i++) {
      name[i]="?";
    }
  }
  //「実行」１フレーム毎に行う処理
  public void update() {
    for (int i=0; i<6; i++) {
      this.AIbtn[i]. updateEllipse();
    }
    for (int i=0; i<3; i++) {
      this.sizebtn[i]. update();
    }
    for (int i=0; i<2; i++) {
      this.turnbtn[i]. update();
    }
    //メッセージ
    information();
    //BACKボタン
    backbtn.update();
    OKbtn.update();
  }
  //------------------------------------------------------------------------------
  //メッセージ
  //------------------------------------------------------------------------------
  private void information() {
    //背景
    fill(255, 255, 255, 125);
    //文字サイズと色設定
    fill(255, 0, 0);
    textSize(64);
    //メッセージ表示
    showAI();
    showMsg();
  }
  //AI紹介
  private void showAI() {
    pushMatrix();
    translate(width/3, height/8*7);
    textAlign(LEFT, TOP);
    fill(255);
    textSize(height/30);
    text(aimsg[this.ai], 0, 0, width/2, height);
    popMatrix();
  }
  private void showMsg() {
    String name_="";
    for (String sth : this.name) {
      name_+=sth;
    }  
    textAlign(LEFT, CENTER);
    fill(255);
    textSize(height/20);
    text("対戦相手", height/8, height/10);
    //書き込みからの座標
    pushMatrix();
    translate(width/2, height/2-height/15);


    textSize(height/30);
    text("　　　　　名前を入力してください(英数字):", 0, 0);
    translate(0, height/15);
    line(width/8, 0, width/8*3, 0);
    stroke(126);
    line(width/8*3, 0, width/8*3, height/15*3);
    stroke(255);
    line(width/8*3, height/15*3, width/8, height/15*3);
    stroke(0);
    translate(width/4, height/32);
    textAlign(CENTER, CENTER);
    text(name_ +" VS "+(this.ai==5?"P2":"AI"+this.ai), 0, 0);
    text("手番："+(this.turn==0?"先手":"後手"), 0, height/15);
    text("盤面："+2*(this.size+2)+"x"+2*(this.size+2), 0, height/15*2);
    popMatrix();
  }
  private void changeName() {
    if (key==BACKSPACE) {
      this.name[this.nameNum]="?";
      this.nameNum=max(0, --this.nameNum);
    }
    if (!((key>='a'&&key<='z')||(key>='A'&&key<='Z')||(key>='0'&&key<='9')||key==' '))return;
    this.name[this.nameNum]=String.valueOf(key);
    this.nameNum=min(this.nameMax-1, ++this.nameNum);
  }
  private void key() {
    if (keyCode==112) {
      Task=GAME;
    }
    changeName();
  }
  private void btn() {
    for (int i=0; i<6; i++) {
      if (AIbtn[i].clicked()) {
        game.setAIName(AIName[i]);
        this.ai=i;
        AIbtn[i].isChangeColor();
        for (int j=0; j<6; j++) {
          if (i!=j)AIbtn[j].isChangeColor(0);
        }
      }
    }
    for (int i=0; i<3; i++) {
      if (sizebtn[i].clicked()) {
        this.size=i;
        sizebtn[i].isChangeColor();
        for (int j=0; j<3; j++) {
          if (i!=j)sizebtn[j].isChangeColor(0);
        }
      }
    }
    for (int i=0; i<2; i++) {
      if (turnbtn[i].clicked()) {
        this.turn=i;
        turnbtn[i].isChangeColor();
        for (int j=0; j<2; j++) {
          if (i!=j)turnbtn[j].isChangeColor(0);
        }
      }
    }
    if (backbtn.clicked())Task=TITLE;
    if (OKbtn.clicked())OK();
  }
  private void OK() {
    String playerName="";
    for (String sth : this.name) playerName+=sth;
    game.setAIName(this.ai==5?"P2":"AI"+this.ai);
    if (!playerName.equals("???????"))game.setPlayerName(playerName);
    game.board.setAI(this.ai);
    if (game.board.getSize()!=2*(this.size+2))reStart();
    Task=GAME;
  }
  public int getAI() {
    return this.ai;
  }
  public int getSize() {
    return 2*(this.size+2);
  }
  public int getTurn() {
    return this.turn;
  }
  public void reStart() {
    game.setSize(2*(this.size+2));
  }
}
