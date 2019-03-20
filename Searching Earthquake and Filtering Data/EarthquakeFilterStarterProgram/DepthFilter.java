
/**
 * Write a description of DepthFilter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public class DepthFilter implements Filter{
    
    private double minDepth;
    private double maxDepth;
    private String nameFilter;
    
    public DepthFilter(double min, double max, String nf){
        minDepth = min;
        maxDepth = max;
        nameFilter = nf;
    }
    
    public boolean satisfies(QuakeEntry qe) { 
        return (qe.getDepth() >= minDepth && 
                qe.getDepth() <= maxDepth); 
    }
    
    public String getName(){
        return nameFilter;
    }
}
