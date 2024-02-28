# Docker commands for extracting trees from plotscale pointcloud

DATAPATH=/home/woutervdb/projects/data/cax2023
FILE="2023-10-07_cax_PA 0.025 m.ply"

# Convert point cloud to raycloud
sudo docker run --rm -v $DATAPATH:/data raytools rayimport $FILE ray 0,0,-1 --max_intensity 0 --remove_start_pos;

# Extract terrain
sudo docker run --rm -v $DATAPATH:/data raytools rayextract terrain $FILE;

# Extract trunks
sudo docker run --rm -v $DATAPATH:/data raytools rayextract trunks  FILE _raycloud.ply;

# Extract forest
sudo docker run --rm -v $DATAPATH:/data raytools rayextract forest  FILE _raycloud.ply;

# Extract trees
sudo docker run --rm -v $DATAPATH:/data raytools rayextract trees FILE _raycloud.ply FILE _raycloud_mesh.ply;