import cv2
import mediapipe as mp
import pandas as pd
import os

from mediapipe.tasks import python
from mediapipe.tasks.python import vision

# تحميل المودل
base_options = python.BaseOptions(model_asset_path="hand_landmarker.task")
options = vision.HandLandmarkerOptions(
    base_options=base_options,
    num_hands=1
)

detector = vision.HandLandmarker.create_from_options(options)

data = []
labels = []

images_path = "unaugmented/416/train/images"
labels_path = "unaugmented/416/train/labels"

class_names = [
    'ALIF','BAA','TA','THA','JEEM','HAA','KHAA','DELL','DHELL',
    'RAA','ZAY','SEEN','SHEEN','SAD','DAD','TAA','DHAA',
    'AYN','GHAYN','FAA','QAAF','KAAF','LAAM','MEEM',
    'NOON','HA','WAW','YA'
]

for file in os.listdir(images_path):
    if not file.endswith(".jpg"):
        continue

    img_path = os.path.join(images_path, file)
    label_path = os.path.join(labels_path, file.replace(".jpg", ".txt"))

    if not os.path.exists(label_path):
        continue

    # اقرأ label
    with open(label_path, "r") as f:
        class_id = int(f.readline().split()[0])

    label_name = class_names[class_id]

    # اقرأ الصورة
    img = cv2.imread(img_path)
    if img is None:
        continue

    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # تحويل للصيغة المطلوبة
    mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=img_rgb)

    result = detector.detect(mp_image)

    if result.hand_landmarks:
        for hand_landmarks in result.hand_landmarks:
            row = []
            for lm in hand_landmarks:
                row.extend([lm.x, lm.y, lm.z])

            data.append(row)
            labels.append(label_name)

df = pd.DataFrame(data)
df["label"] = labels
df.to_csv("landmarks.csv", index=False)

print("✅ landmarks.csv جاهز")