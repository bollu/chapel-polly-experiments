set -e
# clear the folder
rm -rf save/*;

PO=/scratch/siddhart/gsoc2018/polly/build/bin/opt
LLC=/scratch/siddhart/gsoc2018/polly/build/bin/llc
LLVM_LIBS_DIR=/scratch/siddhart/gsoc2018/polly/build/lib

CHPL_COMPILELINE=/scratch/siddhart/gsoc2018/chapel/util/config/compileline 
CHPL_LIBS=$($CHPL_COMPILELINE --libraries)
CHPL_MAINO=$($CHPL_COMPILELINE --main.o)


chpl input.chpl --no-checks --llvm --savec=save
cd save
gcc $(/scratch/siddhart/gsoc2018/chapel/util/config/compileline --includes-and-defines) -c chpl_compilation_config.c 
$PO -S -polly-canonicalize -instnamer chpl__module-nopt.bc > input.ll
sed -i 's/polly_array_index/polly_array_index_2/g' input.ll 
