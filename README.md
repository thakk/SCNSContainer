Contanerized [Single Cell Network Synthesis Toolkit](https://github.com/swoodhouse/SCNS-Toolkit)

# Building containers

Run helper script `build_containers.sh` . This will build scnscontainer and push it to local registry. Furthermore singularity image is built.

Singularity image is useful for running SCNS-Toolkit in HPC environment.

# Running in HPC

`mkdir output; singularity run -B /directory/in/host/containing/input/files/input:/SCNS-Toolkit/input scnscontainer-latest.sif input/cmpStates.csv input/cmpEdges.csv input/cmpParameters.csv input/cmp_initial_states.txt input/cmp_target_states.txt output`

