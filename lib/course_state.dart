// Praktikum Pemwob - Pertemuan 6
// Tahap 5: ChangeNotifier dan notifyListeners()
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066

import 'package:flutter/foundation.dart';

class CourseState extends ChangeNotifier {
  // Collection favorites yang dimiliki object ini.
  final Set<String> favorites = <String>{};

  bool isFavorite(String id) => favorites.contains(id);

  int get jumlahFavorite => favorites.length;
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  void clearFavorites() {
    if (favorites.isEmpty) return;
    favorites.clear();
    notifyListeners();
  }
}