//main
void generateField() {
  fill(255);

  //areaの設定
  if (koko==0) {  
    areaCount=0;
    areas[0]=new AREA(0, 0, field_width, field_height);
    areaCount++;
    areas[0].spritArea(0);
    koko++;
  }
  //displayArea();//デバッグ


  //roomの設定




  for (int i=0; i<areaCount; i++) {
    areas[i].room=new ROOM(areas[i].x+2, areas[i].y+2, areas[i].w-4, areas[i].h-4);
  }
  disRoom();
  print(banCount+"  ");
  for (int k=0; k<banCount; k++) {
    if (k!=banCount-1) {
      print(banArea[k]+" ");
    } else if (k==banCount-1) {
      println(banArea[k]);
    }
  }
  if (nono<1) {
    int chk=0; 

    int areaidx=int(random(0, areaCount)), stairidx=int(random(0, areaCount)), enemyidx=int(random(0, areaCount));
    while ((chk==banCount*3)==false) {
      chk=0;
      for (int k=0; k<banCount; k++) {
        if (banArea[k]==areaidx) {
          areaidx=int(random(0, areaCount));
        } else if (banArea[k]!=areaidx) {
          chk++;
        }  
        if (banArea[k]==stairidx) {
          stairidx=int(random(0, areaCount));
        } else if (banArea[k]!=stairidx) {
          chk++;
        }
        if (banArea[k]==enemyidx) {
          enemyidx=int(random(0, areaCount));
        } else if (banArea[k]!=enemyidx) {
          chk++;
        }
      }
    }

    ply=new chara1(areas[areaidx].room.x+int(random(0, areas[areaidx].room.w)), areas[areaidx].room.y+int(random(0, areas[areaidx].room.h)));
    enemy=new chara1(areas[areaidx].room.x+int(random(0, areas[areaidx].room.w)), areas[areaidx].room.y+int(random(0, areas[areaidx].room.h)));
    nono++;
    stx=areas[stairidx].room.x+int(random(0, areas[stairidx].room.w));
    sty= areas[stairidx].room.y+int(random(0, areas[stairidx].room.h));
    if (ply.x==stx&&ply.y==sty) {
      nono--;
    }
  }
  disObject();
  control();
  //disObject();
  drawArea(1);
}


int keyFrame=0;

int floor=1;
//controler
void control() {

  int x=ply.x;
  int y=ply.y;
  if (keyFrame>3) {
    keyFrame=0;
    if (keyPressed) {
      switch (key) {
      case 'a':  
        x--; 
        break;

      case 'd': 
        x++;  
        break;
      case 'w' :  
        y--; 
        break;
      case 's':  
        y++; 
        break;
      }
    }
    if (field[x][y]==cell[0]) {
      ply.x=x;
      ply.y=y;
    } else if (field[x][y]==cell[3]) {
      floor++;
      koko=0;
      nono=0;

      generateField();
    }
  }
  keyFrame++;
}
