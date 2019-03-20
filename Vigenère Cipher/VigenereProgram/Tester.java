import edu.duke.*;
import java.util.*;
/**
 * Write a description of Tester here.
 * 
 * @author RIDI LUAMBA
 * @version 19/10/2018
 */
public class Tester {
    
    public void testCaesarCipherMessage(){
       int key = 17; 
       CaesarCipher cc = new CaesarCipher(key);
       FileResource fr = new FileResource();
       String message = fr.asString();
       String encrypted = cc.encrypt(message);
       String decrypted = cc.decrypt(encrypted);
       System.out.println("Original message : \n" + message);
       System.out.println("Encrypted message : \n" + encrypted);
       System.out.println("Decrypted message : \n" + decrypted);
    }
    
    public void testCaesarCipherCharacter(){
       int key = 17; 
       CaesarCipher cc = new CaesarCipher(key);
       char ch = 'c';
       char encrypted = cc.encryptLetter(ch);
       char decrypted = cc.decryptLetter(encrypted);
       System.out.println("Original character : " + ch);
       System.out.println("Encrypted character : " + encrypted);
       System.out.println("Decrypted character : " + decrypted);
    }
    
    public void testCaesarCracker(){
       CaesarCracker cc = new CaesarCracker('a');
       FileResource fr = new FileResource();
       String encrypted = fr.asString();
       String decrypted = cc.decrypt(encrypted);
       int key = cc.getKey(encrypted); 
       System.out.println("Encrypted message : \n" + encrypted);
       System.out.println("Decrypted message : \n" + decrypted);
       System.out.println("The Key used to encrypt message is : " + key);
       System.out.println("The Key used to decrypt message is : " + (26 - key));
    }
    
    public void testVigenereCipher(){
       int[] rome = {17, 14, 12, 4}; 
       VigenereCipher vc = new VigenereCipher(rome);
       FileResource fr = new FileResource();
       String message = fr.asString();
       String encrypted = vc.encrypt(message);
       String decrypted = vc.decrypt(encrypted);
       System.out.println("Original message : \n" + message);
       System.out.println("Encrypted message : \n" + encrypted);
       System.out.println("Decrypted message : \n" + decrypted);
    }
    
    public void testSliceString(){
        VigenereBreaker vb = new VigenereBreaker();
        String message = "abcdefghijklm";
        System.out.println("Message: "+message);
        System.out.println("------------------------------------------");
        for(int i = 3; i <= 5; i++){
            for(int j = 0; j < i; j++){
                String slicedMessage = vb.sliceString(message,j,i);
                System.out.println("("+"whichSlice= "+j+" & totalSlices= "+i+"): "+slicedMessage);
            }
        }
        System.out.println("------------------------------------------");
    }
    
    public void testTryKeyLength(){
       VigenereBreaker vb = new VigenereBreaker();
       FileResource fr = new FileResource();
       String message = fr.asString();
       int[] keys = vb.tryKeyLength(message, 4, 'e');
       System.out.print("{");
       System.out.print(keys[0]);
       for(int i = 1; i < keys.length; i++){
           System.out.print(", "+keys[i]);
       }
       System.out.print("}\n");
    }
    
    public void testBreakVigenere(){
        VigenereBreaker vb = new VigenereBreaker();
        vb.breakVigenere();
    }
    
    public void testReadDictionary(){
        VigenereBreaker vb = new VigenereBreaker();
        HashSet<String> dictionary = vb.readDictionary(new FileResource());
        System.out.println(dictionary);
    }
    
    public void testCountWords(){
        VigenereBreaker vb = new VigenereBreaker();
        HashSet<String> dictionary = vb.readDictionary(new FileResource());
        String message = "Ridi is a genius guy comming from DRC";
        int countWords = vb.countWords(message, dictionary);
        System.out.println("Message: \""+message+"\"");
        System.out.println("--------------------------------------------------");
        System.out.println("Number of real words in the above message is: "+countWords);
        //countWords
    }
    
    public void testMostCommonCharIn(){
        VigenereBreaker vb = new VigenereBreaker();
        HashSet<String> dictionary = vb.readDictionary(new FileResource());
        vb.mostCommonCharIn(dictionary);
    }
}
