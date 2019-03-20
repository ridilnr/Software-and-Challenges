import edu.duke.*;
/**
 * Write a description of CaesarBreaker here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class CaesarBreaker {
    
    public int[] countLetters(String message){
        String alph = "abcdefghijklmnopqrstuvwxyz";
        int[] counts = new int[26];
        for(int k = 0; k < message.length(); k++){
            char ch = Character.toLowerCase(message.charAt(k));
            int dex = alph.indexOf(ch);
            if(dex != -1){
                counts[dex] += 1;
            }
        }
        return counts;
    }
    
    public int maxIndex(int[] vals){
        int maxDex = 0;
        for(int k = 0; k < vals.length; k++){
            if(vals[k] > vals[maxDex]){
                maxDex = k;
            }
        }
        return maxDex;
    }
    
    public String decrypt(String encrypted){
        CaesarCipherOld cc = new CaesarCipherOld();
        int[] fregs = countLetters(encrypted);
        int maxDex = maxIndex(fregs);
        int dkey = maxDex - 4;
        if(maxDex < 4){
            dkey = 26 - (4 - maxDex);
        }
        return cc.encrypt(encrypted,26-dkey);
    }
    
    public String halfOfString(String message, int start){
        StringBuilder newMessage = new StringBuilder();
        for(int i = start; i < message.length(); i+=2){
            newMessage.append(message.charAt(i));
        }
        return newMessage.toString();
    }
    
    public int getKey(String s){
        int[] fregs = countLetters(s);
        int maxDex = maxIndex(fregs);
        if(maxDex < 4){
            return (26 - (4 - maxDex));
        }else{
            return (maxDex - 4); 
        }
    }
    
    public String decryptTwoKeys(String encrypted){
        CaesarCipherOld cc = new CaesarCipherOld();
        String[] halfOfString = new String[2];
        int[] keys = new int[2];
        halfOfString[0] = halfOfString(encrypted, 0);
        halfOfString[1] = halfOfString(encrypted, 1);        
        keys[0] = (26 - getKey(halfOfString[0]));
        keys[1] = (26 - getKey(halfOfString[1]));
        System.out.println("Keys of encryption are " + (26 - keys[0]) + " and " + (26 - keys[1]));
        System.out.println("Keys of decryption are " + keys[0] + " and " + keys[1] + "\n");
        return cc.encryptTwoKeys(encrypted, keys[0], keys[1]);
    }
    
    public void testDecrypt(){
        int key = 15;
        CaesarCipherOld cc = new CaesarCipherOld();
        FileResource fr = new FileResource();
        String message = fr.asString();
        System.out.println("Message in plain text : \n" + message);
        String encrypted = cc.encrypt(message, key);
        System.out.println("Encrypted message : \n" + encrypted);
        String decrypted = decrypt(encrypted);
        System.out.println("Decrypted message : \n" + decrypted);
        
    }
    
    public void testHalfOfString(){
        int index = 0;
        String message = "Qbkm Zgis";
        String halfMessage = halfOfString(message, index);
        System.out.println("Message : " + message);
        System.out.println("Half message from " + index + " : " + halfMessage);
        index = 1;
        halfMessage = halfOfString(message, index);
        System.out.println("Half message from " + index + " : " + halfMessage);
    }
    
    public void testGetKey(){
        String message = "aghdh ehwgeolajjfe";
        int indexKey = getKey(message);
        System.out.println("Message : " + message);
        System.out.println("Index of key : " + indexKey);
    }
    
    public void testDecryptTwoKeys(){
        FileResource fr = new FileResource();
        String encryptedMsg = fr.asString();
        String decryptedMsg = decryptTwoKeys(encryptedMsg);
        System.out.println("Encrypted message : \n" + encryptedMsg);
        System.out.println("Decrypted message : \n" + decryptedMsg);
    }
}
