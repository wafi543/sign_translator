from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# تحميل المودل
model = joblib.load("model.pkl")

@app.route("/")
def home():
    return "Sign Translator API Running 🚀"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.json["landmarks"]

        # تأكد من الشكل
        if len(data) != 63:
            return jsonify({"error": "Invalid landmarks length"}), 400

        prediction = model.predict([data])[0]

        return jsonify({
            "result": prediction
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# مهم جدًا للسيرفر
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)