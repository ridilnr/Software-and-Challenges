import java.util.*;
import edu.duke.*;

public class EarthQuakeClient2 {
    
    String source = "data/nov20quakedata.atom";
    
    public EarthQuakeClient2() {
        // TODO Auto-generated constructor stub
    }

    public ArrayList<QuakeEntry> filter(ArrayList<QuakeEntry> quakeData, Filter f) { 
        ArrayList<QuakeEntry> answer = new ArrayList<QuakeEntry>();
        for(QuakeEntry qe : quakeData) { 
            if (f.satisfies(qe)) { 
                answer.add(qe); 
            } 
        } 
        
        return answer;
    } 

    public void quakesWithFilter() { 
        EarthQuakeParser parser = new EarthQuakeParser(); 
        //String source = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.atom";
        ArrayList<QuakeEntry> list  = parser.read(source);         
        System.out.println("read data for "+list.size()+" quakes");
        
        Location city = new Location(39.7392, -104.9903);
        double distance = 1000000;
        //Filter f = new MinMagFilter(4.0); 
        Filter f1 = new MagnitudeFilter(3.5, 4.5, "Magnitude");         
        Filter f2 = new DepthFilter(-55000.0, -20000.0, "Depth");
        //Filter f3 = new DistanceFilter(city, distance, "Distance");        
        //Filter f4 = new PhraseFilter("a", "end", "Phrase");        
        ArrayList<QuakeEntry> m7  = filter(list, f1);
        m7  = filter(m7, f2); 
        for (QuakeEntry qe: m7) { 
            System.out.println(qe);
        }
        System.out.println("Found "+m7.size()+" earthquakes that match those criteria");
    }

    public void createCSV() {
        EarthQuakeParser parser = new EarthQuakeParser();
        //String source = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.atom";
        ArrayList<QuakeEntry> list  = parser.read(source);
        dumpCSV(list);
        System.out.println("# quakes read: "+list.size());
    }

    public void dumpCSV(ArrayList<QuakeEntry> list) {
        System.out.println("Latitude,Longitude,Magnitude,Info");
        for(QuakeEntry qe : list){
            System.out.printf("%4.2f,%4.2f,%4.2f,%s\n",
                qe.getLocation().getLatitude(),
                qe.getLocation().getLongitude(),
                qe.getMagnitude(),
                qe.getInfo());
        }
    }
    
    public void testMatchAllFilter(){
        EarthQuakeParser parser = new EarthQuakeParser();
        ArrayList<QuakeEntry> list  = parser.read(source);
        /*for (QuakeEntry qe: list) { 
            System.out.println(qe);
        }*/
        System.out.println("# quakes read: "+list.size());
        MatchAllFilter maf = new MatchAllFilter();
        maf.addFilter(new MagnitudeFilter(1.0, 4.0, "Magnitude"));
        maf.addFilter(new DepthFilter(-180000.0, -30000.0, "Depth"));
        maf.addFilter(new PhraseFilter("o", "any", "Phrase"));
        ArrayList<QuakeEntry> m7 = filter(list, maf);
        for (QuakeEntry qe: m7) { 
            System.out.println(qe);
        }
        System.out.println("Found "+m7.size()+" earthquakes that match those criteria");
        System.out.println("Filters used are: "+maf.getName());
    }
    
    public void testMatchAllFilter2(){
        EarthQuakeParser parser = new EarthQuakeParser();
        ArrayList<QuakeEntry> list  = parser.read(source);
        /*for (QuakeEntry qe: list) { 
            System.out.println(qe);
        }*/
        System.out.println("# quakes read: "+list.size());
        Location city = new Location(55.7308, 9.1153);
        double distance = 3000000.0;
        MatchAllFilter maf = new MatchAllFilter();
        maf.addFilter(new MagnitudeFilter(0.0, 5.0, "Magnitude"));
        maf.addFilter(new DistanceFilter(city, distance, "Distance"));
        maf.addFilter(new PhraseFilter("e", "any", "Phrase"));
        ArrayList<QuakeEntry> m7 = filter(list, maf);
        for (QuakeEntry qe: m7) { 
            System.out.println(qe);
        }
        System.out.println("Found "+m7.size()+" earthquakes that match those criteria");
        System.out.println("Filters used are: "+maf.getName());
    }
}
