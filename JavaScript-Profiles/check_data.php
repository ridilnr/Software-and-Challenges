<?php
    // Guardian: Make sure that autos_id is present
    if ( ! isset($_GET['profile_id']) ) {
        $_SESSION['error'] = "Missing profile_id";
        header('Location: index.php');
        return;
    }

    $stmt = $pdo->prepare("SELECT * FROM profile where profile_id = :pid AND user_id = :uid");
    $stmt->execute(array(
        ":pid" => $_GET['profile_id'],
        ":uid" => $_SESSION['user_id']
    ));
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if ( $row === false ) {
        $_SESSION['error'] = 'Could not load profile';
        header( 'Location: index.php' ) ;
        return;
    }

    //sanitize data
    $pid = $row['profile_id'];
    $fname = htmlentities($row['first_name']);
    $lname = htmlentities($row['last_name']);
    $email = htmlentities($row['email']);
    $head = htmlentities($row['headline']);
    $sum = htmlentities($row['summary']);
