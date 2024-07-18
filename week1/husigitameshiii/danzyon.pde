class chara1 {//キャラクター
  int x, y;
  int hp, maxhp, atk;
  // int exp, lv, atk, def, hp, mp, mtk, mdef;
  chara1(int x, int y) {
    this.x=x;
    this.y=y;
  }
  void status(int maxhp, int hp, int atk) {
    this.maxhp=maxhp;
    this.hp=hp;
    this.atk=atk;
  }
  void battle() {
  }
}
chara1 ply;
chara1 enemy;

int field_width=73, field_height=64;
int areamax=32;
int areaSizemin=12;
int areaCount;
int screenw=10, screenh=7;
AREA areas[]=new AREA[areamax];

class ROOM {//ルーム
  int x, y, w, h;
  ROOM(int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }
}
class AREA {//エリア
  int x, y, w, h;
  AREA(int ax, int ay, int aw, int ah) {
    this.x=ax;
    this.y=ay;
    this.w=aw;
    this.h=ah;
  }
  //エリアを分ける
  void spritArea(int areaidx) {
    int newAreaidx=areaCount;
    int w=areas[areaidx].w;
    int h=areas[areaidx].h;
    // int rnd=int(random(0,1));
    if (areaCount%5==1||areaCount%5==3) { 
      areas[areaidx].w/= 2;
      areas[areaidx].w+= int(random(1, 8));
      areas[newAreaidx]=new AREA(areas[areaidx].x+areas[areaidx].w, areas[areaidx].y, w-areas[areaidx].w, areas[areaidx].h);
    } else if (areaCount%5==0||areaCount%5==2||areaCount%5==4) {
      areas[areaidx].h/= 2; 
      areas[areaidx].h+= int(random(1, 6));
      areas[newAreaidx]=new AREA(areas[areaidx].x, areas[areaidx].y+areas[areaidx].h, areas[areaidx].w, h-areas[areaidx].h);
    }
    if ((areas[areaidx].w<areaSizemin)||(areas[areaidx].h<areaSizemin)||(areas[newAreaidx].w<areaSizemin)||(areas[newAreaidx].h<areaSizemin)) {
      areas[areaidx].w=w; 
      areas[areaidx].h=h;
      return;
      // areaCount--;
    }
    areaCount++;
    spritArea(areaidx);
    spritArea(newAreaidx);
  }
  ROOM room;
}

