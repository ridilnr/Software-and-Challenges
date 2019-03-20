<?php
    if ( isset($_SESSION['success']) ) {
        echo "<p class='green'>".htmlentities($_SESSION['success'])."</p>\n";
        unset($_SESSION['success']);
    }