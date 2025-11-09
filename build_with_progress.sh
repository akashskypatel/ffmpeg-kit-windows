#!/usr/bin/env bash

# ========================================================================================
# Generic Progress Bar Wrapper for cross_compile_ffmpeg.sh
# ========================================================================================
# This script intelligently queries the main build script for its steps and
# executes them one by one, providing a clean progress bar and individual logs.
#
# It can accept any arguments and will pass them on to the main script.
# If no arguments are given, it uses the default set defined below.
#
# ========================================================================================

# --- CONFIGURATION ---
readonly MAIN_SCRIPT="./cross_compile_ffmpeg_progress.sh"

# Define the default arguments to use if none are passed to this script.
readonly DEFAULT_SCRIPT_ARGS=(
  "--compiler-flavors=win64"
  "--build-ffmpeg-static=y"
  "--build-ffmpeg-shared=n"
  "--enable-gpl=n"
  "--disable-nonfree=y"
  "--git-get-latest=n"
  "--build-mplayer=n"
  "--build-mp4box=n"
  "--build-vlc=n"
)
# --- END CONFIGURATION ---

set -e # Exit immediately if a command fails

# Use arguments passed to this script, or fall back to the defaults.
if [[ $# -gt 0 ]]; then
  readonly SCRIPT_ARGS=("$@")
else
  readonly SCRIPT_ARGS=("${DEFAULT_SCRIPT_ARGS[@]}")
fi

readonly LOG_DIR="build_logs"
mkdir -p "$LOG_DIR"

# --- Function to print a formatted progress bar ---
print_progress() {
  local step_num=$1
  local step_name=$2
  local term_width=$(tput cols 2>/dev/null || echo 80)
  
  local color_reset='\033[0m'
  local color_green='\033[0;32m'
  local color_blue='\033[0;34m'
  local color_yellow='\033[1;33m'

  local percent=$(( (100 * step_num) / TOTAL_STEPS ))
  local progress_bar_width=$(( term_width - 30 ))
  local filled_len=$(( (progress_bar_width * percent) / 100 ))
  
  local bar=""
  for ((i=0; i<filled_len; i++)); do bar+="="; done
  for ((i=filled_len; i<progress_bar_width; i++)); do bar+=" "; done

  printf "\n${color_yellow}======================================================================${color_reset}\n"
  printf "${color_green}Step %-3s of %-3s (%3s%%) [${bar}]${color_reset}\n" "$((step_num + 1))" "$TOTAL_STEPS" "$percent"
  printf "${color_blue}BUILDING: %s${color_reset}\n" "$step_name"
  printf "Output is being logged to: ${LOG_DIR}/%02d-%s.log\n" "$((step_num + 1))" "$step_name"
  printf "${color_yellow}======================================================================${color_reset}\n\n"
}

# --- Main Build Loop ---
echo "--- Initializing build... Querying total steps from main script. ---"
readonly TOTAL_STEPS=$("$MAIN_SCRIPT" "${SCRIPT_ARGS[@]}" --get-total-steps)
echo "--- Found $TOTAL_STEPS total build steps. ---"

# Loop from 0 to (TOTAL_STEPS - 1)
for (( i=0; i<TOTAL_STEPS; i++ )); do
  # Get the name of the current step from the main script
  step_name=$("$MAIN_SCRIPT" "${SCRIPT_ARGS[@]}" --get-step-name="$i")
  
  # Print the progress bar for the current step
  print_progress "$i" "$step_name"
  
  # Execute the build for this specific step by index, logging all output
  "$MAIN_SCRIPT" "${SCRIPT_ARGS[@]}" --build-only-index="$i" &> "${LOG_DIR}/$(printf "%02d" "$((i+1))")-${step_name}.log"
  
  if [[ $? -ne 0 ]]; then
    echo -e "\n\033[0;31m*** ERROR: Build step '$step_name' failed. ***\033[0m"
    echo "Please check the log file for details: ${LOG_DIR}/$(printf "%02d" "$((i+1))")-${step_name}.log"
    exit 1
  fi
done

echo -e "\n\033[1;32m*** BUILD COMPLETE! All steps finished successfully. ***\033[0m"