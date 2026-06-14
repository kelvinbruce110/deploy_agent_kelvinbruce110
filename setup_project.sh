#!/bin/bash

echo "Enter project name:"
read project

project_dir="attendance_tracker_${project}"

cleanup() {
    echo
    echo "Interrupt detected"

    tar -czf "${project_dir}_archive.tar.gz" "$project_dir"

    rm -rf "$project_dir"

    echo "Project archived"

    exit 1
}

trap cleanup SIGINT

mkdir -p "$project_dir"/Helpers
mkdir -p "$project_dir"/reports

touch "$project_dir"/attendance_checker.py
touch "$project_dir"/Helpers/assets.csv
touch "$project_dir"/Helpers/config.json
touch "$project_dir"/reports/reports.log

cat > "$project_dir/Helpers/config.json" <<EOF
{
  "warning": 75,
  "failure": 50
}
EOF

echo "Do you want to update thresholds? (y/n)"

read -r answer

if [ "$answer" = "y" ]; then

    while true; do
        echo "Enter warning value:"
        read -r warning

        if [[ "$warning" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Please enter numbers only."
        fi
    done

    while true; do
        echo "Enter failure value:"
        read -r failure

        if [[ "$failure" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input. Please enter numbers only."
        fi
    done

    sed -i "s/\"warning\": 75/\"warning\": $warning/" \
    "$project_dir/Helpers/config.json"

    sed -i "s/\"failure\": 50/\"failure\": $failure/" \
    "$project_dir/Helpers/config.json"
fi

echo "Running Health Check..."

if python3 --version >/dev/null 2>&1
then
    echo "Python3 found."
else
    echo "WARNING: Python3 not found."
fi

if [ -d "$project_dir/Helpers" ] &&
   [ -d "$project_dir/reports" ] &&
   [ -f "$project_dir/attendance_checker.py" ]
then
    echo "Directory structure verified."
else
    echo "Directory structure validation failed."
fi

echo "Project setup completed successfully."
