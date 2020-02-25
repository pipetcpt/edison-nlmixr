#!/bin/bash

cp $2 input.dat

singularity exec --bind $PWD:/mnt /SYSTEM_BULB/Singularity/images/nlmixr.sif Rscript -e 'source("./runscript.r", keep.source=TRUE, echo=TRUE)'

rm -rf input.dat
