import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int numrows = 10;
public final static int numcols = 10;
private MSButton[][] buttons = new MSButton[numrows][numcols]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(640,640);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for(int i = 0; i < numrows; i++){
      for(int j = 0; j < numcols; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    
    
    for(int i = 0; i < numcols * numrows / 6; i++){
      setMines();
    }
      
}
public void setMines()
{
int mineRow = (int)(Math.random() * numrows);
int mineCol = (int)(Math.random() * numcols); 
if(!mines.contains(buttons[mineRow][mineCol])){
  mines.add(buttons[mineRow][mineCol]);
}
}

public void draw ()
{
    background( 0 );
    
        
}
public boolean isWon()
{
  int count = 0;
  for(int i = 0; i < numrows; i++){
    for(int j = 0; j < numcols; j++){
      if(buttons[i][j].loss ==true){}
      else if(buttons[i][j].clicked == true){count++;}
    }
  } 
  if(count == 100 - mines.size()){
    return(true);
  }
  return(false);
}

public void displayLosingMessage(MSButton a)
{
  a.setLabel("   you clicked" + "\n" + "a mine");  
}
public void displayWinningMessage(MSButton a)
{
   a.setLabel("you win");
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < numrows && c >= 0 && c < numcols){return(true);}
    return false;
}
public int countMines(int row, int col)
{
    int count = 0;
for(int i = row-1; i <= row + 1; i++){
  for(int j = col-1; j <= col + 1; j++){
    if(isValid(i,j)){
    if(i == row && j == col){}
    else if(mines.contains(buttons[i][j])){count++;}
  }
  }
}
return(count);
}


public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    private boolean loss = false;
    private boolean win = false;
    
    public MSButton (int row, int col)
    {
        width = 640/numcols;
       height = 640/numrows;
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
        if(loss == true){}
        else if(mouseButton == LEFT && !mines.contains(this) && flagged == false && win == false){
        clicked = true;
        if(isWon()){
          displayWinningMessage(this);
          for(int i = myRow-1; i <= myRow + 1; i++){
            for(int j = myCol-1; j <= myCol + 1; j++){
              buttons[i][j].win = true;
            }
          }
        }
        if(countMines(myRow,myCol) == 0 && !mines.contains(this)){
          for(int i = myRow-1; i <= myRow + 1; i++){
            for(int j = myCol-1; j <= myCol + 1; j++){
              if(isValid(i,j) && buttons[i][j].clicked == false){
                if(i != myRow || j != myCol){
              buttons[i][j].mousePressed();
              
              }
            }
            }
          }
       
        }
        
        }
        else if(mouseButton == LEFT && mines.contains(this) && flagged == false && win == false){
          clicked = true;
          displayLosingMessage(this);
          for(int i = 0; i < buttons.length; i++){
            for(int j = 0; j < buttons[i].length; j++){
              buttons[i][j].loss = true;
              if(!mines.contains(buttons[i][j]) && buttons[i][j].isFlagged() == true){
                buttons[i][j].setLabel("wrong \n flag");
              }
              buttons[i][j].clicked = true;
            }
          }
        }
        else if(mouseButton == RIGHT){
        if(this.clicked == true){}
        else if(flagged == true){flagged = false;}
        else{flagged = true;}
        }
       
     }
    public void draw () 
    {    
        if (flagged)
            fill(0,0,255);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked){
            fill(200);
            setLabel(countMines(this.myRow, this.myCol));
            
          }
        else{ 
            fill(100);
        }

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
