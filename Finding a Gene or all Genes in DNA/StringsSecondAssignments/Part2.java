
/**
 * Write a description of Part2 here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Part2 {
    
    public int howMany(String stringa, String stringb){
        int counter = 0;
        int startIndex = 0;
        while(true){
            startIndex = stringb.indexOf(stringa, startIndex);
            if(startIndex != -1){
                counter++;
                startIndex += stringa.length();
            }else{
                break;
            }
        }
        return counter;
    }
    
    public void testHowMany(){
        String string1a = "ATGAACGAATTGAATC";
        String string1b = "GAA";
        String string2a = "ATAAAA";
        String string2b = "AA"; 
        String string3a = "ATACGTGCCAA";
        String string3b = "ACTG";
        System.out.println("String 1 : " + string1a);
        System.out.println("Occurrence of : \"" + string1b + "\" : " 
                            + howMany(string1b, string1a));
        System.out.println("--------------------------------");
        System.out.println("String 2 : " + string2a);
        System.out.println("Occurrence of : \"" + string2b + "\" : " 
                            + howMany(string2b, string2a));
        System.out.println("--------------------------------");
        System.out.println("String 3 : " + string3a);
        System.out.println("Occurrence of : \"" + string3b + "\" : " 
                            + howMany(string3b, string3a));
    }
}
