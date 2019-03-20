//import java.io.*;
/**
 * Write a description of PhraseFilter here.
 * 
 * @author RIDI LUAMBA 
 * @version 26/10/2018
 */
public class PhraseFilter implements Filter {
    private String phrase;
    private String where;
    private String nameFilter;
    PhraseFilter(String p, String w, String nf){
        phrase = p;
        where = w;
        nameFilter = nf;
    }
    
    public boolean satisfies(QuakeEntry qe) {
        if(where.equals("start")){
            return (qe.getInfo().startsWith(phrase));
        }else if(where.equals("end")){
            return (qe.getInfo().endsWith(phrase));
        }else if(where.equals("any")){
            return (qe.getInfo().indexOf(phrase) != -1);
        }
        return false;
    }
    
    public String getName(){
        return nameFilter;
    }
    
}
