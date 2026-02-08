import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://it.e-tech.ac.th/checkstudent/product.json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }

  }
}
