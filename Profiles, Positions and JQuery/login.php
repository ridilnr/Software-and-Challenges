<?php // Do not put any HTML above this line
    session_start();
    require_once "pdo.php";
    require_once "util.php";
    checkCancelButton();
    $salt = 'XyZzy12*_';

    // Check to see if we have some POST data, if we do process it
    if ( isset($_POST['email']) && isset($_POST['pass']) ) {
        if ( strlen($_POST['email']) < 1 || strlen($_POST['pass']) < 1 ) {
            $_SESSION['error'] = "User name and password are required";
            header("Location: login.php");
            return;
        } else {
            if(strpos($_POST['email'], '@') === false){
                $_SESSION['error'] = "Email must have an at-sign (@)";
                header("Location: login.php");
                return;
            }else{
                $check = hash('md5', $salt.$_POST['pass']);
                $stmt = $pdo->prepare('SELECT user_id, name FROM users WHERE email = :em AND password = :pw');
                $stmt->execute(array( ':em' => $_POST['email'], ':pw' => $check));
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                if ( $row !== false ) {
                    $_SESSION['name'] = $row['name'];
                    $_SESSION['user_id'] = $row['user_id'];
                    // Redirect the browser to index.php
                    error_log("Login success ".$_POST['email']);
                    header("Location: index.php");
                    return;
                } else {
                    error_log("Login fail ".$_POST['email']." $check");
                    $_SESSION['error'] = "Incorrect password";
                    header("Location: login.php");
                    return;
                }
            }
        }
    }

    // Fall through into the View
?>
<!DOCTYPE html>
<html>
    <head>
        <?php require_once "bootstrap.php"; ?>
        <title>Ridi Luamba's Login Page</title>
    </head>
    <body>
        <div class="container">
            <h1>Please Log In</h1>
            <?php flashMessage(); ?>
            <form method="POST">
                <label for="nam">User Name</label>
                <input type="text" name="email" id="email"><br/>
                <label for="id_1723">Password</label>
                <input type="password" name="pass" id="id_1723"><br/>
                <input type="submit" onclick="return doValidate();" value="Log In">
                <input type="submit" name="cancel" value="Cancel">
            </form>
            <p>
                For a password hint, view source and find a password hint
                in the HTML comments.
                <!-- Hint: The password is the three character name of the
                programming language used in this class (all lower case)
                followed by 123. -->
            </p>
        </div>
    </body>
    <script>
        function doValidate() {
            console.log('Validating...');
            try {
                em = document.getElementById('email').value;
                pw = document.getElementById('id_1723').value;
                console.log("Validating email="+em+" pw="+pw);
                if (em == null || em === "" || pw == null || pw === "") {
                    alert("Both fields must be filled out");
                    return false;
                }
                if ( em.indexOf('@') === -1 ) {
                    alert("Invalid email address");
                    return false;
                }
                return true;
            } catch(e) {
                return false;
            }
        }
    </script>
</html>
