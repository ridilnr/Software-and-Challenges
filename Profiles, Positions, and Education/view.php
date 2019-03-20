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
                if ( count($positions) ) {
                    echo "<p>Position</p><ul>";
                    foreach ($positions as $position){
                        echo "<li>".$position['year']." : ".$position['description']."</li>";
                    }
                    echo "</ul>";
                }
                if ( count($educations) ) {
                    echo "<p>Education</p><ul>";
                    foreach ($educations as $education){
                        echo "<li>".$education['year']." : ".$education['name']."</li>";
                    }
                    echo "</ul>";
                }
            ?>
            <a href="index.php">Done</a>
        </div>
    </body>
</html>