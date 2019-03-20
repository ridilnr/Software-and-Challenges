
/**
 * Write a description of class MinMaxFilter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public class MinMagFilter implements Filter
{
    private double magMin; 
    private String nameFilter;
    public MinMagFilter(double min, String nf) { 
        magMin = min;
        nameFilter = nf;
    } 

    public boolean satisfies(QuakeEntry qe) { 
        return qe.getMagnitude() >= magMin; 
    } 
    
    public String getName(){
        return nameFilter;
    }
    
}
