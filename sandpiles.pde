int[][] sandpile;
int[][] buff;

boolean inft;
boolean m_inft;

int per_frame;
int pause_mult;
int total_drops;

void topple() {
  for (int x = 1; x < sandpile.length - 1; x++) {
    for (int y = 1; y < sandpile[0].length - 1; y++) {
      if (sandpile[x][y] >= 4 || (x == (width + 2) / 2 && y == (height + 2) / 2 && inft)) {
        if (x < 30) {
          inft = false;
          m_inft = false;
        }

        buff[x][y] -= 4;

        if (x == (width + 2) / 2 && y == (height + 2) / 2 && inft) {
          total_drops += 4;
          buff[x][y] = 8;
        }

        buff[x + 1][y]++;
        buff[x - 1][y]++;
        buff[x][y + 1]++;
        buff[x][y - 1]++;
      }
    }
  }

  for (int x = 0; x < width + 2; x++) {
    for (int y = 0; y < height + 2; y++) {
      sandpile[x][y] = buff[x][y];
    }
  }
}

color makeColour(int v) {
  return color(map(v, 0, 7, 105, 225), 255, 255);
}

void setup() {
  size(800, 800);
  colorMode(HSB);

  per_frame = 1;
  pause_mult = 1;

  total_drops = 0;

  sandpile = new int[width + 2][height + 2];
  buff = new int[width + 2][height + 2];
  for (int x = 0; x < width + 2; x++) {
    for (int y = 0; y < height + 2; y++) {
      sandpile[x][y] = 0;
      buff[x][y] = 0;
    }
  }

  inft = true;
  m_inft = true;
}

void draw() {
  loadPixels();
  for (int _ = 0; _ < per_frame * pause_mult; _++) {
    topple();
  }
  int p = 0;
  for (int y = 1; y < sandpile[0].length - 1; y++) {
    for (int x = 1; x < sandpile.length - 1; x++) {
      pixels[p] = makeColour(sandpile[x][y]);
      p++;
    }
  }

  updatePixels();
}

void keyPressed() {
  switch (keyCode) {
  case 'S':
    save("sand" + total_drops + ".png");
    println("saved");
    break;

  case 'T':
    println("STATS:");
    println(frameRate);
    println(per_frame);
    println(total_drops);
    break;

  case 'I':
    if (m_inft) {
      inft = !inft;
      println("set adding energy? to " + inft);
    }
    break;

  case 'B':
    per_frame = 800;
    println("set it/f to " + per_frame);
    break;

  case 'V':
    per_frame = 1;
    println("set it/f to " + per_frame);
    break;

  case 'P':
    if (pause_mult == 0) {
      pause_mult = 1;
      println("unpaused");
    } else {
      pause_mult = 0;
      println("paused");
    }
    break;

  case UP:
    per_frame++;
    println("increased it/f to " + per_frame);
    break;
  case DOWN:
    per_frame--;
    println("decreased it/f to " + per_frame);
    break;

  case RIGHT:
    per_frame += 10;
    println("increased it/f to " + per_frame);
    break;
  case LEFT:
    per_frame += 10;
    println("decreased it/f to " + per_frame);
    break;
    
  case 'R':
    setup();
  }
}
