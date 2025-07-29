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
        if (data == null) {
        throw Exception('Failed to parse response');
      }

      // Create FishIdentification object
      final alternatives = (data['alternatives'] as List<dynamic>?)
          ?.map((alt) => AlternativeFish(
                speciesName: alt['speciesName'] ?? 'Unknown',
                scientificName: alt['scientificName'] ?? 'Unknown',
                confidence: (alt['confidence'] ?? 0.0).toDouble(),
              ))
          .toList() ?? [];

      return FishIdentification(
        speciesName: data['speciesName'] ?? 'Unknown Fish',
        scientificName: data['scientificName'] ?? 'Unknown species',
        confidence: (data['confidence'] ?? 0.0).toDouble(),
        imagePath: imagePath,
        habitat: data['habitat'],
        size: data['size'],
        facts: data['facts'],
        alternatives: alternatives,
        isEdible: data['isEdible'] ?? false,
        edibilityReason: data['edibilityReason'],
        cookingMethods: data['cookingMethods'],
      );
      
    } catch (e) {
      print('Error identifying fish: $e');
      // Return a fallback identification
      return _createFallbackIdentification(imagePath);
    }
  }

  String _extractJson(String text) {
    // Try to extract JSON from the response
    final jsonStart = text.indexOf('{');
    final jsonEnd = text.lastIndexOf('}');
    
    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      return text.substring(jsonStart, jsonEnd + 1);
    }
    
    return text;
  }

  Map<String, dynamic>? _parseJsonResponse(String jsonText) {
    try {
      // Clean up the JSON text
      final cleanJson = jsonText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      
      return {
        'speciesName': _extractValue(cleanJson, 'speciesName') ?? 'Unknown Fish',
        'scientificName': _extractValue(cleanJson, 'scientificName') ?? 'Unknown species',
        'confidence': double.tryParse(_extractValue(cleanJson, 'confidence') ?? '0.0') ?? 0.0,
        'habitat': _extractValue(cleanJson, 'habitat'),
        'size': _extractValue(cleanJson, 'size'),
        'facts': _extractValue(cleanJson, 'facts'),
        'isEdible': _extractValue(cleanJson, 'isEdible')?.toLowerCase() == 'true',
        'edibilityReason': _extractValue(cleanJson, 'edibilityReason'),
        'cookingMethods': _extractValue(cleanJson, 'cookingMethods'),
        'alternatives': [],
      };
    } catch (e) {
      print('Error parsing JSON: $e');
      return null;
    }
  }

  String? _extractValue(String json, String key) {
    final pattern = RegExp('"$key"\\s*:\\s*"([^"]*)"');
    final match = pattern.firstMatch(json);
    return match?.group(1);
  }

  FishIdentification _createFallbackIdentification(String imagePath) {
    return FishIdentification(
      speciesName: 'Unidentified Fish',
      scientificName: 'Species unknown',
      confidence: 0.1,
      imagePath: imagePath,
      habitat: 'Unable to determine habitat',
      size: 'Size unknown',
      facts: 'This appears to be an aquatic creature, but we could not identify the specific species.',
      isEdible: false,
      edibilityReason: 'Edibility cannot be determined without proper identification. Do not consume unknown fish species.',
      cookingMethods: 'SAFETY WARNING: Never consume unidentified fish as they may be toxic or dangerous.',
      alternatives: [
        AlternativeFish(
          speciesName: 'Generic Fish',
          scientificName: 'Pisces sp.',
          confidence: 0.05,
        ),
      ],
    );
  }
}
