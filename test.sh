set -e
set -o xtrace
PO=/scratch/siddhart/gsoc2018/polly/build/bin/opt
LLC=/scratch/siddhart/gsoc2018/polly/build/bin/llc
LLVM_LIBS_DIR=/scratch/siddhart/gsoc2018/polly/build/lib

CHPL_COMPILELINE=/scratch/siddhart/gsoc2018/chapel/util/config/compileline 
CHPL_LIBS=$($CHPL_COMPILELINE --libraries)
CHPL_MAINO=$($CHPL_COMPILELINE --main.o)

chpl affine_2d_init_2.chpl --no-checks --llvm --savec=save
cd save
gcc $(/scratch/siddhart/gsoc2018/chapel/util/config/compileline --includes-and-defines) -c chpl_compilation_config.c 
$PO -S -polly-canonicalize -instnamer chpl__module-nopt.bc > affine_canonicalized_2d_init.ll

#  polly
$PO -S -polly-use-llvm-names \
    -polly-only-func=test_chpl \
    -polly-scops \
    -polly-process-unprofitable \
    -polly-codegen-ppcg \
    -polly-ignore-aliasing \
    -polly-invariant-load-hoisting  \
    -polly-codegen-emit-rtc-print \
    -debug-only=polly-scops,polly-codegen-ppcg affine_canonicalized_2d_init.ll -o gpu.ll

$LLC gpu.ll -o gpu.s 
gcc $CHPL_MAINO gpu.s  chpl_compilation_config.o\
    -ldl -lcudart $CHPL_LIBS -lGPURuntime -L$LLVM_LIBS_DIR \
    -o gpu 
