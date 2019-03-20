
/**
 * Write a description of class MarkovWordOne here.
 * 
 * @author Ridi
 * @version 29/10/2018
 */

import java.util.*;

public class EfficientMarkovWord implements IMarkovModel {
    private String[] myText;
    private Random myRandom;
    private int myOrder;
	private double timing;
    private HashMap<WordGram, ArrayList<String>> hashGram;
    
    public EfficientMarkovWord(int order) {
        myRandom = new Random();
        myOrder = order;
		timing = 0.0;
        hashGram = new HashMap<WordGram, ArrayList<String>>();
    }
 
    public void setRandom(int seed) {
        myRandom = new Random(seed);
    }
    
    public void setTraining(String text){
        myText = text.split("\\s+");
    }
    
    public String getRandomText(int numWords){
		double startTime = (double)System.nanoTime();
        buildMap();
        printHashMapInfo();
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
		timing += (System.nanoTime()-startTime);*/
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
        for(WordGram wg : hashGram.keySet()){
            if(wg.equals(kGram)){
                return hashGram.get(wg);
            }
        }
        return new ArrayList<String>();
    }

    public void buildMap(){
        hashGram.clear();
        for(int k = 0; k <= myText.length-myOrder; k++) {
            WordGram wg = new WordGram(myText,k,myOrder);
            //int hash = wg.hashCode();
            ArrayList<String> follows = new ArrayList<String>();
            if(! hashGram.containsKey(wg)){
                hashGram.put(wg, new ArrayList<String>());
            }
            
            if(k + myOrder >= myText.length){
                break;
            }
            String next = myText[k+wg.length()];
            hashGram.get(wg).add(next);   
        }
    }
    public double getTiming(){
        return timing/1000000000.0;
    }
	
    public void printHashMapInfo(){
        int max = 0;
        for(WordGram wg : hashGram.keySet()){
           System.out.println(wg+" : "+hashGram.get(wg));
           if(max < hashGram.get(wg).size()){
               max = hashGram.get(wg).size();
           }
        }
        System.out.println("# of keys in the hashmap: "+hashGram.size());
        System.out.println("Maximum # of following words is: "+max);
        System.out.println("Keys with maximum size value "+max+":");
        for(WordGram wg : hashGram.keySet()){
           if(max == hashGram.get(wg).size()){
               System.out.println(wg+" : "+hashGram.get(wg));
           }
        }
    }
}
