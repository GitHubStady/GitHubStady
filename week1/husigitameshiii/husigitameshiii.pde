PImage shop, house, danzyon, shop2, house2, danzyon2;
int kanri;
void setup() {
  kanri=1;
  PFont font = createFont("Meiryo", 40);
  textFont(font);
  size(960, 600);//960
  areaCount=0;
  shop=loadImage("店.png");
  house=loadImage("自宅.png");
  danzyon=loadImage("ダンジョン.png");
  shop2=loadImage("店2.png");
  house2=loadImage("自宅2.png");
  danzyon2=loadImage("ダンジョン2.png");
}
int php=15;
void draw() {
  // println(kanri);
  if (kanri==0) {
    home();
  } else if (kanri==1) {

    background(0);
    generateField();
  } else if (kanri==2) {
    shop();
  } else if (kanri==3) {
    house();
  }
}
