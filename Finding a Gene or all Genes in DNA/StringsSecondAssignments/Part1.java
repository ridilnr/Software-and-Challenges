
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
    
    public void printAllGenes(String dna){
        int startIndex = 0;
        while( true ){
            String currentGene = findGene(dna, startIndex);
            if(currentGene.isEmpty()){
                break;
            }
            System.out.println(currentGene);
            startIndex = dna.indexOf(currentGene, startIndex) + currentGene.length();
        }
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
        System.out.println("DNA 1 : " + dna1);
        System.out.println("-------------------------------------------------");
        printAllGenes(dna1);
        System.out.println();
        System.out.println("DNA 2 : " + dna2);
        System.out.println("-------------------------------------------------");
        printAllGenes(dna2);
        System.out.println();
        System.out.println("DNA 3 : " + dna3);
        System.out.println("-------------------------------------------------");
        printAllGenes(dna3);
        System.out.println();
        System.out.println("DNA 4 : " + dna4);
        System.out.println("-------------------------------------------------");
        printAllGenes(dna4);
        System.out.println();
        System.out.println("DNA 5 : " + dna5);
        System.out.println("-------------------------------------------------");
        printAllGenes(dna5);
        System.out.println();
    }
}
