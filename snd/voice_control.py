from vosk import Model, KaldiRecognizer
import wave
import json

model_path = "$HOME/.local/share/kdenlive/speechmodels/vosk-model-en-us-0.22/"
model = Model(model_path)
rec = KaldiRecognizer(model, 48000)

with wave.open("test_audio.wav", "rb") as wf:  # Use a simple test audio file
    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            result = json.loads(rec.Result())
            print("Recognized command:", result.get("text", ""))
