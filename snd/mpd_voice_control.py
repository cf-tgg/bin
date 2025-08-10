from vosk import Model, KaldiRecognizer
import os
import json
import subprocess

model_path = "$HOME/.local/share/kdenlive/speechmodels/vosk-model-en-us-0.22/"
if not os.path.exists(model_path):
    print("Download Vosk model from https://alphacephei.com/vosk/models and unpack it here.")
    exit(1)

try:
    print("Loading Vosk model, this may take some time...")
    model = Model(model_path)
    print("Model loaded successfully!")

    rec = KaldiRecognizer(model, 16000)
    fifo_path = "/tmp/mpd_input.fifo"

    if not os.path.exists(fifo_path):
        os.mkfifo(fifo_path)

    with open(fifo_path, "rb") as fifo:
        print("Listening for voice commands...")
        while True:
            data = fifo.read(4000)
            if len(data) == 0:
                break
            if rec.AcceptWaveform(data):
                result = json.loads(rec.Result())
                command = result.get("text", "").lower()
                print(f"Recognized command: {command}")
                if "play" in command:
                    subprocess.run(["mpc", "play"])
                elif "pause" in command:
                    subprocess.run(["mpc", "pause"])
                elif "next" in command:
                    subprocess.run(["mpc", "next"])
                elif "stop" in command:
                    subprocess.run(["mpc", "stop"])
                elif "search" in command:
                    search = command.split("search")[-1].strip()
                    if "artist" in search:
                        artist = search.split("artist")[-1].strip()
                        subprocess.run(["mpc", "search", "artist", artist])
                    elif "album" in search:
                        album = search.split("album")[-1].strip()
                        subprocess.run(["mpc", "search", "album", album])
                    elif "title" in search:
                        title = search.split("title")[-1].strip()
                        subprocess.run(["mpc", "search", "title", title])

finally:
    if 'model' in locals():
        del model
