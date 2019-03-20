<?php
    session_start();
    require_once "pdo.php";
    require_once "check_data.php";
?>
<!DOCTYPE html>
<html>
    <head>
        <?php require_once "bootstrap.php"; ?>
        <title>Ridi Luamba's Profile view</title>
    </head>
    <body>
        <div class="container">
            <h1>Profile information</h1>
            <p>First Name: <?= $profile['first_name'] ?> </p>
            <p>Last Name: <?= $profile['last_name'] ?> </p>
            <p>Email: <?= $profile['email'] ?> </p>
            <p>Headline:<br/><?= $profile['headline'] ?></p>
            <p>Summary:<br/><?= $profile['summary'] ?></p>
            <?php
                if ( count($rows) ) {
                    echo "<p>Position</p><ul>";
                    foreach ($rows as $row){
                        echo "<li>".$row['year']." : ".$row['description']."</li>";
                    }
                    echo "</ul>";
                }
            ?>
            <a href="index.php">Done</a>
        </div>
    </body>
</html>