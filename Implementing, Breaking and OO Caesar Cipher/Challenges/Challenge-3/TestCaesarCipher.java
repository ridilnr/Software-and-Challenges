import edu.duke.*;
/** 
 * @author RIDI LUAMBA
 * @version 16/10/2018
 */

public class TestCaesarCipher {
    
    public String breakCaesarCipher(String input){
        CaesarBreaker cb = new CaesarBreaker();
        int[] fregs = cb.countLetters(input);
        int maxDex = cb.maxIndex(fregs);
        int dkey = maxDex - 4;
        if(maxDex < 4){
            dkey = 26 - (4 - maxDex);
        }
        CaesarCipher cc = new CaesarCipher(dkey);
        return cc.decrypt(input);
    }
    
    public void simpleTests(){
        FileResource fr = new FileResource();
        CaesarCipher cc = new CaesarCipher(18);
        String message = fr.asString();
        String encrypted = cc.encrypt(message);
        String decrypted1 = cc.decrypt(encrypted);
        String decrypted2 = breakCaesarCipher(encrypted);
        System.out.println("Message : \n" + message);
        System.out.println("Encrypted message : \n" + encrypted);
        System.out.println("Decrypted message with known key : \n" + decrypted1);
        System.out.println("Decrypted message with unknown key : \n" + decrypted2);        
    }
}
