#!/bin/bash -e

FOAM_RUN=$HOMEH/OpenFOAM/sws02hs-dev/run

pngFiles=(
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475201/mesh_N_reqRes.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475201/mesh_N_reqRes.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475200/vorticityFilledMeshLines.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475201/vorticityFilledMeshLines.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/518400/vorticityFilledMeshLines.eps

shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/475200/magGradvortDiv.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/475200/magGradvortDivMapped.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/518400/magGradvortDiv.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/518400/magGradvortDivMapped.eps
)

pdfFiles=(
shallowWater/baroInstab/legends/requiredResUnder_requiredResolution.eps
shallowWater/baroInstab/legends/vorticityFilledMeshLines_vorticity.eps
shallowWater/baroInstab/legends/magGradvortDiv.eps
)

for file in ${pngFiles[*]}
do
    f=$FOAM_RUN/$file
    fRoot=`dirname $f`/`basename $f .eps`
    pngFile=$fRoot.png
    fileNew=graphics/`echo $file |sed 's/\//+/g' | sed 's/\./p/g' | sed 's/peps/\.png/g'`

    if [ ! -e $pngFile ]; then
        echo converting $file to png
        eps2png $f
    elif [ `stat -c "%Y" $f` -gt `stat -c "%Y" $pngFile` ]; then
        echo re-converting $file to png
        eps2png $f
    else
        echo $pngFile is newer
    fi

    rsync -ut $pngFile $fileNew
done

for file in ${pdfFiles[*]}
do
    f=$FOAM_RUN/$file
    fRoot=`dirname $f`/`basename $f .eps`
    pdfFile=$fRoot.pdf
    fileNew=graphics/`echo $file |sed 's/\//+/g' | sed 's/\./p/g' | sed 's/peps/\.pdf/g'`

    if [ ! -e $pdfFile ]; then
        echo converting $file to pdf
        makebb $f
        epstopdf $f
    elif [ `stat -c "%Y" $f` -gt `stat -c "%Y" $pdfFile` ]; then
        echo re-converting $file to pdf
        makebb $f
        epstopdf $f
    else
        echo $pdfFile is newer
    fi

    rsync -ut $pdfFile $fileNew
done
