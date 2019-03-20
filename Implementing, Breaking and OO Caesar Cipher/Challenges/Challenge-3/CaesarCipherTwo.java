
/**
 * Write a description of CaesarCipherTwo here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class CaesarCipherTwo {
    private String alphabet;
    private String shiftedAlphabet1;
    private String shiftedAlphabet2;
    private int[] keys = new int[2];
    private CaesarCipherOld cco = new CaesarCipherOld();
    private CaesarBreaker cb = new CaesarBreaker();
    
    public CaesarCipherTwo(int key1, int key2){
        alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        shiftedAlphabet1 = alphabet.substring(key1)+ alphabet.substring(0,key1);
        shiftedAlphabet2 = alphabet.substring(key2)+ alphabet.substring(0,key2);        
        keys[0] = key1;
        keys[1] = key2;
    }
    
    public String encrypt(String input){
        StringBuilder encrypted = new StringBuilder(input);
        for(int i = 0; i < encrypted.length(); i++) {
            if((i % 2) == 0){
                encrypted = cco.replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet1);
            }else{
                encrypted = cco.replaceCharProcess(i, alphabet, encrypted, shiftedAlphabet2);
            }
        }
        return encrypted.toString();
    }

    public String decrypt(String input) {
        CaesarCipherTwo cc = new CaesarCipherTwo(26 - keys[0], 26 - keys[1]);
        return cc.encrypt(input);
    }
}
