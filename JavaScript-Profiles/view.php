<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";
    require_once "check_data.php";

?>
<!DOCTYPE html>
<html>
    <head>
        <title>Ridi Luamba's Profile view</title>
    </head>
    <body>
        <div class="container">
            <h1>Profile information</h1>
            <p>First Name: <?= $fname ?> </p>
            <p>Last Name: <?= $lname ?> </p>
            <p>Email: <?= $email ?> </p>
            <p>Headline:<br/>
                <?= $head ?>
            </p>
            <p>Summary:<br/>
                <?= $sum ?>
            </p>
            <a href="index.php">Done</a>
        </div>
    </body>
</html>