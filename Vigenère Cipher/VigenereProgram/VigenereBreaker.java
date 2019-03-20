import java.util.*;
import edu.duke.*;
import java.io.*;

public class VigenereBreaker {
    public String sliceString(String message, int whichSlice, int totalSlices) {
        StringBuilder newMessage = new StringBuilder();
        for(int i = whichSlice; i < message.length(); i+=totalSlices){
            newMessage.append(message.charAt(i));
        }
        return newMessage.toString();
    }

    public int[] tryKeyLength(String encrypted, int klength, char mostCommon) {
        int[] key = new int[klength];
        CaesarCracker cc = new CaesarCracker(mostCommon);
        for(int j = 0; j < klength; j++){
            String slicedInput = sliceString(encrypted, j, klength);
            key[j] = cc.getKey(slicedInput);
        }
        return key;
    }

    public HashSet<String> readDictionary(FileResource fr){
        HashSet<String> dictionary = new HashSet<String>();
        for(String line : fr.lines()){
            line = line.toLowerCase();
            dictionary.add(line);
        }
        return dictionary;
    }
    
    public int countWords(String message, HashSet<String> dictionary){
        String[] arrayWords = message.split("\\W+");
        int counter = 0;
        for(String word : arrayWords){
            if(dictionary.contains(word.toLowerCase())){
                counter++;
            }
        }
        return counter;
    }
    
    public String breakForLanguage(String encrypted, HashSet<String> dictionary){
        String bestDecryption = "";
        int largestCount = 0;
        int klength = 1;
        char mostCommonCh = mostCommonCharIn(dictionary);
        for(int k = 1; k < 100; k++){
            int[] keys = tryKeyLength(encrypted, k, mostCommonCh);
            VigenereCipher vc = new VigenereCipher(keys);
            String decrypted = vc.decrypt(encrypted);
            int countRealWord = countWords(decrypted, dictionary);
            if(countRealWord > largestCount){
                largestCount = countRealWord;
                bestDecryption = decrypted;
                klength = k;
                printKey(keys);
            }
        }
        System.out.println("Number of real words = " + largestCount);
        System.out.println("------------------------------------------------------------------------------------------");
        System.out.println("Key length used for encryption = " + klength);
        System.out.println("------------------------------------------------------------------------------------------");
        
        return bestDecryption;
    }
    
    public void printKey(int[] keys){
        System.out.print("Key: {");   
        for(int i = 0; i < keys.length; i++){
            if(i == 0){
                System.out.print(keys[0]);
            }else{
                System.out.print(", "+keys[i]);               
            }
        }
        System.out.print("}\n");
    }
    
    public char mostCommonCharIn(HashSet<String> dictionary){
        String alph = "abcdefghijklmnopqrstuvwxyz";
        StringBuilder message = new StringBuilder();
        CaesarCracker cc = new CaesarCracker();
        for(String word : dictionary){
            message.append(word.toLowerCase());
        }
        int[] counts = cc.countLetters(message.toString());
        int maxIdx = cc.maxIndex(counts);
        char ch = alph.charAt(maxIdx);
        //System.out.println("Most common letter is: " + ch);
        return ch;
    }
    
    public void breakForAllLangs(String encrypted, HashMap<String,HashSet<String>> languages){
        for(String lang : languages.keySet()){
            System.out.println("------------------------------------------------------------------------------------------");
            System.out.println("Language : " + lang);
            System.out.println("------------------------------------------------------------------------------------------");
            String decrypted = breakForLanguage(encrypted, languages.get(lang));
            System.out.println(decrypted/*.substring(0,500)*/);
        }
    }
    
    public void breakVigenere() {
        FileResource fileRes = new FileResource();
        String encrypted = fileRes.asString();
        DirectoryResource dr = new DirectoryResource();
        HashMap<String, HashSet<String>> dictionaries = new HashMap<String, HashSet<String>>();
        for(File f : dr.selectedFiles()){
            String langDictionary = f.getName();
            System.out.println("Reading "+langDictionary+" dictionary...");
            FileResource fr = new FileResource(f);
            dictionaries.put(langDictionary, readDictionary(fr));
        }
        breakForAllLangs(encrypted, dictionaries);
        //System.out.println("Encrypted message is: \n" + encrypted.substring(0,500));
        System.out.println("------------------------------------------------------------------------------------------");
        //System.out.println("\nDecrypted message is: \n" +  decrypted.substring(0,500));
    }
}
