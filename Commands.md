# Generating an R1CS file

To convert the circuit to an R1CS, run the following command:

```bash
circom multiply.circom --r1cs --sym
```

Command creates 2 new files:
 multiply.r1cs
 multiply.sym

The --r1cs flag tells circom to generate an R1CS file and the --sym flag means “save the variable names.”

If you open multiply.r1cs, you will see a bunch of binary data, but inside the .sym file, you will see the names of the variables.

## To read the R1CS file, we use snarkjs as follows:

```bash
snarkjs r1cs print multiply.r1cs
```

```bash
[INFO]  snarkJS: [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.a ] * [ main.b ] - [ 21888242871839275222246405745257275088548364400416034343698204186575808495616main.out ] = 0
```

Remember, everything is done in a finite field when dealing with arithmetic circuits, so the massive number you see is essentially “-1”. The R1CS equation is equivalent to:

`-1 * a * b - (-1*out) = 0;`

This is equivalent to a * b = out, which is our original circuit.

## Non quadratic constraints are not allowed!

- A valid R1CS must have exactly one multiplication per constraint (row in R1CS, <== in Circom).
- If we try to do two (or more) multiplications, this will fail. 
- All constraints with more than one multiplication need to split into two constraints. 

> error[T3001]: Non quadratic constraints are not allowed!

# Computing the Witness

Run the following command to create code to generate the witness vector:

```bash
circom multiply.circom --r1cs --sym --wasm
```

This will regenerate the R1CS and symbol file, but also create a folder called multiply_js/.
We need to create an input.json file in that folder.

This is a map from the names of the signals designated input to the value that the prover will supply to them. Let’s set our input.json to have the following values:

```json
{"a": "2","b": "3","c": "5"}
```

## Calculate and export the witness:

```bash
node generate_witness.js multiply2.wasm input.json witness.wtns
```

This command creates `witness.wtns`. 
> Note: must be cd in the multiply2_js/ folder.

```bash
snarkjs wtns export json witness.wtns
```

This creates `witness.json`. `cat witness.json` to view contents.

The computed witness has values [1, 30, 2, 3, 5, 6]. 2, 3, and 5 are the inputs, and 6 is the intermediate signal s1 which is the product of 2 and 3. This follows the expected layout of the R1CS variables in the form [1, out, a, b, c, s1].

