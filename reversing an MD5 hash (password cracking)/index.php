<!DOCTYPE html>
    <head>
        <title>Ridi Luamba MD5 Cracker</title>
    </head>
    <body>
        <h1>MD5 cracker</h1>
        <p>This application takes an MD5 hash
        of a 4 digit pin and attempts to hash all 4 digits combinations
        to determine the original 4 digit pin</p>
        <pre>
Debug Output:
            <?php
            $goodtext = "Not found";
            $totChk = 0;
            print "\n";
            // If there is no parameter, this code is all skipped
            if ( isset($_GET['md5']) ) {
                $time_pre = microtime(true);
                $md5 = $_GET['md5'];

                // This is our digit list
                $dgt = "0123456789";
                $show = 15;

                // Outer loop go go through the digit for the
                // first position in our "possible" pre-hash
                // text
                for($i=0; $i<strlen($dgt); $i++ ) {
                    $ch1 = $dgt[$i];   // The first of four digits

                    // Our first inner loop Note the use of new variables
                    // $j and $ch2
                    for($j=0; $j<strlen($dgt); $j++ ) {
                        $ch2 = $dgt[$j];  // Our second digit

                        // Our second inner loop Note the use of new variables
                        // $k and $ch3
                        for($k=0; $k<strlen($dgt); $k++){
                            $ch3 = $dgt[$k];  // Our third digit

                            // Our third inner loop Note the use of new variables
                            // $l and $ch4
                            for($l=0; $l<strlen($dgt); $l++){
                                $ch4 = $dgt[$l];  // Our fourth digit

                                // Concatenate the two characters together to
                                // form the "possible" pre-hash text
                                $try = $ch1.$ch2.$ch3.$ch4;

                                // Run the hash and then check to see if we match
                                $check = hash('md5', $try);

                                $totChk++;
                                if ( $check == $md5 ) {
                                    $goodtext = $try;
                                    break;   // Exit the inner loop
                                }

                                // Debug output until $show hits 0
                                if ( $show > 0 ) {
                                    print "$check $try\n";
                                    $show = $show - 1;
                                }
                            }
                        }
                    }
                }
                // Compute elapsed time
                $time_post = microtime(true);
                print "\nTotal checks: ".$totChk."\n";
                print "\nElapsed time: ".($time_post-$time_pre);
                /*print $time_post-$time_pre;*/
                print "\n";
            }
            ?>
        </pre>
        <!-- Use the very short syntax and call htmlentities() -->
        <p>Original Text: <?= htmlentities($goodtext); ?></p>
        <form>
            <input type="text" name="md5" size="40" />
            <input type="submit" value="Crack MD5"/>
        </form>
        <ul>
            <li>
                <a href="index.php">Reset</a>
            </li>
            <li>
                <a href="md5.php">MD5 Encoder</a>
            </li>
            <li>
                <a href="makecode.php">MD5 Code Maker</a>
            </li>
        </ul>
    </body>
</html>

