#!/bin/bash

# Define module directories
modules=("network" "compute_instance" "keypair" "storage" "volume_attach")

# Create the modules directory if it doesn't exist
mkdir -p modules

# Loop through and create necessary files for each module
for module in "${modules[@]}"; do
    mkdir -p "modules/$module"
    touch "modules/$module/main.tf"
    touch "modules/$module/variables.tf"
    touch "modules/$module/outputs.tf"
done

echo "Module structure generated!"