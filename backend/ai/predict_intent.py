import joblib

from preprocessing import NLPPreprocessor

# Load trained model
model = joblib.load("ai/intent_model.pkl")

# Load vectorizer
vectorizer = joblib.load("ai/vectorizer.pkl")

# Initialize preprocessor
preprocessor = NLPPreprocessor()


print("=" * 50)
print("FitNova AI Intent Predictor")
print("Type 'exit' to quit.")
print("=" * 50)

while True:

    user_input = input("\nYou: ")

    if user_input.lower() == "exit":
        break

    # Clean the text
    cleaned = preprocessor.clean_text(user_input)

    # Convert into vector
    vector = vectorizer.transform([cleaned])

    # Predict
    prediction = model.predict(vector)[0]

    print(f"Intent: {prediction}")