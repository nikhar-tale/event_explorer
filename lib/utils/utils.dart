import 'package:flutter/material.dart';

class Utils {
  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  // Function to get icon based on category name
  static IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'all':
        return Icons.category; // Default icon
      case 'music':
        return Icons.music_note;
      case 'business':
        return Icons.business_center;
      case 'sports':
        return Icons.sports_baseball_sharp;
      case 'workshops':
        return Icons.work; // Or any workshop-related icon
      default:
        return Icons.category; // Default icon
    }
  }
}
