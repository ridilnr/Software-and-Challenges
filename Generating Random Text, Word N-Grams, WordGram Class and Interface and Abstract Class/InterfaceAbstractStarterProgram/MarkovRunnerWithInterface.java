
/**
 * Write a description of class MarkovRunner here.
 * 
 * @author Duke Software
 * @version 1.0
 */

import edu.duke.*; 
import java.text.*;
public class MarkovRunnerWithInterface {
    
    public void runModel(IMarkovModel markov, String text, int size, int seed) {
        markov.setTraining(text);
        markov.setRandom(seed);
        System.out.println("running with " + markov);
        for(int k=0; k < 3; k++){
            String st= markov.getRandomText(size);
            printOut(st);
        }
    }
    
    public void runMarkov() {
        FileResource fr = new FileResource();
        String st = fr.asString();
        st = st.replace('\n', ' ');
        int size = 200;
        int seed = 45;
        
        MarkovZero mz = new MarkovZero();
        runModel(mz, st, size, seed);
    
        MarkovOne mOne = new MarkovOne();
        runModel(mOne, st, size, seed);
        
        MarkovModel mThree = new MarkovModel(3);
        runModel(mThree, st, size, seed);
        
        MarkovFour mFour = new MarkovFour();
        runModel(mFour, st, size, seed);

    }
    
    public void testHashMap(){
        FileResource fr = new FileResource(); 
        String st = fr.asString(); 
        //String st = "yes-this-is-a-thin-pretty-pink-thistle";
        int order = 5;
        int size = 100;
        int seed = 531;
        EfficientMarkovModel emm = new EfficientMarkovModel(order);
        runModel(emm, st, size, seed);
    }
    
    public void compareMethods(){
        FileResource fr = new FileResource(); 
        String st = fr.asString(); 
        //String st = "yes-this-is-a-thin-pretty-pink-thistle";
        st = st.replace('\n', ' ');
        int seed = 42;
        int size = 1000;
        int order = 2;
        MarkovModel mm = new MarkovModel(order);
        runModel(mm, st, size, seed); 
        System.out.println("************************************************************");
        System.out.println("Time consumed by MarkovWord is: "+new DecimalFormat("0.0000 sec").format(mm.getTiming()));
        System.out.println("************************************************************");
        //
        EfficientMarkovModel emm = new EfficientMarkovModel(order); 
        runModel(emm, st, size, seed);
        System.out.println("************************************************************");
        System.out.println("Time consumed by EfficientMarkovWord is: "+new DecimalFormat("0.0000 sec").format(emm.getTiming()));
        System.out.println("************************************************************");
    }
    
    private void printOut(String s){
        String[] words = s.split("\\s+");
        int psize = 0;
        System.out.println("----------------------------------");
        for(int k=0; k < words.length; k++){
            System.out.print(words[k]+ " ");
            psize += words[k].length() + 1;
            if (psize > 60) {
                System.out.println();
                psize = 0;
            }
        }
        System.out.println("\n----------------------------------");
    }
    
}
