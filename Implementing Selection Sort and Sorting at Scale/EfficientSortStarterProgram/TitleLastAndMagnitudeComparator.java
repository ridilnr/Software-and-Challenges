import java.util.*;
import java.io.*;
/**
 * Write a description of TitleLastAndMagnitudeComparator here.
 * 
 * @author RIDILUAMBA
 * @version 27/10/2018
 */
public class TitleLastAndMagnitudeComparator implements Comparator<QuakeEntry>{
    
    public int compare(QuakeEntry q1, QuakeEntry q2) {
        String[] wordsTitle1 = q1.getInfo().split(" ");
        String[] wordsTitle2 = q2.getInfo().split(" ");
        String lastWordTitle1 = wordsTitle1[wordsTitle1.length-1];
        String lastWordTitle2 = wordsTitle2[wordsTitle2.length-1];
        if(lastWordTitle1.equals(lastWordTitle2)){
            return Double.compare(q1.getMagnitude(), q2.getMagnitude());
        }
        return lastWordTitle1.compareTo(lastWordTitle2);
    }
}
