import 'package:flutter/material.dart';

class GlobalUIViewModel with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void loadState(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  @override
  String toString() {
    return 'GlobalUIViewModel(isLoading: $_isLoading)';
  }
}
