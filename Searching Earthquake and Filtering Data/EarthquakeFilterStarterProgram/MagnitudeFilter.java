
/**
 * Write a description of MagnitudeFilter here.
 * 
 * @author RIDI LUAMBA
 * @version 26/10/2018
 */
public class MagnitudeFilter implements Filter {
    
    private double minMag;
    private double maxMag;
    private String nameFilter;
    public MagnitudeFilter(double min, double max, String nf){
        minMag = min;
        maxMag = max;
        nameFilter = nf;
    }
    
    public boolean satisfies(QuakeEntry qe) { 
        return (qe.getMagnitude() >= minMag && 
                qe.getMagnitude() <= maxMag); 
    }
    
    public String getName(){
        return nameFilter;
    }
    
}
