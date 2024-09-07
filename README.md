# i3-record.sh

A script that uses FFmpeg to record the focused window in the i3 window manager.

# Usage

Run once to start the recording, then run again to stop it. Simply `bindsym` it to a single key. The file is saved in "$HOME/recordings/<current-date-and-time>"

# Requirements

* jq (for getting the focused window)
* procps (for `pgrep` to find the current instance of the script; most users probably already have this)
* FFmpeg (obviously)
* i3 (it's in the name, hello)

# Bugs

Running FFmpeg while the screen is being recorded will result in that FFmpeg process getting interrupted when the recording is stopped. (A solution would be to use a PID (lock)file containing the FFmpeg process currently being run, but eh).
