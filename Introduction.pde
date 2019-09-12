
//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃ゲーム説明                                                                         　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Introduction {
  private Button backbtn;
  private Button nextbtn;
  private Button prebtn;
  private int page=0;
  private PImage[] img=new PImage[4];
  private String[] ai={"1.AI0:", "選べるマスからランダムで選びます。", "2.AI1:", "裏返せる駒の最大値のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます・", "3.AI2:", "最大優先度のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます。", "4.AI3:", "全盤面の評価関数がとれる最大値のマスを探して、複数の結果を取った場合、結果の中でランダムで選びます。\n(駒を置いた後の評価関数を計算します。「同色のは加算、異色のは減算」)", "5.AI4:", "全盤面の評価関数がとれる最大値のマス(次に相手が駒を置いた後の状況も考える場合)を探して、複数の結果を取った場合、結果の中でランダムで選びます"};
  private String[] msg={"ゲーム勝敗", "プレイが終了した時点で、自分の色の駒が多い方が勝ち","\nゲーム注意点：\n※オプションの画面で、AI,手番、盤面サイズが変更可能ですが、混乱させないため、盤面サイズを変更しないと手番を変更することができません。\n※ゲーム途中でAIが変更可能です。", "遊び方", "黒が先手でゲームを開始します。交互に相手の駒を挟んで裏返し、盤上が駒で全部埋まるか両者が手詰まりになるまで続けます。", "ルール", "●ゲーム開始時の駒の配置は右図になります。", "●自分のプレイの時は、必ず相手の駒を挟むように駒を置いてください。それができない場合はパスとなり、自分の番は飛ばされます。なお、挟めるところがある限りは、自主的にパスはできません。", "●挟んだ駒が縦・横・斜めに複数箇所にある場合、すべての方向の駒を裏返します。（右上図は例です。Aの①に白駒を置くと、矢印部分すべての駒を裏返します。）", "●右下図の白駒のように、隅にある駒は、挟むことができません", "●右図のように、端に白駒があった場合、Bの位置に黒駒を置いても、挟んだことになりません。（三方から囲んでも挟んだことにはなりません。）"};
  public Introduction() {
    for (int i=0; i<4; i++) {
      this.img[i]=loadImage("./data/zu"+(i+1)+".jpg");
    }
    this.backbtn=new Button(width/10, height/10*9, width/8, height/12, " BACK", height/15);                //BACK　ボタンの生成
    this.nextbtn=new Button(width/10*9, height/10*9, height/10, height/12, "▶", height/15);                //NEXT　ボタンの生成
    this.prebtn=new Button(width/12*10, height/10*9, height/10, height/12, "◀", height/15);                //PRE　ボタンの生成
  }
  public void update() {
    fill(255);
    textSize(height/20);
    textAlign(CENTER, CENTER);
    text((this.page+1)+"/9", width/2, height/10*9);
    switch(this.page) {
    case 0:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text(this.msg[0], width/2, height/10*2);
      textSize(height/15);
      text(this.msg[1], width/2, height/10*4.5);
      textAlign(LEFT, CENTER);
      textSize(height/32);
      text(this.msg[2], width/2, height/3*2,width/4*3,height/8*3);
     
      break;
    case 1:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text(this.msg[3], width/2, height/10*2);
      textAlign(LEFT, CENTER);
      textSize(height/20);
      text(this.msg[4], width/2, height/2, width/4*3, height/8*3);
      break;
    case 2:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text(this.msg[5], width/2, height/10);
      textAlign(LEFT, CENTER);
      textSize(height/20);
      text(this.msg[6], width/8*3, height/10*2.5, width/2, height);
      text(this.msg[7], width/8*3, height/10*6, width/2, height);
      image(this.img[0], width/4*2.5, height/4, height/2, height/2);
      break;
    case 3:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text(this.msg[5], width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.msg[8], width/8*3, height/10*4.5, width/2, height);
      image(this.img[1], width/4*2.5, height/4, height/2, height/2);
      break;
    case 4:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text(this.msg[5], width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.msg[9], width/8*3, height/10*3, width/2, height);
      text(this.msg[10], width/8*3, height/10*6, width/2, height);
      image(this.img[2], width/4*2.5, height/4, height/2, height/5);
      image(this.img[3], width/4*2.5, height/2, height/2, height/5);
      break;
    case 5:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text("AI", width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.ai[0], width/2, height/10*2.5, width/4*3, height);
      text(this.ai[1], width/2, height/10*3.5, width/4*3, height);
      text(this.ai[2], width/2, height/10*4.5, width/4*3, height);
      text(this.ai[3], width/2, height/10*6, width/4*3, height);
      break;
    case 6:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text("AI", width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.ai[4], width/2, height/10*2.5, width/4*3, height);
      text(this.ai[5], width/2, height/10*4, width/4*3, height);
      break;
    case 7:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text("AI", width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.ai[6], width/2, height/10*2.5, width/4*3, height);
      text(this.ai[7], width/2, height/10*5, width/4*3, height);
      break;
    case 8:
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text("AI", width/2, height/10);
      textSize(height/20);
      textAlign(LEFT, CENTER);
      text(this.ai[8], width/2, height/10*2.5, width/4*3, height);
      text(this.ai[9], width/2, height/10*4.5, width/4*3, height);
      break;
    }
    this.backbtn.update();
    this.nextbtn.update();
    this.prebtn.update();
  }
  public void key() {
     if(keyCode==112){Task=OPTION;}
  }
  public void btn() {
    if (backbtn.clicked())Task=TITLE;
    if (nextbtn.clicked())this.page=min(++this.page, 8);
    if (prebtn.clicked())this.page=max(--this.page, 0);
  }
 }
