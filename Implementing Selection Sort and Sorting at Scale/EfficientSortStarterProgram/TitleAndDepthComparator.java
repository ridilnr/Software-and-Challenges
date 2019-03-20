import java.util.*;
/**
 * Write a description of TitleAndDepthComparator here.
 * 
 * @author RIDILUAMBA
 * @version 27/10/2018
 */
public class TitleAndDepthComparator implements Comparator<QuakeEntry>{
    
    public int compare(QuakeEntry q1, QuakeEntry q2) {
        if(q1.getInfo().equals(q2.getInfo())){
            return Double.compare(q1.getDepth(), q2.getDepth());
        }
        return q1.getInfo().compareTo(q2.getInfo());
    }
    
}