//エリアが出来ているかを見る
void displayArea() {
  textSize(8);
  int [][]buf=new int[field_width][field_height];
  for (int i=0; i<areaCount; i++) {
    for (int y=areas[i].y; y<areas[i].y+areas[i].h; y++) {
      for (int x=areas[i].x; x<areas[i].x+areas[i].w; x++) {
        buf[x][y]=i;
      }
    }
  }
  for (int y=0; y<field_height; y++) {
    for (int x=0; x<field_width; x++) {
      if (buf[x][y]<10) {
        textSize(8);
        text(buf[x][y], 560+float(x*9), float(y*9));
      } else  if (buf[x][y]>=10) {
        textSize(6);
        text(buf[x][y], 560+float(x*9), float(y*9));
      }
    }
  }
}
int nonono=0;
int west[]=new int[areamax], east[]=new int[areamax], south[]=new int[areamax], north[]=new int[areamax];
String [][]field=new String[field_width][field_height];
int roadrandom[]=new int[areamax];
int banArea[]=new int[areamax];
int banCount, c;
void disRoom() {//roomを作る

  if (nonono<1) { //通路をランダムに作る
    for (int i=0; i<areaCount; i++) {
      west[i]=int(random(-areaSizemin/2, areaSizemin/2)); 
      east[i]=int(random(-areaSizemin/2, areaSizemin/2)); 
      south[i]=int(random(-areaSizemin/2, areaSizemin/2)); 
      north[i]=int(random(-areaSizemin/2, areaSizemin/2));

      roadrandom[i]=int(random(0, 2));
    }
    banCount=0;
    for (int k=0; k<2; k++) {
      banArea[k]=int(random(0, areaCount));
      banCount++;
    }
    nonono++;
    c=banCount;
  }
  banCount=c;
  //全てを壁
  for (int y=0; y<field_height; y++) {
    for (int x=0; x<field_width; x++) {
      field[x][y]=cell[1];
    }
  }
  //roomを描画
  for (int i=0; i<areaCount; i++) {
    for (int y=areas[i].room.y; y<areas[i].room.y+areas[i].room.h; y++) {
      for (int x=areas[i].room.x; x<areas[i].room.x+areas[i].room.w; x++) {
        field[x][y]=cell[0];
      }
    }
    //roomの上下左右に通路を作る
    for (int x=areas[i].x; x<areas[i].x+areas[i].w; x++) {
      field[x][areas[i].y+areas[i].h-1]=cell[0];
    }
    for (int y=areas[i].y; y<areas[i].y+areas[i].h; y++) {
      field[areas[i].x+areas[i].w-1][y]=cell[0];
    }
    for (int y2=areas[i].y; y2<areas[i].room.y; y2++) {
      field[areas[i].x+areas[i].room.w/2+north[i]][y2]=cell[0];
    } 
    for (int y2=areas[i].room.y+areas[i].room.h; y2<areas[i].y+areas[i].h; y2++) {
      field[areas[i].x+areas[i].room.w/2+south[i]][y2]=cell[0];
    } 
    for (int x2=areas[i].x; x2<areas[i].room.x; x2++) {
      field[x2][areas[i].y+areas[i].room.h/2+east[i]]=cell[0];
    } 
    for (int x2=areas[i].room.x+areas[i].room.w; x2<areas[i].x+areas[i].w; x2++) {
      field[x2][areas[i].y+areas[i].room.h/2+west[i]]=cell[0];
    }
  }
  //外周2マスを壁にする
  for (int k=0; k<2; k++) {
    for (int x=0; x<field_width; x++) {
      field[x][field_height-1-k]=cell[1];
      field[x][k]=cell[1];
    }
    for (int y=0; y<field_height; y++) {
      field[field_width-k-1][y]=cell[1];
      field[k][y]=cell[1];
    }
  }

  //部屋につながる道を一つ減らす
  for (int i=0; i<areaCount; i++) {
    int roadCount=0;
    for (int y=areas[i].room.y-1; y<areas[i].room.y+areas[i].room.h+1; y++) {
      for (int x=areas[i].room.x-1; x<areas[i].room.x+areas[i].room.w+1; x++) {
        if ((x<areas[i].room.x||x>areas[i].room.x+areas[i].room.w-1)||(y<areas[i].room.y||y>areas[i].room.y+areas[i].room.h-1)) {
          if (field[x][y]==cell[0]) {
            roadCount++;
          }
        }
      }
    }

    if (roadrandom[i]%2==0) {
      for (int y=areas[i].room.y-1; y<areas[i].room.y+areas[i].room.h+1; y++) {
        for (int x=areas[i].room.x-1; x<areas[i].room.x+areas[i].room.w+1; x++) {
          if ((x<areas[i].room.x||x>areas[i].room.x+areas[i].room.w-1)||(y<areas[i].room.y||y>areas[i].room.y+areas[i].room.h-1)) {
            if (field[x][y]==cell[0]&&roadCount>1) {
              roadCount=1;
              field[x][y]=cell[1];
            }
          }
        }
      }
    } else if (roadrandom[i]%2==1) { 
      for (int x=areas[i].room.x-1; x<areas[i].room.x+areas[i].room.w+1; x++) {
        for (int y=areas[i].room.y-1; y<areas[i].room.y+areas[i].room.h+1; y++) {
          if ((x<areas[i].room.x||x>areas[i].room.x+areas[i].room.w-1)||(y<areas[i].room.y||y>areas[i].room.y+areas[i].room.h-1)) {
            if (field[x][y]==cell[0]&&roadCount>1) {
              roadCount=0;
              field[x][y]=cell[1];
            }
          }
        }
      }
    }
  }
  //孤立した部屋を記録
  int p=0;
  for (int i=0; i<areaCount; i++) {
    int roadCount=0;
    for (int y=areas[i].room.y-1; y<areas[i].room.y+areas[i].room.h+1; y++) {
      for (int x=areas[i].room.x-1; x<areas[i].room.x+areas[i].room.w+1; x++) {
        if ((x==areas[i].room.x-1||x==areas[i].room.x+areas[i].room.w)||(y==areas[i].room.y-1)||(y==areas[i].room.y+areas[i].room.h)) {
          //  field[x][y]=cell[3];
          if (field[x][y]==cell[0]) {
            roadCount++;
          }
        }
      }
    }
    if (i!=areaCount-1) {
      print(roadCount+" ");
    } else if (i==areaCount-1) {
      print(roadCount+"   ");
    }
    if (roadCount==0) { 

      banArea[p+2]=i;
      p++;
      banCount++;
    }
  }

  //部屋を消す
  for (int i=0; i<banCount; i++) {
    for (int y=areas[banArea[i]].room.y; y<areas[banArea[i]].room.y+areas[banArea[i]].room.h; y++) {
      for (int x=areas[banArea[i]].room.x; x<areas[banArea[i]].room.x+areas[banArea[i]].room.w; x++) {
        field[x][y]=cell[1];
      }
    }
  }
  //周囲３マスが壁ならそこを壁にする
  for (int c=0; c<35; c++) {
    for (int y=0; y<field_height; y++) {
      for (int x=0; x<field_width; x++) {
        if (field[x][y]==cell[0]) {
          int [][]v= {
            {
              0, -1
            }
            , {
              -1, 0
            }
            , {
              0, 1
            }
            , {
              1, 0
            }
          };
          int n=0;

          for (int i=0; i<4; i++) {
            int x2=x+v[i][0];
            int y2=y+v[i][1];

            if ((x2<0)||(x2>=field_width)||(y2<0)||(y2>=field_height)) {
              n++;
            } else if (field[x2][y2]==cell[1]) {
              n++;
            }
          }
          if (n>=3) {
            field[x][y]=cell[1];
          }
        }
      }
    }
  }
}
void disObject() {
  //playerを描画
  for (int y=0; y<field_height; y++) {
    for (int x=0; x<field_width; x++) {
      if (x==ply.x&&y==ply.y) {
        field[x][y]=cell[2];
      }
    }
  }
  field[stx][sty]=cell[3];
  // if ((x2<0)||(x2>=field_width)||(y2<0)||(y2>=field_height)){}
}

