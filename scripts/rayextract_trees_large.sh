# grids the large raycloud file $1 (written without the .ply extension), performs rayextract trees on each grid cell, 
# then combines the results into a single $1_trees.txt file. 
# ./rayextract_trees_large cloudname 50
set -x

sudo docker run --rm -v ./.:/data raytools raysplit $1.ply grid $2,$2,0 8
# raysplit $1.ply grid $2,$2,0 5  # 5 m overlap to avoid edge artefacts. This should be the width of the widest tree.
rm -rf gridfiles_cloud
rm -rf gridfiles_mesh
rm -rf gridfiles_trees
rm -rf gridfiles_trees_mesh
rm -rf gridfiles_segmented
mkdir gridfiles_cloud   
mkdir gridfiles_mesh      
mkdir gridfiles_trees     
mkdir gridfiles_trees_mesh 
mkdir gridfiles_segmented 

mv $1_*.ply gridfiles_cloud
cd gridfiles_cloud
for f in $1_*.ply;              # a parallel for can be used here
do
   sudo docker run --rm -v ./.:/data raytools rayextract terrain $f
   # rayextract terrain $f
   mv *_mesh.ply ../gridfiles_mesh
   cd ..
   sudo docker run --rm -v ./.:/data raytools rayextract trees ./gridfiles_cloud/$f ./gridfiles_mesh/${f%.ply}_mesh.ply --grid_width $2
   cd gridfiles_cloud
   # rayextract trees $f ../gridfiles_mesh/${f%.ply}_mesh.ply --grid_width $2
   mv *_segmented.ply ../gridfiles_segmented
   mv *_trees.txt ../gridfiles_trees
   mv *_trees_mesh.ply ../gridfiles_trees_mesh
done

cd ../gridfiles_trees
sudo docker run --rm -v ./.:/data raytools treecombine $1_*_trees.txt
mv *_combined.txt ../$1_trees.txt
cd ..
set +x
# output cloudname_trees.txt
