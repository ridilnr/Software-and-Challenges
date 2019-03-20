<?php
function double($val){
    $val = $val * 2;
    return $val;
}

$val = 15;
$dval = double($val);
echo "Value = $val Doubled = $dval";