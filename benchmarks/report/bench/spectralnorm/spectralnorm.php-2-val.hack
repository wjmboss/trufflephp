function A($i, $j){
    return 1.0 / ( ( ( ($i+$j) * ($i+$j+1) ) >> 1 ) + $i + 1 );
}

function Av($n, $v, $Av){
    // $Av = $_tpl; // assign by value
    for ($i = 0; $i < $n; ++$i) {
        $sum = 0.0;
        for($j = 0; $j < $n; $j++) {
            $v_j = $v[$j];
            $sum += A($i,$j) * $v_j;
        }
        $Av[$i] = $sum;
    }
    return $Av;
}

function Atv($n, $v, $Atv){
//     $Atv = $_tpl;
    for($i = 0; $i < $n; ++$i) {
        $sum = 0.0;
        for($j = 0; $j < $n; $j++) {
            $v_j = $v[$j];
            $sum += A($j,$i) * $v_j;
        }
        $Atv[$i] = $sum;
    }
    return $Atv;
}

function AtAv($n, $v, $_tpl){
    $tmp = Av($n,$v, $_tpl);
    return Atv($n, $tmp, $_tpl);
}

function doIteration($n) {
// $n = intval(($argc == 2) ? $argv[1] : 1);

$u = array_fill(0, $n, 1.0);
$_tpl = array_fill(0, $n, 0.0);

for ($i=0; $i<10; $i++){
    $v = AtAv($n,$u, $_tpl);
    $u = AtAv($n,$v, $_tpl);
}

$vBv = 0.0;
$vv = 0.0;

for($i = 0; $i < $n; $i ++) {
    $val = $v[$i];
    $vBv += $u[$i]*$val;
    $vv += $val*$val;
}
return sqrt($vBv/$vv);
}



<<__EntryPoint>>
function main(): void {

$N = 5500;
$iter = 30;

for($i = 0; $i < $iter; $i ++) {
    $start=clock_gettime_ns(1);
    $A = doIteration($N);
    $stop=clock_gettime_ns(1);
    

    $res = ($stop - $start) / 1000.0 / 1000.0;
    output($N, $iter, $i, $res);
    echo $A . "\n";
}
}


function output($N, $iters, $iter, $val) {
    echo "spectralnorm-val-hack;" . $N . ";" . $iters . ";" . $iter . ";" . $val . ";" . "\n";
}
