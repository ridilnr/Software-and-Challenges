import edu.duke.*;
/** 
 * @author RIDI LUAMBA
 * @version 17/10/2018
 */

public class TestCaesarCipherTwo {
    public String breakCaesarCipher(String input){
        CaesarBreaker cb = new CaesarBreaker();
        String[] halfOfString = new String[2];
        int[] keys = new int[2];
        halfOfString[0] = cb.halfOfString(input, 0);
        halfOfString[1] = cb.halfOfString(input, 1);        
        keys[0] = (26 - cb.getKey(halfOfString[0]));
        keys[1] = (26 - cb.getKey(halfOfString[1]));
        CaesarCipherTwo cct = new CaesarCipherTwo(26 - keys[0], 26 - keys[1]);
        return cct.decrypt(input);
    }
    
    public void simpleTests(){
        FileResource fr = new FileResource();
        CaesarCipherTwo cct = new CaesarCipherTwo(21,8);
        String message = fr.asString();
        String encrypted = cct.encrypt(message);
        String decrypted1 = cct.decrypt(encrypted);
        String decrypted2 = breakCaesarCipher(encrypted);
        System.out.println("Message : \n" + message);
        System.out.println("Encrypted message : \n" + encrypted);
        System.out.println("Decrypted message with known key : \n" + decrypted1);
        System.out.println("Decrypted message with unknown key : \n" + decrypted2);        
    }
}
