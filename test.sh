set -e
set -o xtrace
PO=/scratch/siddhart/gsoc2018/polly/build/bin/opt
LLC=/scratch/siddhart/gsoc2018/polly/build/bin/llc

CHPL_COMPILELINE=/scratch/siddhart/gsoc2018/chapel/util/config/compileline 
CHPL_LIBS=$($CHPL_COMPILELINE --libraries)
CHPL_MAINO=$($CHPL_COMPILELINE --main.o)

CHPL_LIBS2="-L/scratch/siddhart/gsoc2018/chapel/third-party/qthread/install/linux64-gnu-native-flat-jemalloc-hwloc/lib -Wl,-rpath,/scratch/siddhart/gsoc2018/chapel/third-party/qthread/install/linux64-gnu-native-flat-jemalloc-hwloc/lib -L/scratch/siddhart/gsoc2018/chapel/third-party/jemalloc/install/linux64-gnu-native/lib -Wl,-rpath,/scratch/siddhart/gsoc2018/chapel/third-party/jemalloc/install/linux64-gnu-native/lib -L/scratch/siddhart/gsoc2018/chapel/third-party/gmp/install/linux64-gnu-native/lib -Wl,-rpath,/scratch/siddhart/gsoc2018/chapel/third-party/gmp/install/linux64-gnu-native/lib -L/scratch/siddhart/gsoc2018/chapel/third-party/hwloc/install/linux64-gnu-native-flat/lib -Wl,-rpath,/scratch/siddhart/gsoc2018/chapel/third-party/hwloc/install/linux64-gnu-native-flat/lib -L/scratch/siddhart/gsoc2018/chapel/third-party/re2/install/linux64-gnu-native/lib -Wl,-rpath,/scratch/siddhart/gsoc2018/chapel/third-party/re2/install/linux64-gnu-native/lib   -L/scratch/siddhart/gsoc2018/chapel/lib/linux64/gnu/arch-native/loc-flat/comm-none/tasks-qthreads/tmr-generic/unwind-none/mem-jemalloc/atomics-intrinsics/hwloc/re2/fs-none /scratch/siddhart/gsoc2018/chapel/lib/linux64/gnu/arch-native/loc-flat/comm-none/tasks-qthreads/tmr-generic/unwind-none/mem-jemalloc/atomics-intrinsics/hwloc/re2/fs-none/main.o  -lchpl  -lm -lgmp -ljemalloc -lchpl -lqthread -L/scratch/siddhart/gsoc2018/chapel/third-party/hwloc/install/linux64-gnu-native-flat/lib -lhwloc -lm -lre2 -lpthread "

chpl affine_2d_init_2.chpl --no-checks --llvm --savec=save
cd save
gcc $(/scratch/siddhart/gsoc2018/chapel/util/config/compileline --includes-and-defines) -c chpl_compilation_config.c 
$PO -S -polly-canonicalize -instnamer chpl__module-nopt.bc > affine_canonicalized_2d_init.ll
$PO -S -polly-use-llvm-names -polly-only-func=test_chpl -polly-codegen-ppcg -polly-invariant-load-hoisting < affine_canonicalized_2d_init.ll > gpu.ll
$LLC gpu.ll -o gpu.s 
gcc $CHPL_MAINO gpu.s  chpl_compilation_config.o\
    -ldl -lcudart $CHPL_LIBS  \
    -o gpu 


#    -L/scratch/siddhart/gsoc2018/chapel-install/lib/chapel/1.18/runtime/lib/linux64/gnu/arch-native/loc-flat/comm-none/tasks-qthreads/tmr-generic/unwind-none/mem-jemalloc/atomics-intrinsics/hwloc/re2/fs-none \
#    -lchpl 
 
