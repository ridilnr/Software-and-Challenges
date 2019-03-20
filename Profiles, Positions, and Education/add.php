<?php
    session_start();
    require_once "pdo.php";
    require_once "util.php";
    checkSession();
    checkCancelButton();
?>
<!DOCTYPE html>
<html>
    <head>
        <?php require_once "bootstrap.php"; ?>
        <title>Ridi Luamba's Profile Add</title>
    </head>
    <body>
    <div class="container">
        <?php
            echo "<h1>Adding Profile for ".htmlentities($_SESSION['name'])."</h1>\n";
            if( isset($_POST['add']) && isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['email']) && isset($_POST['headline']) && isset($_POST['summary'])){
                $msg = validateProfile();
                if( is_string($msg) ){
                    $_SESSION['error'] = $msg;
                    header("Location: add.php");
                    return;
                }
                $msg = validatePos();
                if( is_string($msg) ){
                    $_SESSION['error'] = $msg;
                    header("Location: add.php");
                    return;
                }
                $msg = validateEdu();
                if( is_string($msg) ){
                    $_SESSION['error'] = $msg;
                    header("Location: add.php");
                    return;
                }
                $stmt = $pdo->prepare('INSERT INTO Profile (user_id, first_name, last_name, email, headline, summary) 
                                                 VALUES ( :uid, :fn, :ln, :em, :he, :su)');
                $stmt->execute(array(
                        ':uid' => $_SESSION['user_id'],
                        ':fn' => $_POST['first_name'],
                        ':ln' => $_POST['last_name'],
                        ':em' => $_POST['email'],
                        ':he' => $_POST['headline'],
                        ':su' => $_POST['summary'])
                );
                $profile_id = $pdo->lastInsertId();
                insertPosition($pdo, $profile_id);
                //Insert the education entries
                insertEducations($pdo, $profile_id);
                $_SESSION['success'] = "Profile added";
                header("Location: index.php");
                return;
            }
            flashMessage();
        ?>
        <form method="post">
            <p>First Name: <input type="text" name="first_name" size="60"/></p>
            <p>Last Name: <input type="text" name="last_name" size="60"/></p>
            <p>Email: <input type="text" name="email" size="30"/></p>
            <p>Headline:<br/><input type="text" name="headline" size="80"/></p>
            <p>Summary:<br/><textarea name="summary" rows="8" cols="80"></textarea></p>
            <p>Education: <input type="submit" id="addEdu" value="+">
                <div id="edu_fields"></div>
            </p>
            <p>Position: <input type="submit" id="addPos" value="+">
                <div id="position_fields"></div>
            </p>
            <p>
                <input type="submit" name="add" value="Add">
                <input type="submit" name="cancel" value="Cancel">
            </p>
        </form>
        <script src="script.js"></script>
        <!-- HTML with Substitution hot spots -->
        <script id="edu-template" type="text/html">
            <div id="edu@COUNT@">
                <p>Year:
                    <input type="text" name="edu_year@COUNT@" value="" />
                    <input type="button" value="-" onclick='$("#edu@COUNT@").remove();return false;'><br>
                </p>
                <p>School: <input type="text" size="80" name="edu_school@COUNT@" class="school" value="" /></p>
            </div>
        </script>
    </div>
    </body>
</html>
