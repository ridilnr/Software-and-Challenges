
/**
 * Write a description of class MarkovRunner here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

import edu.duke.*;
import java.text.*;
public class MarkovRunner {
    
    public void runModel(IMarkovModel markov, String text, int size){ 
        markov.setTraining(text); 
        System.out.println("running with " + markov); 
        for(int k=0; k < 3; k++){ 
            String st = markov.getRandomText(size); 
            printOut(st); 
        } 
    } 

    public void runModel(IMarkovModel markov, String text, int size, int seed){ 
        markov.setTraining(text); 
        markov.setRandom(seed);
        System.out.println("running with " + markov); 
        for(int k=0; k < 1; k++){ 
            String st = markov.getRandomText(size); 
            printOut(st); 
        } 
    } 

    public void runMarkov() { 
        FileResource fr = new FileResource(); 
        String st = fr.asString(); 
        st = st.replace('\n', ' ');
        int order = 5;
        int seed = 844;
        int size = 200;
        MarkovWord mw = new MarkovWord(order);
        runModel(mw, st, size, seed);
    } 
    
    public void testHashMap(){
        FileResource fr = new FileResource(); 
        String st = fr.asString(); 
        //String st = "this is a test yes this is really a test";
        //String st = "this is a test yes this is really a test yes a test this is wow";
        st = st.replace('\n', ' ');
        int order = 3;
        int seed = 371;
        int size = 50;
        EfficientMarkovWord emw = new EfficientMarkovWord(order); 
        runModel(emw, st, size, seed);
    }
    
    public void compareMethods(){
        FileResource fr = new FileResource(); 
        String st = fr.asString(); 
        st = st.replace('\n', ' ');
        int seed = 42;
        int size = 100;
        int order = 2;
        /*MarkovWord mw = new MarkovWord(order);
        long startTime = System.nanoTime();
        runModel(mw, st, size, seed); 
        long endTime = System.nanoTime();
        System.out.println("************************************************************");
        System.out.println("Time consumed by MarkovWord is: "+new DecimalFormat("0.00 sec").format(System.nanoTime()/1000000000.0));
        System.out.println("************************************************************");*/
        //
        EfficientMarkovWord emw = new EfficientMarkovWord(order); 
        long startTime = System.nanoTime();
        runModel(emw, st, size, seed);
        long endTime = System.nanoTime();
        System.out.println("************************************************************");
        System.out.println("Time consumed by EfficientMarkovWord is: "+new DecimalFormat("0.00 sec").format(System.nanoTime()/1000000000.0));
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
