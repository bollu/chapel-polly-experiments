set -o xtrace
set -e

PO=/scratch/siddhart/gsoc2018/polly/build/bin/opt
LLC=/scratch/siddhart/gsoc2018/polly/build/bin/llc
LLVM_LIBS_DIR=/scratch/siddhart/gsoc2018/polly/build/lib

CHPL_COMPILELINE=/scratch/siddhart/gsoc2018/chapel/util/config/compileline 
CHPL_LIBS=$($CHPL_COMPILELINE --libraries)
CHPL_MAINO=$($CHPL_COMPILELINE --main.o)

cd save
echo " ---"
#  polly
$PO -S -polly-use-llvm-names \
    -polly-only-func=test_chpl \
    -polly-scops \
    -polly-process-unprofitable \
    -polly-codegen-ppcg \
    -polly-ignore-aliasing \
    -polly-invariant-load-hoisting  \
    -polly-codegen-emit-rtc-print \
    -polly-acc-dump-kernel-ir \
    -debug-only=polly-scops,polly-codegen-ppcg input.ll -o out.ll
echo " ---"

$LLC out.ll -o out.s 
gcc $CHPL_MAINO out.s  chpl_compilation_config.o\
    -ldl -lcudart $CHPL_LIBS -lGPURuntime -L$LLVM_LIBS_DIR \
    -o out 
