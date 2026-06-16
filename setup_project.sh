#!/bin/bash

echo "Enter project name:"
read -r project

project_dir="attendance_tracker_${project}"

# Check if project already exists
if [ -d "$project_dir" ]; then
    echo "Error: Project directory '$project_dir' already exists."
    exit 1
fi

cleanup() {
    echo
    echo "Interrupt detected."

    if [ -d "$project_dir" ]; then
        echo "Creating archive..."

        tar -czf "${project_dir}_archive.tar.gz" "$project_dir"

        rm -rf "$project_dir"

        echo "Project archived and cleaned."
    fi

    exit 1
}

trap cleanup SIGINT

# Create directory structure
if ! mkdir -p "$project_dir/Helpers" "$project_dir/reports"; then
    echo "Error: Failed to create project directories."
    exit 1
fi

# Create files
if ! touch \
    "$project_dir/attendance_checker.py" \
    "$project_dir/Helpers/assets.csv" \
    "$project_dir/reports/reports.log"
then
    echo "Error: Failed to create required files."
    exit 1
fi

# Create config file
cat > "$project_dir/Helpers/config.json" <<EOF
{
  "warning": 75,
  "failure": 50
}
EOF

if [ $? -ne 0 ]; then
    echo "Error: Failed to create config.json."
    exit 1
fi

echo "Do you want to update thresholds? (y/n)"
read -r answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then

    # Warning threshold validation
    while true; do
        echo "Enter warning value:"
        read -r warning

        if [[ "$warning" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Numbers only."
        fi
    done

    # Failure threshold validation
    while true; do
        echo "Enter failure value:"
        read -r failure

        if [[ "$failure" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Numbers only."
        fi
    done

    sed -i "s/\"warning\": 75/\"warning\": $warning/" \
        "$project_dir/Helpers/config.json"

    sed -i "s/\"failure\": 50/\"failure\": $failure/" \
        "$project_dir/Helpers/config.json"

    echo "Configuration updated."
fi

echo
echo "Running Health Check..."

# Python validation
if python3 --version >/dev/null 2>&1; then
    echo "✓ Python3 found"
else
    echo "✗ Python3 not found"
fi

# Structure validation
if [ -d "$project_dir/Helpers" ] &&
   [ -d "$project_dir/reports" ] &&
   [ -f "$project_dir/attendance_checker.py" ] &&
   [ -f "$project_dir/Helpers/assets.csv" ] &&
   [ -f "$project_dir/Helpers/config.json" ] &&
   [ -f "$project_dir/reports/reports.log" ]
then
    echo "✓ Directory structure verified"
else
    echo "✗ Directory structure validation failed"
    exit 1
fi

echo
echo "Project setup completed successfully."
