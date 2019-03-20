
/**
 * Write a description of Part1 here.
 * 
 * @author RIDI LUAMBA
 * @version 09/10/2018
 */
public class Part2 {
    
    public String findSimpleGene(String dna, int startCodon, int stopCodon){
        startCodon = dna.indexOf("ATG");
        if(startCodon == -1){
            return "";
        }else{
            stopCodon = dna.indexOf("TAA", startCodon+3);
            if(stopCodon == -1){
                return "";
            }else{
                String gene = dna.substring(startCodon, stopCodon+3);
                if(gene.length() % 3 == 0){
                    return gene.toUpperCase();
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
        //Print each dna and check gene
        System.out.println("DNA 1 : " + dna1);
        System.out.println("Gene 1 : " + findSimpleGene(dna1, 0, dna1.length()));
        System.out.println();
        System.out.println("DNA 2 : " + dna2);
        System.out.println("Gene 2 : " + findSimpleGene(dna2, 0, dna2.length()));
        System.out.println();
        System.out.println("DNA 3 : " + dna3);
        System.out.println("Gene 3 : " + findSimpleGene(dna3, 0, dna3.length()));
        System.out.println();
        System.out.println("DNA 4 : " + dna4);
        System.out.println("Gene 4 : " + findSimpleGene(dna4, 0, dna4.length()));
        System.out.println();
        System.out.println("DNA 5 : " + dna5);
        System.out.println("Gene 5 : " + findSimpleGene(dna5, 0, dna5.length()));
    }
}
