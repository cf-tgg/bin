import json
import subprocess

def parse_playlist_and_notify(playlist_json_path):
    # Load JSON data
    with open(playlist_json_path, 'r') as f:
        playlist = json.load(f)

    # Create a playlist file for mpv
    playlist_file = '/tmp/mpv_playlist.m3u'
    with open(playlist_file, 'w') as pf:
        for video in playlist:
            # Write the video URL to the mpv playlist
            pf.write(video['URI'] + '\n')

            # Notify dunst with video description
            description = video['Description']
            title = video['Title']
            subprocess.run(['dunst', 'notify', '-t', '5000', '-u', 'normal', title, description])

    # Use mpv to play the playlist
    subprocess.run(['mpv', '--playlist', playlist_file])

# Example usage:
parse_playlist_and_notify('/path/to/playlist.json')
