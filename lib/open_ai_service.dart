import 'dart:convert';

import 'package:flutter_ai_app/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try{
      print("called");
        final res = await http.post(Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$google_gemini_key'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents":[{
            "parts": [
            {"text" : "Does this message wants to generate any AI picture, image, art or anything similar $prompt?. Simply answer with either Yes or No"}
          ]}]
        }));
        print(res.body);
        if (res.statusCode == 200) {
          String content = res.body;
          print("_--------------------------_");
          print(content[0]);
        }
        return "ai";
    }catch(e){
        return e.toString();
    }}

  Future<String> chatGPTAPI(String prompt) async {
    return "CHATGPT";
  }

  Future<String> dallEAPI(String prompt) async {
    return "DALL-E";
  }
}