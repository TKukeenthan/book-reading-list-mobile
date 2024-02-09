import 'package:book_reading_list/data/config.dart';
import 'package:flutter/foundation.dart';

import '../../model/book_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppService {
// fetch book
  static Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        print(response.body);
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

// create book
  static Future<void> postBook(Book book) async {
    Map<String, dynamic> requestBody = book.toJson();

    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Book created successfully');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to create book. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error while posting book: $error');
      }
    }
  }

// delete book
  static Future<void> deleteBook(Book book) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/${book.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        if (kDebugMode) {
          print('Book deleted successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to delete book. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error while deleting book: $error');
      }
    }
  }

// edit book
  static Future<bool> editBook(Book book) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/${book.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(book.toJson()),
      );
      print(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Book edited successfully');
        return true;
      } else {
        print('Failed to edit book. Status code: ${response.statusCode}');

        print('Response body: ${response.body}');

        return false;
      }
    } catch (error) {
      print('Error while editing book: $error');

      return false;
    }
  }
}
