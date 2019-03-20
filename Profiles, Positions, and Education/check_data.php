<?php
    require_once "util.php";
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
    $educations = loadEdu($pdo, $_GET['profile_id']);