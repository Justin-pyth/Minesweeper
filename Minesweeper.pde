import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();
    for (int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    for(int i = 0; i < 3; i++){
      setMines();
    }
}

public void setMines()
{
  int r = (int)(Math.random()*20);
  int c = (int)(Math.random()*20);
  if (!mines.contains(buttons[r][c])){
    mines.add(buttons[r][c]);
  }
 
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon()
{
  int winning = NUM_ROWS * NUM_COLS - mines.size();
  int count = 0;
  for (int r = 0; r < NUM_ROWS; r++){
    for(int c = 0; c < NUM_COLS; c++){
      if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == true){
        count++;
      }
    }
  }

  if (count == winning){
    return true;
  }else{
    return false;
  }
}

public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++){
    for (int c = 0; c < NUM_COLS; c++){
      if (mines.contains(buttons[r][c]))
        buttons[r][c].clicked= true;
    }
  }
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][10].setLabel("L");
  buttons[10][11].setLabel("O");
  buttons[10][12].setLabel("S");
  buttons[10][13].setLabel("E");
  noLoop();
  
}

public void displayWinningMessage()
{
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][10].setLabel("W");
  buttons[10][11].setLabel("I");
  buttons[10][12].setLabel("N");
  buttons[10][13].setLabel("");
  for (int r = 0; r < NUM_ROWS; r++){
    for (int c = 0; c < NUM_COLS; c++){
      if (mines.contains(buttons[r][c]))
        buttons[r][c].clicked= true;
    }
  }
  noLoop();
}

public boolean isValid(int r, int c)
{
    return r >=0 && r<NUM_ROWS&& c>=0 && c<NUM_COLS;
}

public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++)
      for(int c = col-1; c<=col+1;c++)
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        
        if (mouseButton == RIGHT){
          flagged = !flagged;
          if (flagged){
            if (!clicked){
              clicked = false;
            } else if (clicked == true){
              clicked = true;
            }
          }
        }
        else if (mines.contains(this)){
          clicked = true;
          displayLosingMessage();
        }
        else if (countMines(myRow,myCol) > 0){
          clicked = true;
          myLabel = countMines(myRow,myCol) + "";
        }
        else{
          clicked = true;
          for(int r = myRow-1;r<=myRow+1;r++)
            for(int c = myCol-1; c<=myCol+1;c++)
              if(isValid(r,c) && buttons[r][c].clicked == false)
                buttons[r][c].mousePressed();
        } 
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
             fill(240,128,128);
        else if(clicked)
            fill(255);
        else 
            fill(255,203,164);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
