"""Script to generate PNG silhouettes using Google Generative AI."""

import google.generativeai as genai

# Configure with your API key
genai.configure(api_key="YOUR_API_KEY")

# The prompt from our refined prompt file
PROMPT_TEXT = """
Analyze the attached image and generate a PNG file...
[...your full prompt text here...]
"""

# Load the image and prompt
model = genai.GenerativeModel("gemini-1.5-pro")
source_image = genai.upload_file(path="PXL_20250915_172025980.jpg")

# Make the API call
response = model.generate_content([PROMPT_TEXT, source_image])

# Save the generated image data from the response
# (The exact syntax for saving the file may vary based on API response structure)
with open("output_silhouette.png", "wb") as f:
    f.write(response.parts[0].blob.data)

print("Silhouette PNG created successfully!")
