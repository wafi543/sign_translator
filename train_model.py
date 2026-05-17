from sklearn.ensemble import RandomForestClassifier
import pandas as pd
import joblib

df = pd.read_csv("landmarks.csv")

X = df.drop("label", axis=1)
y = df["label"]

model = RandomForestClassifier(n_estimators=100)
model.fit(X, y)

joblib.dump(model, "model.pkl")

print("✅ model.pkl جاهز")