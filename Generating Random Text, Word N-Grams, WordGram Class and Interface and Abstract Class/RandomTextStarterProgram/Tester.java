import java.util.*;
import edu.duke.*;
/**
 * Write a description of Tester here.
 * 
 * @author RIDI LUAMBA
 * @version 28/10/2018
 */
public class Tester {
    
    public void testGetFollows(){
        String st = "this is a test yes this is a test.";
        st = st.replace('\n', ' ');
        MarkovOne markov = new MarkovOne();
        markov.setTraining(st);
        ArrayList<String> getCharList = markov.getFollows("t");
        System.out.println("Size of array is " + getCharList.size());
        for(String s : getCharList){
            System.out.println(s);
        }
    }
    
    public void testGetFollowsWithFile(){
        MarkovOne mo = new MarkovOne();
        FileResource fr = new FileResource();
        String st = fr.asString();
        st = st.replace('\n', ' ');
        MarkovOne markov = new MarkovOne();
        markov.setTraining(st);
        ArrayList<String> getCharList = markov.getFollows("he");
        System.out.println("Size of array is " + getCharList.size());
    }
}
