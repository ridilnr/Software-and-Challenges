import edu.duke.*;
/**
 * Write a description of Part1 here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Part1 {
    
    public int findStopCodon(String dnaStr, int startIndex, String stopCodon){
        int currIndex = dnaStr.indexOf(stopCodon, startIndex+3);
        while(currIndex != -1){
            int diff = currIndex - startIndex;
            if(diff % 3 == 0){
                return currIndex;
            }else{
                currIndex = dnaStr.indexOf(stopCodon, currIndex+1);
            }
        }
        return -1;
    }
    
    public String findGene(String dna, int where) {
        int startIndex = dna.indexOf("ATG", where);
        if(startIndex == -1){
            return "";
        }
        int taaIndex = findStopCodon(dna,startIndex,"TAA");
        int tagIndex = findStopCodon(dna,startIndex,"TAG");
        int tgaIndex = findStopCodon(dna,startIndex,"TGA");
        //int minIndex = Math.min(taaIndex, Math.min(tagIndex,tgaIndex));
        int minIndex = 0;
        if(taaIndex == -1 || (tgaIndex != -1 && tgaIndex < taaIndex)){
            minIndex = tgaIndex;
        }else{
            minIndex = taaIndex;
        }
        
        if(minIndex == -1 || (tagIndex != -1 && tagIndex < minIndex)){
            minIndex = tagIndex;
        }
        
        if(minIndex == -1){
            return "";
        }
        
        return dna.substring(startIndex, minIndex + 3);
    }
    
    public StorageResource getAllGenes(String dna){
        StorageResource geneList = new StorageResource();
        int startIndex = 0;
        while( true ){
            String currentGene = findGene(dna, startIndex);
            if(currentGene.isEmpty()){
                break;
            }
            geneList.add(currentGene);
            startIndex = dna.indexOf(currentGene, startIndex) + currentGene.length();
        }
        return geneList;
    }
    
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
    
    public float cgRatio(String dna){
        return (float)(howMany("C", dna) + howMany("G", dna))/dna.length();
    }
    
    public int countCTG(String dna){
        return howMany("CTG", dna);
    }
    
    public void processGenes(StorageResource sr){
        int counter = 0;
        
        System.out.println("Strings longer than 9 characters : ");
        System.out.println("-----------------------------------");
        for(String s: sr.data()){
            if(s.length() > 9){
                System.out.println(s);
                counter++;
            }
        }
        System.out.println("-----------------------------------");
        System.out.println("number of strings longer than 9 characters : "
                            + counter);
        System.out.println("-----------------------------------");                    
        System.out.println("Strings whose C-G-ratio is higher than 0.35 : ");
        System.out.println("-----------------------------------");
        counter = 0;
        int longestGene = 0;
        for(String s: sr.data()){
            if(cgRatio(s) >  0.35){
                System.out.println(s);
                counter++;
            }
            if(s.length() > longestGene){
                longestGene = s.length();
            }
        }
        System.out.println("-----------------------------------");
        System.out.println("number of strings whose C-G-ratio is higher than 0.35 : "
                            + counter);
        System.out.println("-----------------------------------");
        System.out.println("Length of the longest gene in sr : "
                            + longestGene);
        System.out.println("-----------------------------------");
    }
    
    public void testFindStopCodon (){
        String dna1 = "CGTATGCCGGGATAGATCTGTAAGATTACCTAATGAATGTAG";
        String dna2 = "CGTATGCCGGGATCAGATCGCTGTACAGATTACCTACATTACG";
        System.out.println("DNA : " + dna1);
        System.out.println("---------------------------------------");
        System.out.println("index codon TAA : " + findStopCodon(dna1,0,"TAA"));
        System.out.println("index codon TGA : " + findStopCodon(dna1,0,"TGA"));
        System.out.println("index codon TAG : " + findStopCodon(dna1,0,"TAG"));
        System.out.println();
        System.out.println("DNA : " + dna2);
        System.out.println("---------------------------------------");
        System.out.println("index codon TAA : " + findStopCodon(dna2,0,"TAA"));
        System.out.println("index codon TGA : " + findStopCodon(dna2,0,"TGA"));
        System.out.println("index codon TAG : " + findStopCodon(dna2,0,"TAG"));
    }
    
    public void testFindGene(){
        String dna1 = "TGCCCGGGAAATAACCC";
        String dna2 = "AGTATGCCGGGATAG";
        String dna3 = "CGTATGCCGGGATAGATGCTGTGAGATGTACCGCCCGTAAGATGAATGTCGAG";
        String dna4 = "CGTATGCCGGGATCAGATCGCTGTACAGATTACCTACATTACG";
        String dna5 = "GTACGATCATGCATCGCTGTAGCAGATGATACCTACATTACG";
        StorageResource genes = getAllGenes(dna3);
        for(String g: genes.data()){
            System.out.println(g);
        }
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

    public void testCgRatio(){
        String dna1 = "ATGAACGAATTGAATC";
        String dna2 = "ATGCCATAG";
        System.out.println("DNA 1 : " + dna1);
        System.out.println("Ratio  of C's and G's : " + cgRatio(dna1));
        System.out.println("--------------------------------");
        System.out.println("DNA 2 : " + dna2);
        System.out.println("Ratio  of C's and G's : " + cgRatio(dna2));
    }
    
    public void testCountCTG (){
        String dna1 = "ATGAACTGAATTCTGAATCTG";
        String dna2 = "ATGCCTGATAG";
        FileResource fr = new FileResource("GRch38dnapart.fa");
        String dna3 = fr.asString().toUpperCase();
        System.out.println("DNA 1 : " + dna1);
        System.out.println("Occurences of CTG : " + countCTG(dna1));
        System.out.println("--------------------------------");
        System.out.println("DNA 2 : " + dna3);
        System.out.println("Occurences of CTG : " + countCTG(dna3));
    }
    
    public void testProcessGenes(){
        FileResource fr = new FileResource("GRch38dnapart.fa");
        String dna2 = fr.asString().toUpperCase();
        //String dna3 = "CGTATGCCGGGATAGATGCTGTGAGATGTACCGCCCGTAAGATGAATGTCGAG";
        StorageResource genes = getAllGenes(dna2);
        for(String g: genes.data()){
            System.out.println(g);
        }
        System.out.println(genes.size());
        System.out.println("-----------------------------------");
        processGenes(genes);
    }
    
}
