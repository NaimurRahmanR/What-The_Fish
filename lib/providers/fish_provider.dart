import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/fish_identification.dart';
import '../services/gemini_service.dart';

class FishProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  Box<FishIdentification>? _historyBox;
  
  List<FishIdentification> _identifications = [];
  bool _isLoading = false;
  String? _error;

  List<FishIdentification> get identifications => _identifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeDatabase() async {
    try {
      _historyBox = await Hive.openBox<FishIdentification>('fish_history');
      await loadHistory();
    } catch (e) {
      _error = 'Failed to initialize database: $e';
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    try {
      if (_historyBox != null) {
        _identifications = _historyBox!.values.toList()
          ..sort((a, b) => b.identifiedAt.compareTo(a.identifiedAt));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load history: $e';
      notifyListeners();
    }
  }

  Future<FishIdentification?> identifyFish(String imagePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final identification = await _geminiService.identifyFish(imagePath);
      
      if (identification != null) {
        // Save to database
        await _historyBox?.add(identification);
        
        // Add to local list
        _identifications.insert(0, identification);
      }
      
      _isLoading = false;
      notifyListeners();
      
      return identification;
    } catch (e) {
      _error = 'Failed to identify fish: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteIdentification(String id) async {
    try {
      // Find and delete from Hive
      final identification = _identifications.firstWhere((item) => item.id == id);
      await identification.delete();
      
      // Remove from local list
      _identifications.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete identification: $e';
      notifyListeners();
    }
  }

  List<FishIdentification> filterByConfidence(double minConfidence) {
    return _identifications
        .where((identification) => identification.confidence >= minConfidence)
        .toList();
  }

  List<FishIdentification> filterByDateRange(DateTime start, DateTime end) {
    return _identifications
        .where((identification) => 
            identification.identifiedAt.isAfter(start) && 
            identification.identifiedAt.isBefore(end))
        .toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

