void home() {
  PImage [] aicon={danzyon, shop, house, danzyon2, shop2, house2};
  fill(255);
  rect(0, 0, width, height);
  fill(0);
  for (int k=0; k<3; k++) {
    int t=205;

    if (catchHit( width-((t)*k)-t, height-t, aicon[k].width, aicon[k].height, mouseX, mouseY, 2, 2)==true) {
      image(aicon[k+3], width-((t)*k)-t-20, height-t-20);
      if (mousePressed==true) {
        kanri=k+1;
      }
    } else if (catchHit( width-((t)*k)-t, height-t, aicon[k].width, aicon[k].height, mouseX, mouseY, 2, 2)==false) {
      image(aicon[k], width-((t)*k)-t, height-t);
    }
  }
}

boolean catchHit(float x1, float y1, float w1, float h1, 
  float x2, float y2, float w2, float h2) {
  return x1 < x2+w2 && x2 < x1+w1 && y1 < y2+h2 && y2 < y1+h1;
}

void shop() {
}

void house() {
}
