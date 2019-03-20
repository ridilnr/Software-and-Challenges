<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";
    require_once "check_session.php";
    require_once "check_cancel.php";

    if( isset($_POST['save']) && isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['email']) && isset($_POST['headline']) && isset($_POST['summary'])){
        if(strlen($_POST['first_name']) < 1 || strlen($_POST['first_name']) < 1 || strlen($_POST['email']) < 1 || strlen($_POST['headline']) < 1 || strlen($_POST['summary']) < 1){
            $_SESSION['error'] = "All fields are required";
            header("Location: edit.php?profile_id=".$_REQUEST['profile_id']);
            return;
        }elseif(strpos($_POST['email'], '@') === false){
            $_SESSION['error'] = "Email address must contain @";
            header("Location: edit.php?profile_id=".$_REQUEST['profile_id']);
            return;
        }else{
            if($_GET['profile_id'] === $_POST['profile_id']){
                $sql = "UPDATE profile SET first_name = :fn, last_name = :ln, email = :em, headline = :he, summary = :su
                        WHERE profile_id = :pid AND user_id = :uid";
                $stmt = $pdo->prepare($sql);
                $stmt->execute(array(
                    ':fn' => $_POST['first_name'],
                    ':ln' => $_POST['last_name'],
                    ':em' => $_POST['email'],
                    ':he' => $_POST['headline'],
                    ':su' => $_POST['summary'],
                    ':pid' => $_POST['profile_id'],
                    ':uid' => $_SESSION['user_id']
                ));
                $_SESSION['success'] = 'Profile updated';
                header( 'Location: index.php' ) ;
                return;
            }else{
                $_SESSION['error'] = 'Could not load profile';
                header( 'Location: index.php' ) ;
                return;
            }
        }
    }

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

    ?>
<!DOCTYPE html>
<html>
    <head>
        <title>Ridi Luamba's Profile Edit</title>
    </head>
    <body>
        <div class="container">
            <h1>Editing Profile for <?= $_SESSION['name'] ?> </h1>
            <?php require_once "error_msg.php"; ?>
            <form method="post">
                <p>First Name:
                    <input type="text" name="first_name" value="<?= $fname ?>" size="60"/>
                </p>
                <p>Last Name:
                    <input type="text" name="last_name" value="<?= $lname ?>" size="60"/>
                </p>
                <p>Email:
                    <input type="text" name="email" value="<?= $email ?>" size="30"/>
                </p>
                <p>Headline:<br/>
                    <input type="text" name="headline" value="<?= $head ?>" size="80"/>
                </p>
                <p>Summary:<br/>
                    <textarea name="summary" rows="8" cols="80"><?= $sum ?></textarea>
                </p>
                <p>
                    <input type="hidden" name="profile_id" value="<?= $pid ?>"/>
                    <input type="submit" name="save" value="Save">
                    <input type="submit" name="cancel" value="Cancel">
                </p>
            </form>
        </div>
    </body>
</html>
