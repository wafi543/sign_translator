from flask import Flask, request, jsonify
import joblib
import numpy as np
import cv2
import mediapipe as mp

app = Flask(__name__)

model = joblib.load("model.pkl")

mp_hands = mp.solutions.hands
hands = mp_hands.Hands()

@app.route("/")
def home():
    return "Sign Translator API Running 🚀"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        file = request.files["image"]

        # قراءة الصورة
        npimg = np.frombuffer(file.read(), np.uint8)
        img = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        result = hands.process(img_rgb)

        if not result.multi_hand_landmarks:
            return jsonify({"result": "no_hand"})

        # استخراج landmarks
        row = []
        for lm in result.multi_hand_landmarks[0].landmark:
            row.extend([lm.x, lm.y, lm.z])

        prediction = model.predict([row])[0]

        return jsonify({
            "result": prediction
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# مهم جدًا للسيرفر
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)