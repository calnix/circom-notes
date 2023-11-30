pragma circom 2.1.6;

include "node_modules/circomlib/circuits/comparators.circom";

function invert(x) {
    return 1 / x;
}

template Average(n) {

    signal input in[n];
    signal denominator;
    signal output out;

    var sum;
    for (var i = 0; i < n; i++) {
        sum += in[i];
    }   

    // compute and assign via function
    denominator <-- invert(n);

    component eq = IsEqual();
    eq.in[0] <== denominator;
    eq.in[1] <== n;

    out <== sum * denominator;
}

<<<<<<< HEAD
component main = Average(5);
=======
component main  = Average(5);
>>>>>>> f7f706ed0e239f6bd23114a44e871886b810ba00
