#!/bin/bash -e

FOAM_RUN=$HOMEH/OpenFOAM/sws02hs-dev/run

pngFiles=(
shallowWater/WilliSteady/bucky4_refine/constant/mesh_30.eps
shallowWater/WilliSteady/cube12_eq_refine/constant/mesh_30.eps
shallowWater/WilliSteady/24x48_refine/constant/mesh_30.eps
shallowWater/WilliSteady/tri4_refine/constant/mesh_30.eps

shallowWater/WilliMountain/96x192/ref2/1296000/hDiff400.eps
shallowWater/WilliMountain/bucky5_refine/save/dt_900_cubicUpwind_coeff_0/1296000/hDiff400.eps
shallowWater/WilliMountain/tri5_refine/save/dt_900_quadUpwind_linInterp/1296000/hDiff400.eps
shallowWater/WilliMountain/cube24_eq_refine/save/dt_900_cubicUpwind_coeff_0/1296000/hDiff400.eps
shallowWater/WilliMountain/48x96_refine/save/dt_900_cubicUpwind_coeff_0/1296000/hDiff400.eps
shallowWater/WilliMountain/legends/hDiff400_hDiff.eps

shallowWater/baroInstab/288x576/0/hDiff.eps
shallowWater/baroInstab/288x576/0/vorticityFilled.eps
shallowWater/baroInstab/576x1152/518400/vorticitySJD+08.eps
shallowWater/baroInstab/bucky8/518400/vorticitySJD+08.eps
shallowWater/baroInstab/Voronoi8_refine/518400/vorticitySJD+08.eps
shallowWater/baroInstab/cube144_eq/518400/vorticitySJD+08.eps
shallowWater/baroInstab/cube144_eq_refine/518400/vorticitySJD+08.eps
shallowWater/baroInstab/288x576/518400/vorticitySJD+08.eps
shallowWater/baroInstab/288x576_refine/518400/vorticitySJD+08.eps
shallowWater/baroInstab/288x576_30/518400/vorticitySJD+08.eps
shallowWater/baroInstab/legends/vorticitySJD+08_vorticity.eps

shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475200/vorticityFilledMeshLines.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475201/vorticityFilledMeshLines.eps
shallowWater/baroInstab/legends/vorticityFilledMeshLines_vorticity.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/475200/vorticity.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/518400/vorticity.eps

shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/475200/magGradvortDivMapped.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/518400/magGradvortDivMapped.eps
shallowWater/baroInstab/legends/magGradvortDiv.eps
shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/meshing/save_518400/518400/requiredResolution.eps

shallowWater/baroInstab/predictAdvectMagGrad/save/dx_6e4_spread_1_magGradVortDiv_1-4e-10/475201/mesh_N_reqRes.eps
)

pdfFiles=(
shallowWater/WilliMountain/plotWerrors/plotsC/l2.eps
shallowWater/WilliMountain/plotWerrors/plotsC/l2_n.eps
shallowWater/baroInstab/legends/requiredResUnder_requiredResolution.eps

shallowWater/baroInstab/plotAll/plotsC/nCells.eps
shallowWater/baroInstab/plotAll/plotsC/l2.eps
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
    elif [ `stat -c "%Z" $f` -gt `stat -c "%Z" $pngFile` ]; then
        echo re-converting $file to png
        eps2png $f
#    else
#        echo $pngFile is newer
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
    elif [ `stat -c "%Z" $f` -gt `stat -c "%Z" $pdfFile` ]; then
        echo re-converting $file to pdf
        makebb $f
        epstopdf $f
#    else
#        echo $pdfFile is newer
    fi

    rsync -ut $pdfFile $fileNew
done
