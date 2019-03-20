import edu.duke.*;
/** 
 * @author RIDI LUAMBA
 * @version 16/10/2018
 */
public class CaesarCipher {
    private String alphabet;
    private String shiftedAlphabet;
    private int mainKey;
    
    public CaesarCipher(int key){
        alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        shiftedAlphabet = alphabet.substring(key)+ alphabet.substring(0,key);
        mainKey = key;
    }
    
    public String encrypt(String input) {
        StringBuilder encrypted = new StringBuilder(input);
        CaesarCipherOld cco = new CaesarCipherOld();
        for(int i = 0; i < encrypted.length(); i++) {
            encrypted = cco.replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet);
        }
        return encrypted.toString();
    }
    
    public String decrypt(String input) {
        CaesarCipher cc = new CaesarCipher(26 - mainKey);
        return cc.encrypt(input);
    }
}
