<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";
?>
<!DOCTYPE html>
<html>
    <head>
    <title>Ridi Luamba</title>
    </head>
    <body>
        <div class="container">
            <h1>Welcome to the Automobile Database</h1>
            <?php
                if ( isset($_SESSION['success']) ) {
                    echo "<p class='green'>".htmlentities($_SESSION['success'])."</p>\n";
                    unset($_SESSION['success']);
                }

                if ( isset($_SESSION['error']) ) {
                    echo "<p class='red'>".htmlentities($_SESSION['error'])."</p>\n";
                    unset($_SESSION['error']);
                }

                if ( isset($_SESSION['name']) ) {
                    $stmt = $pdo->query("SELECT make, model, year, mileage, autos_id FROM autos");
                    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
                    if($rows !== false){
                        echo '<table border="1">'."\n".
                                "<tr>".
                                    "<th>Make</th>".
                                    "<th>Model</th>".
                                    "<th>Year</th>".
                                    "<th>Mileage</th>".
                                    "<th>Action</th>".
                                "</tr>";
                        foreach ( $rows as $row ){
                            echo "<tr>".
                                    "<td>".htmlentities($row['make'])."</td>".
                                    "<td>".htmlentities($row['model'])."</td>".
                                    "<td>".htmlentities($row['year'])."</td>".
                                    "<td>".htmlentities($row['mileage'])."</td>".
                                    "<td>".'<a href="edit.php?autos_id='.$row['autos_id'].'">Edit</a> / '.
                                           '<a href="delete.php?autos_id='.$row['autos_id'].'">Delete</a>'.
                                    "</td>".
                                "</tr>\n";
                        }
                        echo "</table><br>";
                    }
                    else{
                        echo "<p>No rows found</p>";
                    }
                    echo "\n<p><a href='add.php'>Add New Entry</a></p>";
                    echo "<p><a href='logout.php'>Logout</a></p>";
                }else {
                    echo '<p><a href="login.php">Please Log In</a></p>';
                    echo '<p>Attempt to go to<a href="add.php"> add data</a> without logging in - it should fail with an error message.</p>';
                }
            ?>
            <p>

            </p>
        </div>
    </body>
</html>
