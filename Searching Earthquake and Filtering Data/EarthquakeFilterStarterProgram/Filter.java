
/**
 * Write a description of interface Filter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public interface Filter
{
    public  boolean satisfies(QuakeEntry qe);
    
    public String getName();
}
