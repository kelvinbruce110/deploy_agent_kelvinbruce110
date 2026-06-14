#!/bin/bash

echo "Enter project name:"
read project

project_dir="attendance_tracker_${project}"

cleanup() {
    echo
    echo "CTRL+C detected"
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
read answer

if [ "$answer" = "y" ]
then
    echo "Enter warning value:"
    read warning

    echo "Enter failure value:"
    read failure

    sed -i "s/\"warning\": 75/\"warning\": $warning/" \
    "$project_dir/Helpers/config.json"

    sed -i "s/\"failure\": 50/\"failure\": $failure/" \
    "$project_dir/Helpers/config.json"
fi

echo "Press CTRL+C within 10 seconds to test trap"
sleep 10

echo "Setup completed."
