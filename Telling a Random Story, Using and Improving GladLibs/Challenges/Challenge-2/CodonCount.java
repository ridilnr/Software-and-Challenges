import edu.duke.*;
import java.util.*;
/**
 * Write a description of CodonCount here.
 * 
 * @author RIDI LUAMBA
 * @version 17/10/2018
 */
public class CodonCount {
    private HashMap<String,Integer> mapDna;
    
    public CodonCount(){
        mapDna = new HashMap<String,Integer>();
    }
    
    public void buildCodonMap(int start, String dna){
        mapDna.clear();
        dna = dna.trim();
        int lengthDna = dna.length();
        for(int j = start; j < lengthDna; j+=3){
            int endIndex = j + 3;
            if(endIndex < (lengthDna+1)){
                String codon = dna.substring(j, endIndex);
                /*if((codon.length() == 3) && Character.isLetter(codon.charAt(2))){
                    if(!mapDna.containsKey(codon)){
                        mapDna.put(codon,1);
                    }else{
                        mapDna.put(codon, mapDna.get(codon)+1);
                    }
                }*/
                if(!mapDna.containsKey(codon)){
                    mapDna.put(codon,1);
                }else{
                    mapDna.put(codon, mapDna.get(codon)+1);
                }
            }
        }
    }
    
    public String getMostCommonCodon(){
        int largestCount = 0;
        String keyCodon = "";
        for(String codon : mapDna.keySet()){
            int countCodon = mapDna.get(codon);
            if(countCodon > largestCount){
                largestCount = countCodon;
                keyCodon = codon;
            }
        }
        return keyCodon;
    }
    
    public void printCodonCounts(int start, int end){
        for(String codon : mapDna.keySet()){
            int codonCount = mapDna.get(codon);
            if((codonCount >= start) && (codonCount <= end)){
                System.out.println(codon + "\t" + mapDna.get(codon));
            }
        }
    }
    
    public void tester(){
        FileResource file = new FileResource();
        String dna = file.asString();
        dna = dna.toUpperCase();
        for(int k = 0; k < 3; k++){
            buildCodonMap(k, dna);
            System.out.println("Reading frame " + k);
            System.out.println("------------------------------------");
            System.out.println("Number of unique codons = " + mapDna.size());
            String keyComCodon = getMostCommonCodon();
            int valComCodon = mapDna.get(keyComCodon);
            System.out.println("Common codon is \""+keyComCodon+"\" its count is : "+valComCodon);
            printCodonCounts(1, 7);
            System.out.println("------------------------------------");
        }
    }
}
