import edu.duke.*;
/**
 * Write a description of CaesarCipherOld here.
 * 
 * @author RIDI LUAMBA
 * @version 15/10/2018
 */
public class CaesarCipherOld {
    
    public String encrypt(String input, int key) {
        
        StringBuilder encrypted = new StringBuilder(input);
        String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String shiftedAlphabet = alphabet.substring(key)+ alphabet.substring(0,key);
        for(int i = 0; i < encrypted.length(); i++) {
            encrypted = replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet);
        }
        return encrypted.toString();
    }
    
    public String encryptTwoKeys(String input, int key1, int key2){
        
        StringBuilder encrypted = new StringBuilder(input);
        String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String shiftedAlphabet1 = alphabet.substring(key1)+ alphabet.substring(0,key1);
        String shiftedAlphabet2 = alphabet.substring(key2)+ alphabet.substring(0,key2);        
        for(int i = 0; i < encrypted.length(); i++) {
            if((i % 2) == 0){
                encrypted = replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet1);
            }else{
                encrypted = replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet2);
            }
        }
        return encrypted.toString();
    }
    
    public StringBuilder replaceCharProcess(int i, String alphabet, StringBuilder encrypted, String shiftedAlphabet)
    {
        char currChar = encrypted.charAt(i);
        if(Character.isLowerCase(currChar)){
            alphabet = alphabet.toLowerCase();
            shiftedAlphabet = shiftedAlphabet.toLowerCase();
        }else{
            alphabet = alphabet.toUpperCase();
            shiftedAlphabet = shiftedAlphabet.toUpperCase();
        }
        
        int idx = alphabet.indexOf(currChar);
        if(idx != -1){
            char newChar = shiftedAlphabet.charAt(idx);
            encrypted.setCharAt(i, newChar);
        }
        return encrypted;
    }
    
    public void testCaesar() {
        int key = 15;
        int key1 = 21;
        int key2 = 8;
        FileResource fr = new FileResource();
        String message = fr.asString();
        String encrypted = encrypt(message, key);
        //System.out.println("key is " + key + "\n" + encrypted);
        //String decrypted = encrypt(encrypted, 26-key);
        //System.out.println(decrypted);
        encrypted = encryptTwoKeys(message, key1, key2);
        System.out.println("key1 is " + key1 + " and key2 is " + key2 + "\n" + encrypted);
    }
}
