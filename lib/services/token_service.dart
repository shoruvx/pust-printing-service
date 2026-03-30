import 'package:intl/intl.dart';

class TokenService {
  // Track last generated token timestamp
  DateTime? _lastGenerated;

  /// Generates a new token in P-XXX format with daily reset.
  String generateToken() {
    // Reset if it's a new day
    DateTime now = DateTime.now();
    if (_lastGenerated == null ||  
        now.year != _lastGenerated!.year ||  
        now.month != _lastGenerated!.month ||  
        now.day != _lastGenerated!.day) {
      // Start a new day
      _lastGenerated = now;
    }

    // P-XXX format, Xs are incrementing numbers
    String prefix = 'P-';
    String tokenNumber = _getTokenNumber();
    return prefix + tokenNumber;
  }

  /// Generates the next token number, increments based on previous tokens.
  String _getTokenNumber() {
    // In a real implementation, this should track the count persistently.
    // For illustration, just using a random number for demo purpose.
    int number = DateTime.now().millisecondsSinceEpoch % 1000;
    return number.toString().padLeft(3, '0');  // Ensure it's always three digits
  }
}