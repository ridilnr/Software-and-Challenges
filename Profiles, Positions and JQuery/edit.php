<?php
    session_start();
    require_once "pdo.php";
    require_once "util.php";
    require_once "check_data.php";
    checkSession();
    checkCancelButton();
    if( isset($_POST['save']) && isset($_POST['first_name']) && isset($_POST['last_name']) && isset($_POST['email']) && isset($_POST['headline']) && isset($_POST['summary'])){
        $msg = validateProfile();
        if( is_string($msg) ){
            $_SESSION['error'] = $msg;
            header("Location: edit.php?profile_id=".$_REQUEST['profile_id']);
            return;
        }
        $msg = validatePos();
        if( is_string($msg) ){
            $_SESSION['error'] = $msg;
            header("Location: edit.php?profile_id=".$_REQUEST['profile_id']);
            return;
        }
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
            //clear out the old position entries
            $stmt = $pdo->prepare('DELETE FROM position WHERE profile_id=:pid');
            $stmt->execute(array( ':pid' => $_REQUEST['profile_id']));
            //Insert the position entries
            insertPosition($pdo, $_REQUEST['profile_id']);
            //clear out the old education entries
            $stmt = $pdo->prepare('DELETE FROM education WHERE profile_id=:pid');
            $stmt->execute(array( ':pid' => $_REQUEST['profile_id']));
            //Insert the position entries

            $_SESSION['success'] = 'Profile updated';
            header( 'Location: index.php' ) ;
            return;
        }else{
            $_SESSION['error'] = 'Could not load profile';
            header( 'Location: index.php' ) ;
            return;
        }
    }
    // Guardian: Make sure that autos_id is present
     if ( ! isset($_GET['profile_id']) ) {
         $_SESSION['error'] = "Missing profile_id";
         header('Location: index.php');
         return;
     }
    $profile = checkAndLoadProfile($pdo, $_GET['profile_id'], $_SESSION['user_id']);
    if( is_string($profile) ){
        $_SESSION['error'] = $profile;
        header( 'Location: index.php' ) ;
        return;
    }
    $positions = loadPosition($pdo, $_GET['profile_id']);
    $schools = loadEdu($pdo, $_GET['profile_id']);
?>
<!DOCTYPE html>
<html>
    <head>
        <?php require_once "bootstrap.php"; ?>
        <title>Ridi Luamba's Profile Edit</title>
    </head>
    <body>
        <div class="container">
            <h1>Editing Profile for <?= $_SESSION['name'] ?> </h1>
            <?php flashMessage(); ?>
            <form method="post">
                <p>First Name:<input type="text" name="first_name" value="<?= $profile['first_name'] ?>" size="60"/></p>
                <p>Last Name:<input type="text" name="last_name" value="<?= $profile['last_name'] ?>" size="60"/></p>
                <p>Email:<input type="text" name="email" value="<?= $profile['email'] ?>" size="30"/></p>
                <p>Headline:<br/><input type="text" name="headline" value="<?= $profile['headline'] ?>" size="80"/></p>
                <p>Summary:<br/><textarea name="summary" rows="8" cols="80"><?= $profile['summary'] ?></textarea></p>
                <?php
                    $countEdu = 0;
                    echo '<p>Education: <input type="submit" id="addEdu" value="+">';
                    echo '<div id="edu_fields">';
                    if ( count($schools) ) {
                        foreach ($schools as $school){
                            $countEdu++;
                            echo "<div id='edu".$countEdu."'>".
                                    "<p>Year: ".
                                    "<input type='text' name='edu_year".$countEdu."' value='".$school['year']."' />".
                                    "<input type='button' value='-' onclick=\"$('#edu".$countEdu."').remove();return false;\" />".
                                    "</p>".
                                    "<p>School: <input type='text' size='80' name='edu_school".$countEdu."' class='school' value='".htmlentities($school['name'])."' />".$school['description']."</p>".
                                 "</div>";
                        }
                    }
                    echo '</div></p>';
                    //
                    $countPos = 0;
                    echo '<p>Position: <input type="submit" id="addPos" value="+">';
                    echo '<div id="position_fields">';
                    if ( count($positions) ) {
                        foreach ($positions as $position){
                            $countPos++;
                            echo "<div id='position".$countPos."'>".
                                    "<p>Year: ".
                                        "<input type='text' name='year".$countPos."' value='".$position['year']."' />".
                                        "<input type='button' value='-' onclick=\"$('#position".$countPos."').remove();return false;\" />".
                                    "</p>".
                                    "<textarea name='desc".$countPos."' rows='8' cols='80'>".htmlentities($position['description'])."</textarea>".
                                "</div>";
                        }
                    }
                    echo '</div></p>';
                ?>
                <p>
                    <input type="hidden" name="profile_id" value="<?= $_REQUEST['profile_id'] ?>"/>
                    <input type="submit" name="save" value="Save">
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
