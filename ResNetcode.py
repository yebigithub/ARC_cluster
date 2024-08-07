import keras
from keras.applications.resnet50 import ResNet50, preprocess_input, decode_predictions
import numpy as np

# Load the model
model = ResNet50(weights='imagenet')

# Load and preprocess the image
img_path = 'elephant.jpeg'
img = keras.utils.load_img(img_path, target_size=(224, 224))
x = keras.utils.img_to_array(img)
x = np.expand_dims(x, axis=0)
x = preprocess_input(x)

# Perform the prediction
preds = model.predict(x)

# Decode the predictions into a list of tuples (class, description, probability)
decoded_preds = decode_predictions(preds, top=3)[0]

# Print the predictions
print('Predicted:', decoded_preds)

# Save the predictions to a text file
output_file = 'predictions.txt'
with open(output_file, 'w') as file:
    file.write('Predicted:\n')
    for class_id, description, score in decoded_preds:
        file.write(f'{class_id}: {description} ({score:.4f})\n')

print(f'Predictions saved to {output_file}')