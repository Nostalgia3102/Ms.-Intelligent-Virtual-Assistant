import 'dart:convert';

import 'secrets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GoogleGeminiService {
  final List<Map<String, String>> messages = [];

// Access your API key as an environment variable (see "Set up your API key" above)
  final apiKey = google_gemini_key;


  Future<String> isArtPromptAPI(String prompt) async {
    print("started working ");
    try{
      const apiKey = google_gemini_key;
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text("Does this message wants to generate any AI picture, image, art or anything similar ?\n message: $prompt . \n Simply answer with either Yes or No")];
      final response = await model.generateContent(content);
      // print(response);
      // print(response.text);
      // String content = jsonDecode(response.text);

      String res = response.text.toString();
      switch(res){
        case 'YES':
        case 'yes':
        case 'Yes':
        case 'Yes.':
        case 'yes.':
          final result = await dallEAPI(prompt);
          return result;
        default:
          final result = await chatGPTAPI(prompt);
          return result;
      }
    }catch(e){
    return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    print("started working - chatGPT Mode ");
    try{
      const apiKey = google_gemini_key;
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      print("The prompt is: $prompt");
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      // print(response);
      // print(response.text);
      // String content = jsonDecode(response.text);

      String res = response.text.toString();
      print(res);
      return res;
    }catch(e){
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    print("started working - DALL-E Mode ");
    try{
      const apiKey = google_gemini_key;
      // For text-only input, use the gemini-pro model
      final model = GenerativeModel(model: 'gemini-1.5-pro-latest', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      print(response);
      final List<dynamic> contentList = response.candidates;
      if (contentList.isNotEmpty) {
        final imageUrl = contentList[0]['imageUrl'] as String;
        // Use imageUrl to display the image
        return imageUrl;
      } else {
        // Handle case where no content is generated
        return "No content generated";
      }
    }catch(e){
      return e.toString();
    }
  }

}