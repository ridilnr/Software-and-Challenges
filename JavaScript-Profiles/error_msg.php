<?php
    if ( isset($_SESSION['error']) ) {
        echo "<p class='red'>".htmlentities($_SESSION['error'])."</p>\n";
        unset($_SESSION['error']);
    }