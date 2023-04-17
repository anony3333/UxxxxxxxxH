# Artifact

## Code Structure
UHStencil: Source code of the UH stencil compiler.

UH-GPU: UHStencil on GPU test cases, dsls describing stencil computation and program entry

UH-SW: UHStencil on SW test cases, dsls describing stencil computation and program entry and drivers on SW platform.

compare/openearth: UHStencil compared with openearth on GPU. Including `mlir` files.

compare/MSC: UHStencil compared with MSC on SW platform. Including a `cc` file decribing all stencil computations and a Makefile.


scripts/evaluation_scripts_GPU: 
Run UH-Stencil on GPU. Some cases are fixed and the other cases are auto-generated.

scripts/evaluation_scripts_SW: All cases are auto-generated.

scripts/compare: Run MSC and openearth.

scripts/figure_scripts: Drawing Script

## How to install

See UHStencil/README.md.


## UHStencil on GPU
1. Run test_default.py. It will get into `${casename}` folder and run fixed tests for each case. The result will in `${casename}_specific.csv`

2. Run test_all.py. It will automaticly generate GPU side code and run the code. The result will be in `${casename}.csv`

3. Run wash.py to delete unlegal data in `csv` file.

4. Run collect.py to get fastest kernel and its parameters.



## UHStencil on SW

1. Generate Sunway side code

```bash
cd UH-SW
for i in `ls`; do cd $i && python3 tune_sw.py && cd -; done
```

Generate multiple cases based on tuning parameters, with the following files in each case: kernelstense_ 3d7pt_star.sw0_slave.c kernelstencil_3d7pt_star.sw_master.c
Alternatively, set parameters based on experience and execute bash/run_SW.sh generates a single case

2. Upload the Sunway code to Sunway Supercomputer

Connect Sunway and combine the kernel code with the main function stencil_ 3d7pt_Drive.serial.c to the/home/export/online3/ces/jzh directory
(First, download the code from the laboratory server to the local location, and then upload it to Sunway)

3. Run run_on_sunway.py to run all test cases in the directory

4. Run get_all_cases.py to collect all results in the directory and you can find the best result.

## Compare UHStencil with openearth compiler

```sh
cp scripts_for_compare/openearth/* compare/openearth -r
cd compare/openearth 
python3 test.py

```

## Compare UHStencil with MSC
```
cp scripts_for_compare/MSC/* compare/MSC
cd compare/openearth 
make
python3 MSC-test.py
```

## Reproduce Our Result
Run draw_ablation.py to draw our ablation test figure(Figure 10).

Collect all expriment result and write them in data.xlsx. Then run performance_merge.py to draw Figure 9.
