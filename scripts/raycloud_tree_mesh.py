import os
import sys
import subprocess
from multiprocessing import Pool
import open3d as o3d
import argparse


def txt_to_ply(input_file):
    # Read txt file
    points = []
    with open(input_file, 'r') as f:
        for line in f:
            data = line.strip().split()
            if len(data) >= 3:
                points.append([float(data[0]), float(data[1]), float(data[2])])

    # Create PointCloud object
    point_cloud = o3d.geometry.PointCloud()
    point_cloud.points = o3d.utility.Vector3dVector(points)

    # Output ply file name
    ply_file =  os.path.join(os.path.dirname(input_file), "ply/", os.path.splitext(os.path.basename(input_file))[0] + ".ply")

    # Write to ply file
    o3d.io.write_point_cloud(ply_file, point_cloud)
    print(f"Converted {input_file} to {ply_file}")


def process_ply(ply_file):
    subprocess.run(["/home/woutervdb/spacetwin/repo/raycloudtools/scripts/rayextract_tree_mesh.sh", ply_file])

def main(args):
    if not os.path.isdir(args.directory):
        print("Directory not found!")
        sys.exit(1)

    txt_files = [os.path.join(args.directory, file) for file in os.listdir(args.directory) if file.endswith(".txt")]

    

    # Convert txt files to ply files if specified
    if args.convert_to_ply:
        # Create output directory if not exists
        directory_ply = os.path.join(args.directory, "ply")
        if not os.path.exists(directory_ply):
            os.makedirs(directory_ply)

        ply_files = []
        for txt_file in txt_files:
            ply_file = txt_to_ply(txt_file)
            ply_files.append(ply_file)
    else:
        ply_files = [os.path.join(args.directory, file) for file in os.listdir(args.directory) if file.endswith(".ply")]

    # Process ply files
    with Pool() as pool:
        print(ply_files)
        pool.map(process_ply, ply_files)

    print("Processing complete.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert txt files to ply and process them.")
    parser.add_argument("directory", type=str, help="Directory containing files.")
    parser.add_argument("--convert_to_ply", action="store_true", help="Convert txt files to ply files.")
    args = parser.parse_args()

    main(args)
