
/**
 * Write a description of Part1 here.
 * 
 * @author RIDI LUAMBA 
 * @version 09/10/2018
 */
public class Part1 {
    
    public String findSimpleGene(String dna){
        int startIndex = 0, stopIndex = 0;
        String gene = "";
        startIndex = dna.indexOf("ATG");
        if(startIndex == -1){
            return gene;
        }else{
            stopIndex = dna.indexOf("TAA", startIndex+3);
            if(stopIndex == -1){
                return gene;
            }else{
                gene = dna.substring(startIndex, stopIndex+3);
                if(gene.length() % 3 == 0){
                    return gene;
                }else{
                    return "";
                }
            }
        }
    }
    
    public void testSimpleGene(){
        //creation of dna
        String dna1 = "TCGAAACCGGAGGTTAAGGCT";
        String dna2 = "ATGAACCGGAGGTTCCGCTCAGAGTTACT";
        String dna3 = "TACGAAACCGGAGGTTTCAGGCT";
        String dna4 = "TATGAAACCGGAGGTTTAAGGCT";
        String dna5 = "TCGAAACCTATGGAGGTCAAGGCTCGTAA";
        String testDna = "AAATGCCCTAACTAGATTAAGAAACC";
        //Print each dna and check gene
        System.out.println("DNA 1 : " + dna1);
        System.out.println("Gene 1 : " + findSimpleGene(dna1));
        System.out.println();
        System.out.println("DNA 2 : " + dna2);
        System.out.println("Gene 2 : " + findSimpleGene(dna2));
        System.out.println();
        System.out.println("DNA 3 : " + dna3);
        System.out.println("Gene 3 : " + findSimpleGene(dna3));
        System.out.println();
        System.out.println("DNA 4 : " + dna4);
        System.out.println("Gene 4 : " + findSimpleGene(dna4));
        System.out.println();
        System.out.println("DNA 5 : " + dna5);
        System.out.println("Gene 5 : " + findSimpleGene(dna5));
        System.out.println();
        System.out.println("TEST DNA : " + testDna);
        System.out.println("Test Gene : " + findSimpleGene(testDna));
    }
}
