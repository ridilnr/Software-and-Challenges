
/**
 * Write a description of WordLengths here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import edu.duke.*;
import java.io.File;

public class WordLengths {
    
    public void countWordLengths(FileResource resource, int[] counts){
        
        int lengthArray = counts.length;
        for(String word : resource.words()){
            int wordLength = word.length();
            boolean isStartChLetter = Character.isLetter(word.charAt(0));
            boolean isEndChLetter = Character.isLetter(word.charAt(wordLength-1));
            if(wordLength >= lengthArray){
                wordLength = lengthArray - 1;
                counts[wordLength] += 1;
            }else{
                if(isStartChLetter && isEndChLetter){
                    counts[wordLength] += 1;
                }else if(isStartChLetter && !isEndChLetter){
                    counts[wordLength-1] += 1;
                }else if(isStartChLetter && !isEndChLetter){
                    counts[wordLength-1] += 1;
                }else{
                    if(wordLength != 1){
                        counts[wordLength-2] += 1;
                    }
                }
            }
        }  
    }
    
    public int indexOfMax (int[] values){
        int indexPosLargest = 0;
        int maxValue = 0;
        for(int i = 0; i < values.length; i++){
            if(values[i] > maxValue){
                maxValue = values[i];
                indexPosLargest = i;
            }
        }
        return indexPosLargest;
    }
    
    public void testCountWordLengths(){
        FileResource file = new FileResource();
        int[] counts = new int[31];
        int countWords = 0;
        countWordLengths(file, counts);
        int mostWordLength = indexOfMax(counts);
        for(int k = 1; k < counts.length; k++){
            if(counts[k] != 0){
                System.out.println("Number of words of length " + k + " = " + counts[k]);
                countWords += counts[k];
            }
        }
        System.out.println("-----------------------------------------");
        System.out.println("Most used word length is " + mostWordLength);
        System.out.println("Selected file contains " + countWords + " words.");
    }
}
