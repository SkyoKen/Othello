//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
//┃ボタン                                                                               　┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
public class Button {
  private float x, y, w, h;       //描画座標
  private color c;                //色
  private String message;         //文字
  private int size;
  private boolean changeColor;
  public Button(int x, int y, int w, int h, String message) {
    this.x=x;                  //座標x
    this.y=y;                  //座標y
    this.w=w;                  //座標w
    this.h=h;                  //座標h
    this.message=message;      //文字
    this.c=color(255);         //色
    this.size=32;
    this.changeColor=false;
  }
  public Button(int x, int y, int w, int h, String message, int size) {
    this(x, y, w, h, message);
    this.size=size;
  }
  //画像表示
  public void update() {
    pushMatrix();
    translate(this.x, this.y);
    //矩形表示
    fill(changeColor()); //接触すると変色
    fill(clickedColor());
    stroke(0);
    rectMode(CENTER);
    rect(0, 0, this.w, this.h);
    //文字表示
    textAlign(CENTER, CENTER);  
    fill(0);
    textSize(this.size);
    text(this.message, 0, -this.size/4);
    popMatrix();
  }
  //画像表示
  public void updateEllipse() {
    pushMatrix();
    translate(this.x, this.y);
    //矩形表示
    stroke(0);
    line(-this.w/2, -this.w/2, this.w/2, -this.w/2);
    stroke(126);
    line(this.w/2, -this.w/2, this.w/2, this.w/2);
    stroke(255);
    line(this.w/2, this.w/2, -this.w/2, this.w/2);
    //円形表示
    fill(changeColor()); //接触すると変色
    fill(clickedColor());
    stroke(clickedColor());
    ellipseMode(CENTER);
    ellipse(0, 0, this.w/6*5, this.w/6*5);
    //文字表示
    fill(0);
    textAlign(CENTER, CENTER);  
    textSize(this.size);
    text(this.message, 0, -this.size/4);
    popMatrix();
  }
  //接触判定
  boolean contact(int x_, int y_) {
    return x_>this.x-this.w/2 &&x_<this.x+this.w/2 && y_>this.y-this.h/2 && y_<this.y+this.h/2;
  }
  //矩形　色が変わる
  private color changeColor() {
    return this.c=contact(mouseX, mouseY)?color(125):color(255);
  }
  //押す　判定
  public boolean clicked() {
    return mouseButton==LEFT && contact(mouseX, mouseY);
  }
  public color clickedColor() {
    return changeColor?color(125):this.c;
  }
  public void isChangeColor() {
    this.changeColor=!this.changeColor;
  }
  public void isChangeColor(color c) {
    this.changeColor=false;
  }
}
