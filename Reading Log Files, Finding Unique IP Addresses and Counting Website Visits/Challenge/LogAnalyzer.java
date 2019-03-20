
/**
 * Write a description of class LogAnalyzer here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

import java.util.*;
import edu.duke.*;
import java.io.*;

public class LogAnalyzer
{
     private ArrayList<LogEntry> records;
     private ArrayList<String> uniqueIPs;
     private ArrayList<String> uniqueIPVisitsOnDay;
     private ArrayList<String> uniqueIPsInRange;
     private ArrayList<String> sameMaxNumVisitsIP;
     private ArrayList<String> arrayIPAddress;
     private HashMap<String,Integer> counts;
     private HashMap<String,ArrayList<String>> mapDaysWithArrayIPs;
     
     public LogAnalyzer() {
         records = new ArrayList<LogEntry>();
         uniqueIPs = new ArrayList<String>();
         uniqueIPVisitsOnDay = new ArrayList<String>();
         uniqueIPsInRange = new ArrayList<String>();
         counts = new HashMap<String,Integer>();
         sameMaxNumVisitsIP = new ArrayList<String>();
         mapDaysWithArrayIPs = new HashMap<String,ArrayList<String>>();
         arrayIPAddress = new ArrayList<String>();
     }
        
     public void readFile(String filename) {
         FileResource fr = new FileResource(filename);
         for(String line : fr.lines()){
             records.add(WebLogParser.parseEntry(line));
         }
     }
        
     public void printAll() {
         for (LogEntry le : records) {
             System.out.println(le);
         }
     }
     
     public int countUniqueIPs(){
         for(LogEntry le: records){
             String ipAddr = le.getIpAddress();
             if(!uniqueIPs.contains(ipAddr)){
                 uniqueIPs.add(ipAddr);
             }
         }
         return uniqueIPs.size();
     }
     
     public void printAllHigherThanNum(int num){
        for(LogEntry le : records){
             int statusCode = le.getStatusCode();
             if(statusCode > num){
                 System.out.println(le);
             }
         }
     }
     
     public ArrayList<String> uniqueIPVisitsOnDay(String someday){
         uniqueIPVisitsOnDay.clear();
         for(LogEntry le : records){
             String recDay = (le.getAccessTime()).toString();
             String ipAddr = le.getIpAddress();
             if(recDay.contains(someday) && !(uniqueIPVisitsOnDay.contains(ipAddr))){
                 uniqueIPVisitsOnDay.add(ipAddr);
             }
         }
         return uniqueIPVisitsOnDay;
     }
     
     public int countUniqueIPsInRange(int low, int high){
         for(LogEntry le : records){
             int statusCode = le.getStatusCode();
             String ipAddr = le.getIpAddress();
             if(((statusCode >= low) && (statusCode <= high)) && !(uniqueIPsInRange.contains(ipAddr))){
                 uniqueIPsInRange.add(ipAddr);
             }
         }
         return uniqueIPsInRange.size();
     }
     
     public HashMap<String,Integer> countVisitsPerIP(){
         counts.clear();
         for(LogEntry le: records){
             String ip = le.getIpAddress();
             if(! counts.containsKey(ip)){
                 counts.put(ip,1);
             }else{
                 counts.put(ip,counts.get(ip) + 1);
             }
         }
         return counts;
     }
     
     public int mostNumberVisitsByIP(HashMap<String,Integer> counts){
         int maxIPVisits = 1;
         for(String s : counts.keySet()){
             int numIPVisit = counts.get(s);
             if(numIPVisit > maxIPVisits){
                 maxIPVisits = numIPVisit;
             }
         }
         return maxIPVisits;
     }
     
     public ArrayList<String> iPsMostVisits(HashMap<String,Integer> counts){
         sameMaxNumVisitsIP.clear();
         int maxIPVisits = mostNumberVisitsByIP(counts);
         for(String s : counts.keySet()){
             if((maxIPVisits == counts.get(s)) && (! sameMaxNumVisitsIP.contains(s))){
                 sameMaxNumVisitsIP.add(s);
             }
         }
         return sameMaxNumVisitsIP;
     }
     
     public HashMap<String,ArrayList<String>> iPsForDays(){
         mapDaysWithArrayIPs.clear();
         for(LogEntry le: records){
             String ip = le.getIpAddress();
             String day = ((le.getAccessTime()).toString()).substring(4, 10);
             if(! mapDaysWithArrayIPs.containsKey(day)){
                 ArrayList<String> ipArray = new ArrayList<String>();
                 ipArray.add(ip);
                 mapDaysWithArrayIPs.put(day,ipArray);
             }else{
                 ArrayList<String> ipArray = mapDaysWithArrayIPs.get(day);
                 ipArray.add(ip);
                 mapDaysWithArrayIPs.put(day,ipArray);
             }
         }
        return mapDaysWithArrayIPs;
    }
    
    public String dayWithMostIPVisits(HashMap<String, ArrayList<String>> mapDaysWithArrayIPs){
        int mostIPOnDay = 1;
        String dayWithMostIP = "";
        for(String s : mapDaysWithArrayIPs.keySet()){
            int numIPsOnCurrDay = (mapDaysWithArrayIPs.get(s)).size();
            if(mostIPOnDay < numIPsOnCurrDay){
                mostIPOnDay = numIPsOnCurrDay;
                dayWithMostIP = s;
            }
        }
        return dayWithMostIP;
    }
    
    public ArrayList<String> iPsWithMostVisitsOnDay(HashMap<String, ArrayList<String>> mapDaysWithArrayIPs, String someDay){
        HashMap<String, Integer> mapIPWithFregs= new HashMap<String, Integer>();
        for(String s : mapDaysWithArrayIPs.keySet()){
            if(s.equals(someDay)){
                for(String ipAddress : mapDaysWithArrayIPs.get(s)){
                    if(! mapIPWithFregs.containsKey(ipAddress)){
                         mapIPWithFregs.put(ipAddress,1);
                     }else{
                         mapIPWithFregs.put(ipAddress,mapIPWithFregs.get(ipAddress)+1);
                     }
                }
                return iPsMostVisits(mapIPWithFregs);
            }
        }
        return null;
    }
}
