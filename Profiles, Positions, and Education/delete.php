<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";
    require_once "util.php";
    checkSession();

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
        <?php require_once "bootstrap.php"; ?>
        <title>Ridi Luamba's Profile Delete</title>
    </head>
    <body>
        <div class="container">
            <h1>Deleting Profile</h1>
            <form method="post" action="delete.php">
                <p>First Name: <?= $profile['first_name'] ?></p>
                <p>Last Name: <?= $profile['last_name'] ?></p>
                <p>
                    <input type="hidden" name="profile_id" value="<?= $_REQUEST['profile_id'] ?>"/>
                    <input type="submit" name="delete" value="Delete">
                    <input type="submit" name="cancel" value="Cancel">
                </p>
            </form>
        </div>
    </body>
</html>
