
/**
 * Write a description of class QuakeSortInPlace here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

import java.util.*;
import edu.duke.*;

public class QuakeSortInPlace {
    
    String source = "data/earthQuakeDataWeekDec6sample2.atom";
    
    public QuakeSortInPlace() {
        // TODO Auto-generated constructor stub
    }
   
    public int getSmallestMagnitude(ArrayList<QuakeEntry> quakes, int from) {
        int minIdx = from;
        for (int i=from+1; i< quakes.size(); i++) {
            if (quakes.get(i).getMagnitude() < quakes.get(minIdx).getMagnitude()) {
                minIdx = i;
            }
        }
        return minIdx;
    }
    
    public void sortByMagnitude(ArrayList<QuakeEntry> in) {
      
       for (int i=0; i< in.size(); i++) {
            int minIdx = getSmallestMagnitude(in,i);
            swapEarthQuakes(in, i, minIdx);
        }
        
    }
    
    public int getLargestDepth(ArrayList<QuakeEntry> quakeData, int from) {
        int maxIdx = from;
        for (int i = from+1; i < quakeData.size(); i++) {
            if (quakeData.get(i).getDepth() > quakeData.get(maxIdx).getDepth()) {
                maxIdx = i;
            }
        }
        return maxIdx;
    }
    
    public void sortByLargestDepth(ArrayList<QuakeEntry> in) {
      
       for (int i=0; i < in.size(); i++) {
            int maxIdx = getLargestDepth(in,i);
            swapEarthQuakes(in, i, maxIdx);
            System.out.println("\nPrinting Quakes after pass "+(i+1));
            printEarthQuakes(in);
       }
        
    }
    
    public void onePassBubbleSort(ArrayList<QuakeEntry> quakeData, int numSorted){
        for (int i = 0; i < quakeData.size()-numSorted; i++){
            if (quakeData.get(i).getMagnitude() > quakeData.get(i+1).getMagnitude()){
                swapEarthQuakes(quakeData, i, i+1);
            }
        }
    }
    
    public void sortByMagnitudeWithBubbleSort(ArrayList<QuakeEntry> in){
        for(int j = 0; j < in.size()-1; j++){
            System.out.println("\nPrinting Quakes after pass "+j);
            onePassBubbleSort(in, j+1);
            printEarthQuakes(in);
        }
    }
    
    public boolean checkInSortedOrder(ArrayList<QuakeEntry> quakes){
        for(int j = 0; j < quakes.size()-1; j++){
            if(quakes.get(j).getMagnitude() > quakes.get(j+1).getMagnitude()){
                return false;
            }
        }
        return true;
    }
  
    public void sortByMagnitudeWithBubbleSortWithCheck(ArrayList<QuakeEntry> in){
        int count = 0;
        for(int j = 0; j < in.size()-1; j++){
            if(checkInSortedOrder(in)){
                break;
            }else{
                //System.out.println("\nPrinting Quakes after pass "+j);
                onePassBubbleSort(in, j+1);
                //printEarthQuakes(in);
                count++;
            }
        }
        System.out.println("\n"+count+" passes were needed to sort elements");
    }
  
    public void sortByMagnitudeWithCheck(ArrayList<QuakeEntry> in){
        int count = 0;
        
        for (int i=0; i< in.size(); i++) {
            if(checkInSortedOrder(in)){
                break;
            }else{
                int minIdx = getSmallestMagnitude(in,i);
                swapEarthQuakes(in, i, minIdx);
                count++;
            }
            //System.out.println("\nPrinting Quakes after pass "+i);
            //printEarthQuakes(in);
        }
        System.out.println("\n"+count+" passes were needed to sort elements");
    }
    
    public void swapEarthQuakes(ArrayList<QuakeEntry> in, int idx1, int idx2){
        QuakeEntry qi = in.get(idx1);
        QuakeEntry qmin = in.get(idx2);
        in.set(idx1,qmin);
        in.set(idx2,qi);
    }
 
    public void testSort() {
        EarthQuakeParser parser = new EarthQuakeParser(); 
        //String source = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.atom";
        //String source = "data/nov20quakedata.atom";
        ArrayList<QuakeEntry> list  = parser.read(source);  
       
        System.out.println("read data for "+list.size()+" quakes");    
        //sortByMagnitude(list);
        //sortByLargestDepth(list);
        //System.out.println("\nEarthQuakes unsorted");
        //printEarthQuakes(list);
        //sortByMagnitudeWithBubbleSort(list);
        sortByMagnitudeWithBubbleSortWithCheck(list);
        //sortByMagnitudeWithCheck(list);
        //System.out.println("\nEarthQuakes in sorted order:");
        //printEarthQuakes(list); 
    }
    
    public void printEarthQuakes(ArrayList<QuakeEntry> quake){
        for (QuakeEntry qe: quake) { 
            System.out.println(qe);
        }
    }
    
    public void createCSV() {
        EarthQuakeParser parser = new EarthQuakeParser();
        String source = "data/nov20quakedatasmall.atom";
        //String source = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.atom";
        ArrayList<QuakeEntry> list  = parser.read(source);
        dumpCSV(list);
        System.out.println("# quakes read: " + list.size());
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
}
