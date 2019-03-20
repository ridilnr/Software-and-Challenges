<?php
    session_start();
    require_once "pdo.php";
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

                if ( isset($_SESSION['success']) ) {
                    echo "<p class='green'>".htmlentities($_SESSION['success'])."</p>\n";
                    unset($_SESSION['success']);
                }
            ?>
            <h2>Automobiles</h2>
            <ul>
                <?php
                $stmt1 = $pdo->query("SELECT make, year, mileage FROM autos");
                $rows = $stmt1->fetchAll(PDO::FETCH_ASSOC);
                foreach ( $rows as $row ) {
                    echo "<li>";
                    echo(" ".$row['year']." ".$row['make']." / ".$row['mileage']);
                    echo("</li>");
                }
                ?>
            </ul>
            <p>
                <a href="add.php">Add New</a> |
                <a href="logout.php">Logout</a>
            </p>
        </div>
    </body>
</html>