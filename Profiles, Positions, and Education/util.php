<?php
    function checkCancelButton(){
        if ( isset($_POST['cancel'] ) ) {
            header("Location: index.php");
            return;
        }
    }

    function checkAndLoadProfile($pdo, $profile_id, $user_id){
        $stmt = $pdo->prepare("SELECT * FROM profile where profile_id = :pid AND user_id = :uid");
        $stmt->execute(array(
            ":pid" => $profile_id,
            ":uid" => $user_id
        ));
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if ( $row === false )
            return 'Could not load profile';
        return [
            "'profile_id'" => $row['profile_id'],
            "first_name" => htmlentities($row['first_name']),
            "last_name" => htmlentities($row['last_name']),
            "email" => htmlentities($row['email']),
            "headline" => htmlentities($row['headline']),
            "summary" => htmlentities($row['summary'])
        ];
    }

    function checkSession(){
        if ( (! isset($_SESSION['name'])) && ! (isset($_SESSION['user_id'])) )
            die("ACCESS DENIED");
    }

    function flashMessage(){
        if ( isset($_SESSION['error']) ) {
            echo "<p class='red'>".htmlentities($_SESSION['error'])."</p>\n";
            unset($_SESSION['error']);
        }
        if ( isset($_SESSION['success']) ) {
            echo "<p class='green'>".htmlentities($_SESSION['success'])."</p>\n";
            unset($_SESSION['success']);
        }
    }

    function validateProfile(){
        if(strlen($_POST['first_name']) < 1 || strlen($_POST['first_name']) < 1 || strlen($_POST['email']) < 1 || strlen($_POST['headline']) < 1 || strlen($_POST['summary']) < 1)
            return "All fields are required";
        if(strpos($_POST['email'], '@') === false)
            return "Email address must contain @";
        return true;
    }

    function validatePos() {
        for($i=1; $i<=9; $i++) {
            if ( ! isset($_POST['year'.$i]) ) continue;
            if ( ! isset($_POST['desc'.$i]) ) continue;
            $year = $_POST['year'.$i];
            $desc = $_POST['desc'.$i];
            if ( strlen($year) == 0 || strlen($desc) == 0 )
                return "All fields are required";
            if ( ! is_numeric($year) )
                return "Position year must be numeric";
        }
        return true;
    }

    function validateEdu() {
        for($i=1; $i<=9; $i++) {
            if ( ! isset($_POST['edu_year'.$i]) ) continue;
            if ( ! isset($_POST['edu_school'.$i]) ) continue;
            $year = $_POST['edu_year'.$i];
            $school = $_POST['edu_school'.$i];
            if ( strlen($year) == 0 || strlen($school) == 0 )
                return "All fields are required";
            if ( ! is_numeric($year) )
                return "Year must be numeric";
        }
        return true;
    }

    function loadPosition($pdo, $profile_id){
        $stmt = $pdo->prepare("SELECT * FROM position where profile_id = :pid ORDER BY rank");
        $stmt->execute(array(":pid" => $profile_id));
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $rows;
    }

    function loadEdu($pdo, $profile_id){
        $stmt = $pdo->prepare("SELECT year, name FROM education JOIN institution 
                               ON education.institution_id = institution.institution_id  
                               where profile_id = :pid ORDER BY rank");
        $stmt->execute(array(":pid" => $profile_id));
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $rows;
    }

    function insertPosition($pdo, $profile_id){
        $rank = 1;
        for($i=1; $i<=9; $i++) {
            if ( ! isset($_POST['year'.$i]) ) continue;
            if ( ! isset($_POST['desc'.$i]) ) continue;
            $year = $_POST['year'.$i];
            $desc = $_POST['desc'.$i];
            $stmt = $pdo->prepare('INSERT INTO position (profile_id, rank, year, description) VALUES ( :pid, :rank, :year, :desc)');
            $stmt->execute(array(
                    ':pid' => $profile_id,
                    ':rank' => $rank,
                    ':year' => $year,
                    ':desc' => $desc)
            );
            $rank++;
        }
    }

    function insertEducations($pdo, $profile_id){
        $rank = 1;
        for($i=1; $i<=9; $i++) {
            if ( ! isset($_POST['edu_year'.$i]) ) continue;
            if ( ! isset($_POST['edu_school'.$i]) ) continue;
            $year = $_POST['edu_year'.$i];
            $school = $_POST['edu_school'.$i];
            // lookup the school if it is there
            $institution_id = false;
            $stmt = $stmt = $pdo->prepare("SELECT institution_id FROM institution WHERE name = :name");
            $stmt->execute(array(':name' => $school));
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if( $row !== false ) $institution_id = $row['institution_id'];
            //if there was no institution, insert it
            if( $institution_id === false ){
                $stmt = $pdo->prepare('INSERT INTO institution (name) VALUES (:name)');
                $stmt->execute(array(':name' => $school));
                $institution_id = $pdo->lastInsertId();
            }
            $stmt = $pdo->prepare('INSERT INTO education (profile_id, rank, year, institution_id) VALUES ( :pid, :rank, :year, :iid)');
            $stmt->execute(array(
                    ':pid' => $profile_id,
                    ':rank' => $rank,
                    ':year' => $year,
                    ':iid' => $institution_id)
            );
            $rank++;
        }
    }
