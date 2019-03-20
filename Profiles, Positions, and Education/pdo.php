<?php
$pdo = new PDO('mysql:host=localhost;port=3306;dbname=misc', 'ridi', '0000');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);