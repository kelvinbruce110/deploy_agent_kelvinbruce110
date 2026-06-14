# Student Attendance Tracker Deployment Agent

## Repository Name

deploy_agent_kelvinbruce110

---

## Project Description

This project contains a Bash script (`setup_project.sh`) that automates the deployment of a Student Attendance Tracker workspace.

The script creates the required directory structure, generates the necessary files, allows users to update attendance threshold values through the command line, performs environment validation, and handles user interruptions gracefully using signal trapping.

---

## Features

### 1. Directory Architecture

The script creates a project directory using the following naming convention:

```text
attendance_tracker_<project_name>
```

Inside the project directory, the following structure is generated:

```text
attendance_tracker_<project_name>/
│
├── attendance_checker.py
│
├── Helpers/
│   ├── assets.csv
│   └── config.json
│
└── reports/
    └── reports.log
```

### 2. Dynamic Configuration

The script prompts the user to decide whether they would like to update attendance threshold values.

Default values:

* Warning: 75%
* Failure: 50%

If the user chooses to update them, the script uses the `sed` command to modify the values in `config.json`.

### 3. Signal Handling and Archiving

The script implements a SIGINT trap to handle `CTRL+C` interruptions.

If the user interrupts execution:

1. The current project directory is archived into a `.tar.gz` file.
2. The incomplete project directory is removed.
3. The script exits gracefully.

Archive naming format:

```text
attendance_tracker_<project_name>_archive.tar.gz
```

### 4. Environment Validation

Before completion, the script performs a health check by:

* Verifying that Python 3 is installed using:

```bash
python3 --version
```

* Validating that all required directories and files were successfully created.

---

## Requirements

* Linux environment
* Bash shell
* Python 3

---

## How to Run

Make the script executable:

```bash
chmod +x setup_project.sh
```

Run the script:

```bash
./setup_project.sh
```

Follow the prompts displayed on the screen.

---

## Testing the Archive Feature

Run the script:

```bash
./setup_project.sh
```

While it is running, press:

```text
CTRL+C
```

The script should:

1. Create a compressed archive of the current project.
2. Remove the incomplete project directory.
3. Exit with a cleanup message.

---

## Video Walkthrough

Video Demonstration:

PASTE_YOUR_VIDEO_LINK_HERE

---

## Author

GitHub Username: kelvinbruce110

