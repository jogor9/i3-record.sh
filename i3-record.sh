#!/bin/sh

# edit this to your liking
encoderoptions='
-c:v h264_nvenc 
-pix_fmt yuv420p
-preset slow
-profile:v high
-rc vbr
-multipass fullres
-cq 18
-c:a libfdk_acc
-b:a 128k'

pgrep ffmpeg >/dev/null && {
        pkill -INT ffmpeg
        exit
}

[ -z "$RECPATH" ] && RECPATH="$HOME/recordings"

mkdir -p "$RECPATH" || exit 1

i3-msg -t get_tree |
        jq --raw-output '..
                         | select(.focused?)
                         | [.rect.x + .window_rect.x,
                            .rect.y + .window_rect.y,
                            .window_rect.width,
                            .window_rect.height]
                         | join(" ")' | {
        read -r X Y W H || exit 1
        [ $((W % 2)) -eq 1 ] && {
                W=$((W - 1))
        }
        [ $((H % 2)) -eq 1 ] && {
                H=$((H - 1))
        }
        exec ffmpeg -y \
                -f x11grab \
                -video_size "${W}x${H}" \
                -framerate 60 \
                -draw_mouse 0 \
                -i ":0.0+$X,$Y" \
                -f pulse \
                -i default \
                -vf "setpts=PTS-STARTPTS,fps=60" \
                $encoderoptions \
                "$HOME/recordings/$(date +%F-%H-%M-%S).mp4"
}
