import java.util.*;
/**
 * Write a description of LargestQuakes here.
 * 
 * @author RIDI LUAMBA
 * @version 26/10/2018
 */
public class LargestQuakes {
    
    String source = "data/nov20quakedata.atom";
    
    public void findLargestQuakes(){
        EarthQuakeParser parser = new EarthQuakeParser();
        ArrayList<QuakeEntry> list  = parser.read(source);
        int num = 50;
        int idxLargest = indexOfLargest(list);
        QuakeEntry largestQuake = list.get(idxLargest);
        ArrayList<QuakeEntry> listLargest = getLargest(list, num);
        /*for (QuakeEntry qe : list) {
            System.out.println(qe);
        }*/
        /*System.out.println("Index of largest magnitude earthquake is "+idxLargest);
        System.out.println(largestQuake);*/
        System.out.println("The "+num+" largest earthquakes are :");
        for (QuakeEntry qe : listLargest) {
            System.out.println(qe);
        }
        /*for(int j=0; j<50; j++){
            System.out.println(listLargest.get(j));
        }*/
        System.out.println("# quakes read: " + list.size());
    }
    
    public int indexOfLargest(ArrayList<QuakeEntry> quakeData){
        int indexLargest = 0;
        QuakeEntry largestQuake = quakeData.get(0);
        for (int k = 0; k < quakeData.size(); k++) {
            if(quakeData.get(k).getMagnitude() > largestQuake.getMagnitude()){
                largestQuake = quakeData.get(k);
                indexLargest = k;
            }
        }
        return indexLargest;
    }
    
    public ArrayList<QuakeEntry> getLargest(ArrayList<QuakeEntry> quakeData, int howMany){
        QuakeEntry tempQuake;
        ArrayList<QuakeEntry> sortedQuakes = new ArrayList<QuakeEntry>();
        for(int i = 0; i < quakeData.size(); i++) {
            int maxIdx = indexOfLargest(quakeData);
            if(sortedQuakes.contains(quakeData.get(maxIdx))){
                quakeData.remove(maxIdx);
            }else{
                sortedQuakes.add(quakeData.get(maxIdx));
            }
                
        }
        /*for(int i = 0; i < quakeData.size(); i++) {
            
            for(int j = i+1; j < quakeData.size(); j++){
                if(quakeData.get(i).getMagnitude() < quakeData.get(j).getMagnitude()){
                    tempQuake = quakeData.get(i);
                    quakeData.set(i, quakeData.get(j));
                    quakeData.set(j, tempQuake);
                }
            }
        }
        
        for(int j = 0; j < howMany; j++){
            sortedQuakes.add(quakeData.get(j));
        }*/
        
        return sortedQuakes;
    }
}
