import java.util.*;
/**
 * Write a description of MarkovFour  here.
 * 
 * @author RIDI LUAMBA
 * @version 28/10/2018
 */

public class MarkovModel extends AbstractMarkovModel{
    private int numOfChar;
    private double timing;
    public MarkovModel(int nc) {
        numOfChar = nc;
        timing = 0.0;
    }
    
    public void setRandom(int seed){
        myRandom = new Random(seed);
    }
    
    public void setTraining(String s){
        myText = s.trim();
        
    }
    
    public String getRandomText(int numChars){
        double startTime = (double)System.nanoTime();
        if (myText == null){
            return "";
        }
        StringBuilder sb = new StringBuilder();
        int index = myRandom.nextInt(myText.length()-numOfChar);
        String key = myText.substring(index, index+numOfChar);
        sb.append(key);
        
        for(int k=0; k < numChars-numOfChar; k++){
            ArrayList<String> follows = getFollows(key);
            if(follows.size() == 0){
                break;
            }
            index = myRandom.nextInt(follows.size());
            String next = follows.get(index);
            sb.append(next);
            key = key.substring(1) + next;
        }
        timing += (System.nanoTime()-startTime);
        return sb.toString();
    }
    
    public double getTiming(){
        return timing/1000000000.0;
    }
    
    public String toString(){
        return "MarkovModel of order n("+numOfChar+").";
    }
}
