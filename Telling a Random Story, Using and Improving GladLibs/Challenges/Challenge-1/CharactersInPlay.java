
/**
 * Write a description of CharactersInPlay here.
 * 
 * @author RIDI LUAMBA 
 * @version 17/10/2018
 */
import edu.duke.*;
import java.util.ArrayList;

public class CharactersInPlay {
    
    ArrayList<String> characters;
    ArrayList<Integer> fregsChar;
    
    public CharactersInPlay(){
        characters = new ArrayList<String>();
        fregsChar = new ArrayList<Integer>();
    }
    
    public void update(String person){
        int index = characters.indexOf(person);
        if (index == -1){
            characters.add(person);
            fregsChar.add(1);
        }
        else {
            int freq = fregsChar.get(index);
            fregsChar.set(index,freq+1);
        }
    }
    
    public void findAllCharacters(){
        characters.clear();
        fregsChar.clear();
        FileResource resource = new FileResource();
        
        for(String line : resource.lines()){
            int idxFstPeriod = line.indexOf('.');
            if(idxFstPeriod != -1){
                String character = line.substring(0, idxFstPeriod);
                update(character);
            }
        }
    }
    
    public void charactersWithNumParts(int num1, int num2){
        for(int k = 0; k < characters.size(); k++){
            int numSpeaking = fregsChar.get(k);
            if((numSpeaking >= num1) && (numSpeaking <= num2)){
                System.out.println(characters.get(k) + "\t" + fregsChar.get(k));
            }
        }
    }
    
    public void tester(){
        findAllCharacters();
        charactersWithNumParts(10, 15);
    }
}
