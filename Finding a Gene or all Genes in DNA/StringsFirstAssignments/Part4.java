import edu.duke.*;
/**
 * Write a description of Part4 here.
 * 
 * @author RIDI LUAMBA 
 * @version 09/10/2018
 */
public class Part4 {
    
    public void lookforlink(){
        URLResource url = new URLResource("http://www.dukelearntoprogram.com/course2/data/manylinks.html");
        int counter = 0;
        String wordToSearch = "youtube.com";
        for (String word : url.words()) {
            //System.out.println(word);
            int indexWordSearch = word.toLowerCase().indexOf(wordToSearch);
            if(indexWordSearch != -1){
                int leftQuoteIndex = word.indexOf("\"");
                int rightQuoteIndex = word.indexOf("\"", indexWordSearch + wordToSearch.length());
                //rightQuoteIndex = word.lastIndexOf("\"");
                //System.out.println(word);
                String link = word.substring(leftQuoteIndex+1, rightQuoteIndex);
                System.out.println(link);
                //another alternative
                /*int beg = word.lastIndexOf("\"",indexWordSearch);
                int end = word.indexOf("\"", indexWordSearch+1);
                System.out.println(word.substring(beg+1,end));*/
                counter++;
            }
        }
        System.out.println();
        System.out.println("number of links : " + counter);
    }
}
