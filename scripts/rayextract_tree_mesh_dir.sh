# Get volume for all individual tree point clouds in a directory (txt format with xyz columns)

DATAPATH="/mnt/c/Users/wavdnbro/OneDrive - UGent/Documents/spacetwin/datasets/tmp_ply"
DATAPATH_OUT="${DATAPATH}_raycloud"


for FILE_PATH in "$DATAPATH"/*; do
    if [ -f "$FILE_PATH" ]; then
        FILE=$(basename "$FILE_PATH")
        echo "Processing file: $FILE"

        # Convert from txt to ply
        # TODO

        # Convert point cloud to raycloud
        sudo docker run --rm -v "$DATAPATH":/data raytools rayimport "$FILE" 0,0,-1 --max_intensity 0 --remove_start_pos;
        mv "$DATAPATH"/"${FILE%.ply}_raycloud.ply" "$DATAPATH_OUT"/"${FILE%.ply}_raycloud.ply"

        # Extract terrain
        sudo docker run --rm -v "$DATAPATH_OUT":/data raytools rayextract terrain "${FILE%.ply}_raycloud.ply";

        # Extract trees
        sudo docker run --rm -v "$DATAPATH_OUT":/data raytools rayextract trees "${FILE%.ply}_raycloud.ply" "${FILE%.ply}_raycloud_mesh.ply";

        # Remove unnecessary files
        # rm "$DATAPATH"/"${FILE%.ply}_raycloud.ply"
        # rm "$DATAPATH"/"${FILE%.ply}_raycloud_mesh.ply"
        # rm "$DATAPATH"/"${FILE%.ply}_raycloud_segmented.ply"

        # Get info
        # sudo docker run --rm -v "$DATAPATH":/data raytools treeinfo "${FILE%.ply}_raycloud_trees.txt"

        # Read and select info
    fi
done