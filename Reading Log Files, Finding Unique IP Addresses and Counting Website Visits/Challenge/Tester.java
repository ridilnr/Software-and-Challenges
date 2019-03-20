
/**
 * Write a description of class Tester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
import java.io.*;
public class Tester
{
    private String fileName = "weblog2_log";
    
    public void testLogEntry() {
        LogEntry le = new LogEntry("1.2.3.4", new Date(), "example request", 200, 500);
        System.out.println(le);
        LogEntry le2 = new LogEntry("1.2.100.4", new Date(), "example request 2", 300, 400);
        System.out.println(le2);
    }
    
    public void testLogAnalyzer() {
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        la.printAll();
    }
    
    public void testUniqIP(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        int uniqueIPs = la.countUniqueIPs();
        System.out.println("There are " + uniqueIPs + " IPs");
    }
    
    public void testHigherStatusCode(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        la.printAllHigherThanNum(400);
    }
    
    public void testUniqueIPVisitsOnDay(){
        LogAnalyzer la = new LogAnalyzer();
        ArrayList<String> uniqueIpOnDay = new ArrayList<String>();
        la.readFile(fileName);
        String day = "Sep 24";
        uniqueIpOnDay = la.uniqueIPVisitsOnDay(day);
        System.out.println("Number of unique IP visits on "+day+" is: " + uniqueIpOnDay.size());
        uniqueIpOnDay.clear();
    }
    
    public void testCountUniqueIPsInRange(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        int[] range = {400,499};
        int countUniqIPInRange = la.countUniqueIPsInRange(range[0],range[1]);
        System.out.println("Number of unique IP in range "+range[0]+" and "+range[1]+" is: "+countUniqIPInRange);
    }
    
    public void testCounts(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        HashMap<String,Integer> counts = la.countVisitsPerIP();
        System.out.println(counts);
    }
    
    public void testMostNumberVisitsByIP(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        HashMap<String,Integer> counts = la.countVisitsPerIP();
        int maxNumVisitsIP = la.mostNumberVisitsByIP(counts);
        System.out.println("Max Number of visits by IP address is : "+maxNumVisitsIP);
    }
    
    public void testIPsMostVisits(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        ArrayList<String> ipAddressArray = la.iPsMostVisits(la.countVisitsPerIP());
        for(String ip : ipAddressArray){
             System.out.println(ip);
        }
    }
    
    public void testIPsForDays(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        HashMap<String,ArrayList<String>> daysWithArrayIP = la.iPsForDays();
        System.out.println(daysWithArrayIP);
    }
    
    public void testDayWithMostIPVisits(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        String dayWithMostIPs = la.dayWithMostIPVisits(la.iPsForDays());
        System.out.println("The day with most IP address visits is : " + dayWithMostIPs);
    }
    
    public void testIPsWithMostVisitsOnDay(){
        LogAnalyzer la = new LogAnalyzer();
        la.readFile(fileName);
        String day = "Sep 30";
        ArrayList<String> arrayIPAddress = la.iPsWithMostVisitsOnDay(la.iPsForDays(), day);
        System.out.println(arrayIPAddress);
    }
}
