#!/bin/bash

# Get volume for a single tree point cloud in ply format

FILE_PATH=$1;
FILE=$(basename "$FILE_PATH");
DIR_PARENT="$(dirname "$(dirname "$FILE_PATH")")";
DIR_PLY="$(dirname "$FILE_PATH")";
DIR_RAYCLOUD="$DIR_PARENT"/raycloud; mkdir -p "$DIR_RAYCLOUD";
DIR_TERRAIN="$DIR_PARENT"/terrain; mkdir -p "$DIR_TERRAIN";
DIR_TREE="$DIR_PARENT"/tree; mkdir -p "$DIR_TREE";

echo "Processing file: $FILE_PATH"

# Convert point cloud to raycloud
docker run --rm -v "$DIR_PLY":/data raytools rayimport "$FILE" 0,0,-1 --max_intensity 0 --remove_start_pos;
mv "$DIR_PLY"/"${FILE%.ply}_raycloud.ply" "$DIR_RAYCLOUD"/"${FILE%.ply}_raycloud.ply";

# Extract terrain
docker run --rm -v "$DIR_RAYCLOUD":/data raytools rayextract terrain "${FILE%.ply}_raycloud.ply";
mv "$DIR_RAYCLOUD"/"${FILE%.ply}_raycloud_mesh.ply" "$DIR_TERRAIN"/"${FILE%.ply}_raycloud_mesh.ply";

# Extract trees
docker run --rm -v "$DIR_PARENT":/data raytools rayextract trees raycloud/"${FILE%.ply}_raycloud.ply" terrain/"${FILE%.ply}_raycloud_mesh.ply";
mv "$DIR_RAYCLOUD"/"${FILE%.ply}_raycloud_trees_mesh.ply" "$DIR_TREE"/"${FILE%.ply}_raycloud_trees_mesh.ply";
mv "$DIR_RAYCLOUD"/"${FILE%.ply}_raycloud_trees.txt" "$DIR_TREE"/"${FILE%.ply}_raycloud_trees.txt";
mv "$DIR_RAYCLOUD"/"${FILE%.ply}_raycloud_segmented.ply" "$DIR_TREE"/"${FILE%.ply}_raycloud_segmented.ply";
