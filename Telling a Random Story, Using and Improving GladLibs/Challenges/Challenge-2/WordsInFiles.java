import edu.duke.*;
import java.util.*;
import java.io.*;
/**
 * Write a description of WordsInFiles here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class WordsInFiles {
    private HashMap<String,ArrayList<String>> mapWordToFile;
    
    public WordsInFiles(){
        mapWordToFile = new HashMap<String,ArrayList<String>>();
    }
    
    public void addWordsFromFile(File f){
        FileResource fr = new FileResource(f);
        String fileName = f.getName();
        for(String word : fr.words()){
            if(!mapWordToFile.containsKey(word)){
                ArrayList<String> fileList = new ArrayList<String>();
                fileList.add(fileName);
                mapWordToFile.put(word, fileList);
            }else{
                ArrayList<String> fileList = mapWordToFile.get(word);
                if(!fileList.contains(fileName)){
                    fileList.add(fileName);
                    mapWordToFile.put(word, fileList);                    
                }
            }
        }
    }
    
    public void buildWordFileMap(){
        mapWordToFile.clear();
        DirectoryResource dr = new DirectoryResource(); 
        for(File f : dr.selectedFiles()){
            addWordsFromFile(f);
        }
    }
    
    public ArrayList wordsInNumFiles(int number){
        ArrayList<String> fregWords = new ArrayList<String>();
        for(String word : mapWordToFile.keySet()){
            if(mapWordToFile.get(word).size() == number){
                fregWords.add(word);
            }
        }
        return fregWords;
    }
    
    public void printFilesIn(String word){
        for(String w : mapWordToFile.keySet()){
            if(w.equals(word)){
                for(String fileName : mapWordToFile.get(w)){
                    System.out.println(fileName);
                }
            }
        }
    }
    
    public void tester(){
        buildWordFileMap();
        ArrayList<String> maxWordsFile = wordsInNumFiles(4);
        String word = "sea";
        System.out.println("---------------------------------------------------------");
        System.out.println("There are " + maxWordsFile.size() + " words that occur in all files");
        System.out.println("---------------------------------------------------------");
        System.out.println("Word "+word+" appear in the following files : ");
        printFilesIn(word);
        System.out.println("---------------------------------------------------------");
        /*for(String word : maxWordsFile){
            System.out.println(word + " exists in the following file(s) : ");
            System.out.println("---------------------------------------------------------");
            if(mapWordToFile.containsKey(word)){
                for(String fileName : mapWordToFile.get(word)){
                    System.out.println(fileName);
                }
            }
        }
        /*System.out.println("---------------------------------------------------------");
        System.out.println("All words found in all files are :");
        System.out.println("---------------------------------------------------------");
        for(String word : mapWordToFile.keySet()){
            System.out.print(word + " found in : ");
            for(String fileName : mapWordToFile.get(word)){
                System.out.print("\"" + fileName + "\"  ");
            }
            System.out.println("\n---------------------------------------------------------");
        }*/
    }
}