//boolean position(int x1, int y1) {

//  if (field[x1][y1]==cell[1]) {
//    return false;
//  } else {
//    return true;
//  }
//}
//０で全体、１でplay画面
void drawArea(int q) {
  if (q%2==0) {
    for (int y=0; y<field_height; y++) {
      for (int x=0; x<field_width; x++) {
        int t=7;
        textSize(t);
        text(field[x][y], float(x*t), float((y+1)*t));
      }
    }
    //全体像
  } else if (q%2==1) {
    int sx=0, sy=0;
    for (int y=ply.y-screenh; y<ply.y+screenh; y++) {

      for (int x=ply.x-screenw; x<ply.x+screenw; x++) {
        int t=48;
        textSize(t);

        if ((y<field_height&&y>0)&&(x<field_width&&x>0)) {
          text(field[x][y], float(sx*t), float((sy+3)*t));
        } else {
          text(cell[1], float(sx*t), float((sy+3)*t));
        }
        sx++;
      }
      sy++;
      sx=0;
    }
    textSize(30);
    text(floor+"F", 0, 34);
  }
}


String [] cell={"・", "■", "〇", "％", "E"};
int nono=0;
int stx=0, sty=0;
int koko=0;


int getRoom(int x, int y) {
  for (int i=0; i<areaCount; i++) {
    if ((x>=areas[i].room.x&&x<areas[i].room.x+areas[i].room.w)&&(y>=areas[i].room.y&&y<areas[i].room.y+areas[i].room.h)){
      return i;
    }
  }
  return -1;
}
