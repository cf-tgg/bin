ffmpeg -f x11grab -s 2560x1440 -framerate 30 -i :0.0+0,0 -c:v libx264 -preset veryfast -crf 23 -pix_fmt yuv420p ~/Videos/monitor_test_4.mp4
