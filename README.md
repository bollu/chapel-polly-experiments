# chapel-polly-experiments
A repo to easily experiment with chapel + polly code.

## Files
- `input.chpl`: the input chapel file from which LLVM IR is generated 
- `mkll.sh`: generate `input.ll` file. I usually run this and then edit the `.ll` file to understand the problem better
- `build.sh`: build the `input.ll` file, link, etc. there is a variable `$GPU` in `build.sh` that controls if polly runs or not. 
   This is useful to disable polly to test if the changes one makes to `input.ll` are correct.
- `run.sh`: runs the final binary on the CSCS system using `slurm`, probably useless for most people using this.
   

## Warts
- paths are hardcoded to LLVM, Polly & Chapel
