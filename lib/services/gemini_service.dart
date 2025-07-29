import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/fish_identification.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyCZH1KDfnRN8rD6dgBUdj8hd3fhcXHXtEY';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<FishIdentification?> identifyFish(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      
      final prompt = '''
You are an expert marine biologist and fish identification specialist with extensive knowledge of seafood and culinary applications. 
Analyze this image and identify the fish or aquatic animal shown, including its edibility and culinary information.

Please provide your response in the following JSON format:
{
  "speciesName": "Common name of the fish",
  "scientificName": "Scientific name (Genus species)",
  "confidence": 0.85,
  "habitat": "Description of typical habitat",
  "size": "Typical size range",
  "facts": "Interesting fact about this species",
  "isEdible": true,
  "edibilityReason": "Why this fish is edible/not edible, including safety considerations",
  "cookingMethods": "Popular cooking methods if edible, or safety warnings if not",
  "alternatives": [
    {
      "speciesName": "Alternative 1 common name",
      "scientificName": "Alternative 1 scientific name", 
      "confidence": 0.70
    },
    {
      "speciesName": "Alternative 2 common name",
      "scientificName": "Alternative 2 scientific name",
      "confidence": 0.65
    }
  ]
}

IMPORTANT EDIBILITY GUIDELINES:
- If the fish is commonly consumed as food, set isEdible to true
- If the fish is toxic, poisonous, or dangerous to eat, set isEdible to false
- Consider mercury levels, parasites, and preparation requirements
- Include specific cooking methods for edible fish (grilling, frying, steaming, etc.)
- For non-edible fish, explain the specific reasons (toxicity, parasites, legal protection, etc.)
- Be very careful with species that may be confused with toxic varieties

If you cannot identify the fish with confidence, still provide your best guess with a lower confidence score.
Focus on providing accurate marine biology and culinary safety information.
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('No response from Gemini API');
      }

      // Parse JSON response
      final jsonText = _extractJson(responseText);
      final data = _parseJsonResponse(jsonText);
