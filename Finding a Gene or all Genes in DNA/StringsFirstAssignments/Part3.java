/**
 * Write a description of Part3 here.
 * 
 * @author RIDI LUAMBA
 * @version 09/10/2018
 */
public class Part3 {
    
    public boolean twoOccurrences(String stringa, String stringb){
        int counter = 0;
        int startIndex = 0;
        int stopIndex = 0;
        boolean bool = false;
        //String test = "huiby this my mom say by that and the other bye";
        while(true){
            startIndex = stringb.indexOf(stringa, startIndex);
            if(startIndex != -1){
                //System.out.println("index : " + test.indexOf("by", startIndex));                
                counter++;
                startIndex += 2;
                if(counter >= 2){
                    bool = true;
                }
                continue;
            }else{
                break;
            }
        }
        //System.out.println("counter : " + counter);
        return bool;
    }
    
    public String lastPart(String stringa, String stringb){
        int startIndex = 0;
        startIndex = stringb.indexOf(stringa);
        if(startIndex != -1){
            startIndex += stringa.length();
            return stringb.substring(startIndex, stringb.length());
        }else{
            return stringb;
        }
    }
    
    public void testing(){
        String string1a = "A story by Abby Long";
        String string1b = "by";
        String string2a = "banana";
        String string2b = "a";
        String string2c = "an";
        String string3a = "ctgtatgta";
        String string3b = "atg";
        String string4a = "forest";
        String string4b = "zoo";
        System.out.println("String 1 : " + string1a + "('" + string1b + "')");
        System.out.println("Result : " + twoOccurrences(string1b, string1a));
        System.out.println("String 2 : " + string2a + "('" + string2b + "')");
        System.out.println("Result : " + twoOccurrences(string2b, string2a));
        System.out.println("String 3 : " + string3a + "('" + string3b + "')");
        System.out.println("Result : " + twoOccurrences(string3b, string3a));
        System.out.println("***********************************");
        System.out.println("String 1 : " + string2a + "('" + string2c + "')");
        System.out.println("Last Part : " + lastPart(string2c, string2a));
        System.out.println("String 2 : " + string4a + "('" + string4b + "')");
        System.out.println("Last Part : " + lastPart(string4b, string4a));
    }
}
