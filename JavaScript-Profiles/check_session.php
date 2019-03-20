<?php
    //check if user name exists in the session
    if ( (! isset($_SESSION['name'])) && ! (isset($_SESSION['user_id'])) ) {
        die("Not logged in");
    }
