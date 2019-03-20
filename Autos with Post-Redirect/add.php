<?php
    session_start();

    require_once "pdo.php";
    //check if user name exists in the session
    if ( ! isset($_SESSION['name']) ) {
        die("ACCESS DENIED");
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
                echo "<h1>Tracking Automobiles for ";
                echo htmlentities($_SESSION['name']);
                echo "</h1>\n";
            }

            if( isset($_POST['make']) && isset($_POST['model']) && isset($_POST['year']) && isset($_POST['mileage'])){
                if(strlen($_POST['make']) < 1 || strlen($_POST['model']) < 1 || strlen($_POST['year']) < 1 || strlen($_POST['mileage']) < 1){
                    $_SESSION['error'] = "All fields are required";
                    header("Location: add.php");
                    return;
                }elseif (!is_numeric($_POST['year'])){
                    $_SESSION['error'] = "Year must be numeric";
                    header("Location: add.php");
                    return;
                }elseif (!is_numeric($_POST['mileage'])){
                    $_SESSION['error'] = "Mileage must be numeric";
                    header("Location: add.php");
                    return;
                } else{
                    $stmt2 = $pdo->prepare('INSERT INTO autos (make, model, year, mileage) VALUES ( :mk, :md, :yr, :mi)');
                    $stmt2->execute(array(
                            ':mk' => htmlentities($_POST['make']),
                            ':md' => htmlentities($_POST['model']),
                            ':yr' => htmlentities($_POST['year']),
                            ':mi' => htmlentities($_POST['mileage'])
                        )
                    );
                    $_SESSION['success'] = "Record added";
                    header("Location: index.php");
                    return;
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
                <input type="text" name="make" size="60"/>
            </p>
            <p>Model:
                <input type="text" name="model" size="60"/>
            </p>
            <p>Year:
                <input type="text" name="year"/>
            </p>
            <p>Mileage:
                <input type="text" name="mileage"/>
            </p>
            <input type="submit" value="Add">
            <input type="submit" name="logout" value="Logout">
        </form>
    </div>
    </body>
</html>
