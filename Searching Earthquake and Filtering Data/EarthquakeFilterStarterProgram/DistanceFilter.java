
/**
 * Write a description of DistanceFilter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public class DistanceFilter implements Filter {
    
    private Location location;
    private double maxDist;
    private String nameFilter;
    public DistanceFilter(Location loc, double dist, String nf){
        location = loc;
        maxDist = dist;
        nameFilter = nf;
    }
    
    public boolean satisfies(QuakeEntry qe) { 
        return (qe.getLocation().distanceTo(location) < maxDist); 
    }
    
    public String getName(){
        return nameFilter;
    }
    
}
