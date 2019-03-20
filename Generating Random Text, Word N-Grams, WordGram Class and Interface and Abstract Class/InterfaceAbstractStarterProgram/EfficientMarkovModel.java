import java.util.*;
import edu.duke.*;
/**
 * Write a description of MarkovFour  here.
 * 
 * @author RIDI LUAMBA
 * @version 28/10/2018
 */

public class EfficientMarkovModel extends AbstractMarkovModel{
    private int numOfChar;
    private HashMap<String, ArrayList<String>> hashKeyFollows;
    private double timing;
    
    public EfficientMarkovModel(int nc) {
        numOfChar = nc;
        hashKeyFollows = new HashMap<String, ArrayList<String>>();
        timing = 0.0;
    }
    
    public void setRandom(int seed){
        myRandom = new Random(seed);
    }
    
    public void setTraining(String s){
        myText = s.trim();
        buildMap();
        printHashMapInfo();
    }
  
    public String getRandomText(int numChars){
        double startTime = (double)System.nanoTime();
        if (myText == null){
            return "";
        }

        
        StringBuilder sb = new StringBuilder();
        /*int index = myRandom.nextInt(myText.length()-numOfChar);
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
        timing += (System.nanoTime()-startTime);*/
        return sb.toString();
    }
    
    public void buildMap(){
        hashKeyFollows.clear();
        for(int k = 0; k <= myText.length()-numOfChar; k++){
            String key = myText.substring(k, k+numOfChar);
            ArrayList<String> follows = new ArrayList<String>();
            if(! hashKeyFollows.containsKey(key)){
                hashKeyFollows.put(key, new ArrayList<String>());
            }else{
                if(k + numOfChar >= myText.length()){
                break;
            }
            }
            
            
            String next = myText.substring(k+key.length(), k+key.length()+1);
            hashKeyFollows.get(key).add(next);
        }
    }
 
    public ArrayList<String> getFollows(String key){
        for(String hkf : hashKeyFollows.keySet()){
            if(hkf.equals(key)){
                return hashKeyFollows.get(hkf);
            }
        }
        return new ArrayList<String>(); 
    }
    
    public double getTiming(){
        return timing/1000000000.0;
    }
    
    public void printHashMapInfo(){
        int max = 0;
        for (String key : hashKeyFollows.keySet()) {
            System.out.println(key+" : "+hashKeyFollows.get(key));
            if(max < hashKeyFollows.get(key).size()){
               max = hashKeyFollows.get(key).size();
            }
        }
        System.out.println("\n# of keys: "+hashKeyFollows.size());
        System.out.println("Maximum # of following words is: "+max);
        System.out.println("Keys with maximum size value "+max+":");
        for(String key : hashKeyFollows.keySet()){
           if(max == hashKeyFollows.get(key).size()){
               System.out.println("Length = "+key.length()+"\t"+key+" : "+hashKeyFollows.get(key));
           }
        }
    }
    
    public String toString(){
        return "EfficientMarkovModel of order n("+numOfChar+").";
    }
}
