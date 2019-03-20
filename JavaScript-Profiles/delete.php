<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";
    require_once "check_session.php";
    if ( isset($_POST['cancel'] ) ) {
        // Redirect the browser to game.php
        header("Location: index.php");
        return;
    }


    if ( isset($_POST['delete']) && isset($_POST['profile_id']) ) {
        $sql = "DELETE FROM profile WHERE profile_id = :pid AND user_id = :uid";
        $stmt = $pdo->prepare($sql);
        $stmt->execute(array(
                ':pid' => $_POST['profile_id'],
                ':uid' => $_SESSION['user_id']
        ));
        $_SESSION['success'] = 'Profile deleted';
        header( 'Location: index.php' ) ;
        return;
    }
    require_once "check_data.php";
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Ridi Luamba's Profile Delete</title>
    </head>
    <body>
        <div class="container">
            <h1>Deleting Profile</h1>
            <form method="post" action="delete.php">
                <p>First Name: <?= $fname ?></p>
                <p>Last Name: <?= $lname ?></p>
                <p>
                    <input type="hidden" name="profile_id" value="<?= $pid ?>"/>
                    <input type="submit" name="delete" value="Delete">
                    <input type="submit" name="cancel" value="Cancel">
                </p>
            </form>
        </div>
    </body>
</html>
