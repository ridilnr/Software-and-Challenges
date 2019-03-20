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
            <h1>Ridi Luamba's Resume Registry</h1>
            <?php require_once "success_msg.php"; ?>
            <?php require_once "error_msg.php"; ?>
            <?php
                $stmt = $pdo->query("SELECT * FROM profile");
                $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

                if ( (! isset($_SESSION['name'])) && ! (isset($_SESSION['user_id'])) ) {
                        echo '<p><a href="login.php">Please log in</a></p>';
                    if( count($rows) ){
                        echo '<table border="1">'."\n".
                            "<tr>".
                            "<th>Name</th>".
                            "<th>Headline</th>".
                            "</tr>";
                        foreach ( $rows as $row ){
                            echo "<tr>".
                                "<td><a href='view.php?profile_id=".$row['profile_id']."'>".htmlentities($row['first_name'])." ".htmlentities($row['last_name'])."</a></td>".
                                "<td>".htmlentities($row['headline'])."</td>".
                                "</tr>\n";
                        }
                        echo "</table><br>";
                    }
                } else{
                    echo '<p><a href="logout.php">Logout</a></p>';
                    if(count($rows)){
                        echo '<table border="1">'."\n".
                            "<tr>".
                            "<th>Name</th>".
                            "<th>Headline</th>".
                            "<th>Action</th>".
                            "</tr>";
                        foreach ( $rows as $row ){
                            if($row['user_id'] === $_SESSION['user_id']){
                                echo "<tr>".
                                    "<td><a href='view.php?profile_id=".$row['profile_id']."'>".htmlentities($row['first_name'])." ".htmlentities($row['last_name'])."</a></td>".
                                    "<td>".htmlentities($row['headline'])."</td>".
                                    "<td>".
                                    '<a href="edit.php?profile_id='.$row['profile_id'].'">Edit</a> '.
                                    '<a href="delete.php?profile_id='.$row['profile_id'].'">Delete</a>'.
                                    "</td>".
                                    "</tr>\n";
                            }else{
                                echo "<tr>".
                                    "<td><a href='view.php?profile_id=".$row['profile_id']."'>".htmlentities($row['first_name'])." ".htmlentities($row['last_name'])."</a></td>".
                                    "<td>".htmlentities($row['headline'])."</td>".
                                    "<td></td>".
                                    "</tr>\n";
                            }
                        }
                        echo "</table><br>";
                    }
                    echo "\n<p><a href='add.php'>Add New Entry</a></p>";
                }
            ?>
            <p>

            </p>
        </div>
    </body>
</html>
