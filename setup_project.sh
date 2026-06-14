#!/bin/bash

echo "Enter project name:"
read project

project_dir="attendance_tracker_${project}"

mkdir -p "$project_dir"/Helpers
mkdir -p "$project_dir"/reports

touch "$project_dir"/attendance_checker.py
touch "$project_dir"/Helpers/assets.csv
touch "$project_dir"/Helpers/config.json
touch "$project_dir"/reports/reports.log

echo "Project structure created successfully."
