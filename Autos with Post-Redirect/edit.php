<?php
    session_start();
    require_once "pdo.php";
    require_once "bootstrap.php";

    //check if user name exists in the session
    if ( ! isset($_SESSION['name']) ) {
        die("ACCESS DENIED");
    }

    if( isset($_POST['cancel']) ){
        header("Location: index.php");
        return;
    }

    if ( isset($_POST['save']) && isset($_POST['make']) && isset($_POST['model']) && isset($_POST['year']) && isset($_POST['mileage']) && isset($_POST['autos_id']) ) {
        // Data validation
        if(strlen($_POST['make']) < 1 || strlen($_POST['model']) < 1 || strlen($_POST['year']) < 1 || strlen($_POST['mileage']) < 1){
            $_SESSION['error'] = "All fields are required";
            header("Location: edit.php?autos_id=".$_REQUEST['autos_id']);
            return;
        }elseif (!is_numeric($_POST['year'])){
            $_SESSION['error'] = "Year must be numeric";
            header("Location: edit.php?autos_id=".$_REQUEST['autos_id']);
            return;
        }elseif (!is_numeric($_POST['mileage'])){
            $_SESSION['error'] = "Mileage must be numeric";
            header("Location: edit.php?autos_id=".$_REQUEST['autos_id']);
            return;
        } else{
            $sql = "UPDATE autos SET make = :make, model = :model, year = :year, mileage = :mileage
                    WHERE autos_id = :autos_id";
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array(
                ':make' => $_POST['make'],
                ':model' => $_POST['model'],
                ':year' => $_POST['year'],
                ':mileage' => $_POST['mileage'],
                ':autos_id' => $_POST['autos_id']));
            $_SESSION['success'] = 'Record edited';
            header( 'Location: index.php' ) ;
            return;
        }
    }

    // Guardian: Make sure that autos_id is present
    if ( ! isset($_GET['autos_id']) ) {
        $_SESSION['error'] = "Missing autos_id";
        header('Location: index.php');
        return;
    }

    $stmt = $pdo->prepare("SELECT * FROM autos where autos_id = :xyz");
    $stmt->execute(array(":xyz" => $_GET['autos_id']));
    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if ( $row === false ) {
        $_SESSION['error'] = 'Bad value for autos_id';
        header( 'Location: index.php' ) ;
        return;
    }

    //sanitize data
    $mk = htmlentities($row['make']);
    $md = htmlentities($row['model']);
    $y = htmlentities($row['year']);
    $m = htmlentities($row['mileage']);
    $autos_id = $row['autos_id'];
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Ridi Luamba's Automobile Tracker</title>
    </head>
    <body>
        <div class="container">
            <h1>Editing Automobile</h1>
            <?php
                // Flash pattern
                if ( isset($_SESSION['error']) ) {
                    echo '<p class="red">'.$_SESSION['error']."</p>\n";
                    unset($_SESSION['error']);
                }
            ?>
            <form method="post">
                <p>Make:
                    <input type="text" name="make" value="<?= $mk ?>">
                </p>
                <p>Model:
                    <input type="text" name="model" value="<?= $md ?>">
                </p>
                <p>Year:
                    <input type="text" name="year" value="<?= $y ?>">
                </p>
                <p>Mileage:
                    <input type="text" name="mileage" value="<?= $m ?>">
                </p>
                <input type="hidden" name="autos_id" value="<?= $autos_id ?>">
                <p>
                    <input type="submit" name="save" value="Save"/>
                    <input type="submit" name="cancel" value="Cancel"/>
                </p>
            </form>
        </div>
    </body>
</html>
