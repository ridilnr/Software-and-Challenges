<?php
    session_start();

    require_once "pdo.php";
    //check if user name exists in the session
    if ( ! isset($_SESSION['name']) ) {
        die('Not logged in');
    }
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Ridi Luamba's Automobile Tracker</title>
        <?php require_once "bootstrap.php"; ?>
    </head>
    <body>
    <div class="container">
        <?php
            if ( isset($_SESSION['name']) ) {
                echo "<h1>Tracking Autos for ";
                echo htmlentities($_SESSION['name']);
                echo "</h1>\n";
            }

            if( isset($_POST['make']) && isset($_POST['year']) && isset($_POST['mileage'])){
                if(strlen($_POST['make']) < 1){
                    $_SESSION['error'] = "Make is required";
                    header("Location: add.php");
                    return;
                }else{
                    if((!is_numeric($_POST['year'])) || (!is_numeric($_POST['mileage']))){
                        $_SESSION['error'] = "Mileage and year must be numeric";
                        header("Location: add.php");
                        return;
                    }else{
                        $stmt2 = $pdo->prepare('INSERT INTO autos (make, year, mileage) VALUES ( :mk, :yr, :mi)');
                        $stmt2->execute(array(
                                ':mk' => htmlentities($_POST['make']),
                                ':yr' => htmlentities($_POST['year']),
                                ':mi' => htmlentities($_POST['mileage'])
                            )
                        );
                        $_SESSION['success'] = "Record inserted";
                        header("Location: view.php");
                        return;
                    }
                }
            }

            if ( isset($_SESSION['error']) ) {
                // Look closely at the use of single and double quotes
                echo('<p class="red">'.htmlentities($_SESSION['error'])."</p>\n");
                unset($_SESSION['error']);
            }
        ?>
        <form method="post">
            <p>Make:
                <input type="text" name="make" size="60"/></p>
            <p>Year:
                <input type="text" name="year"/></p>
            <p>Mileage:
                <input type="text" name="mileage"/></p>
            <input type="submit" value="Add">
            <input type="submit" name="logout" value="Logout">
        </form>
    </div>
    </body>
</html>
