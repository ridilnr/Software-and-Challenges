
/**
 * Write a description of WordPlay here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

public class WordPlay {
    
    public boolean isVowel(char ch){
        char newCh = Character.toLowerCase(ch);
        if(newCh == 'a' || newCh == 'e' || newCh == 'i' || newCh == 'o' || newCh == 'u'){
            return true;
        }else{
            return false;
        }
    }
    
    public String replaceVowels(String phrase, char ch){
        StringBuilder newPhrase = new StringBuilder(phrase);
        
        for(int i = 0; i < newPhrase.length(); i++) {
            char currChar = newPhrase.charAt(i);
            boolean checkVowel = isVowel(currChar);
            if(checkVowel){
                newPhrase.setCharAt(i, ch);
            }
        }
        return newPhrase.toString();
    }
    
    public String emphasize(String phrase, char ch){
        StringBuilder newPhrase = new StringBuilder(phrase);
        
        for(int i = 0; i < newPhrase.length(); i++) {
            char currChar = newPhrase.charAt(i);
            char tempCurrChar = Character.toLowerCase(currChar);
            char tempCh = Character.toLowerCase(ch);
            boolean checkVowel = isVowel(currChar);
            if(checkVowel && (tempCurrChar == tempCh)){
                if((i+1)%2 != 0){
                    newPhrase.setCharAt(i, '*');
                }else{
                    newPhrase.setCharAt(i, '+');
                }
            }
        }
        return newPhrase.toString();
    }
    
    public void testIsVowel(){
        boolean test1 = isVowel('A');
        boolean test2 = isVowel('e');
        boolean test3 = isVowel('F');
        if(test1)   System.out.println("A is a vowel");
        else    System.out.println("A is not a vowel");
        if(test2)   System.out.println("e is a vowel");
        else    System.out.println("e is not a vowel");
        if(test3)   System.out.println("F is a vowel");
        else    System.out.println("F is not a vowel");
    }
    
    public void testReplaceVowels(){
        String strVal = "Hello World";
        System.out.println("Old string value : " + strVal);
        System.out.println("New string value : " + replaceVowels(strVal, '*'));
    }
    
    public void testEmphasize(){
        String strVal1 = "dna ctgaaactga";
        String strVal2 = "Mary Bella Abracadabra";        
        System.out.println("Old string value : " + strVal1);
        System.out.println("New string value : " + emphasize(strVal1, 'a'));
        System.out.println("-------------------------------------------------");
        System.out.println("Old string value : " + strVal2);
        System.out.println("New string value : " + emphasize(strVal2, 'a'));
    }
}
