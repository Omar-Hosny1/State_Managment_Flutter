import 'package:flutter/foundation.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-app-b200e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');

    try {
      // http package return an error when Get of Post Only
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
