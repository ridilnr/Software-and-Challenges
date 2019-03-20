<?php
    if ( isset($_POST['cancel'] ) ) {
        // Redirect the browser to game.php
        header("Location: index.php");
        return;
    }

