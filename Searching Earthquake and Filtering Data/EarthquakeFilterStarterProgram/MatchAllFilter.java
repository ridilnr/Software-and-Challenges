import java.util.*;
/**
 * Write a description of MatchAllFilter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public class MatchAllFilter implements Filter{
    
    private ArrayList<Filter> filters;
    
    public MatchAllFilter(){
        filters = new ArrayList<Filter>();
    }
    
    public void addFilter(Filter f){
        filters.add(f);
    }
    
    public boolean satisfies(QuakeEntry qe) {
        for(Filter f : filters){
            if(!f.satisfies(qe)){
                return false;
            }
        }
        return true;
    }
    
    public String getName(){
        String allFiltersName = "";
        for(Filter f : filters){
            allFiltersName += f.getName()+" ";
        }
        return allFiltersName;
    }
    
}
