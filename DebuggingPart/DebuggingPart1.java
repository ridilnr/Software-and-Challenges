
/**
 * Write a description of DebuggingPart1 here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class DebuggingPart1 {
    public void findAbc(String input) {
    int index = input.indexOf("abc");
    while (true) {
        if (index == -1) {
            break;
        }
        if(index >= input.length() - 4){
            break;
        }
        //System.out.println("index 1 : " +(index+1)+ "/ index 2 : " + (index+4));
        //System.out.println("index : " + index);
        String found = input.substring(index+1, index+4);
        System.out.println(found);
        //index = input.indexOf("abc", index+4);
        index = input.indexOf("abc",index+3);
        //System.out.println("index after updating : " + index);
    }
}
   public void test() {
       //findAbc("abcd");
       //findAbc("abcdabc");
       //findAbc("abcbbbabcdddabc");
       //findAbc("aaaaabc");
       //findAbc("woiehabchi");
       //findAbc("yabcyabc");
       //findAbc("eusabce");
       //findAbc("abcdkfjsksioehgjfhsdjfhksdfhuwabcabcajfieowj");
       /*findAbc("kdabcabcjei");
       System.out.println("----------------");
       findAbc("ttabcesoeiabco");
       System.out.println("----------------");
       findAbc("abcbabccabcd");
       System.out.println("----------------");
       findAbc("qwertyabcuioabcp");
       System.out.println("----------------");*/
       findAbc("abcabcabcabca");
   }
}
