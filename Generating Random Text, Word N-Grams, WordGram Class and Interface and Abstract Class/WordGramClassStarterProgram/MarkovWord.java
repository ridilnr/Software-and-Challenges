
/**
 * Write a description of class MarkovWordOne here.
 * 
 * @author Ridi
 * @version 29/10/2018
 */

import java.util.*;

public class MarkovWord implements IMarkovModel {
    private String[] myText;
    private Random myRandom;
    private int myOrder;
    
    public MarkovWord(int order) {
        myRandom = new Random();
        myOrder = order;
    }
    
    public void setRandom(int seed) {
        myRandom = new Random(seed);
    }
    
    public void setTraining(String text){
        myText = text.split("\\s+");
    }
    
    public String getRandomText(int numWords){
        StringBuilder sb = new StringBuilder();
        int index = myRandom.nextInt(myText.length-myOrder);  // random word to start with
        WordGram kGram = new WordGram(myText,index,myOrder); 
        sb.append(kGram);
        sb.append(" ");
        for(int k=0; k < numWords-myOrder; k++){
            ArrayList<String> follows = getFollows(kGram);
            if (follows.size() == 0) {
                break;
            }
            index = myRandom.nextInt(follows.size());
            String next = follows.get(index);
            sb.append(next);
            sb.append(" ");
            kGram = kGram.shiftAdd(follows.get(index));
        }
        return sb.toString().trim();
    }
    
    private int indexOf(String[] words, WordGram target, int start){
        for(int k = start; k <= words.length-myOrder; k++){
            WordGram wg = new WordGram(words,k,target.length());
            if(wg.equals(target)){
                return k;
            }
        }
        return -1;
    }    
    
    private ArrayList<String> getFollows(WordGram kGram) {
        ArrayList<String> follows = new ArrayList<String>();
        int pos = 0;
        while(pos < myText.length){
            int start = indexOf(myText, kGram, pos);
            if(start == -1){
                break;
            }
            
            if(start+myOrder >= myText.length){
                break;
            }
            String next = myText[start+myOrder];
            follows.add(next);
            pos = start+myOrder;
        }
        return follows;
    }

    public void testIndexOf(){
        String source = "this is a test this is a test this is a test of words";
        String[] words = source.split("\\s+");
        int size = 4;
        WordGram wg = new WordGram(words,0,size);
        int idx = indexOf(words, wg, 0);
        System.out.print(idx+"\t");
        idx = indexOf(words, wg, 3);
        System.out.print(idx+"\t");
        idx = indexOf(words, wg, 7);
        System.out.print(idx+"\t");
        idx = indexOf(words, wg, 11);
        System.out.print(idx+"\t");
        //idx = indexOf(words, wg, 0);
        //System.out.println(idx);
    }
}
