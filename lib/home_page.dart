import 'package:flutter/material.dart';
import 'package:flutter_ai_app/feature_box.dart';
import 'package:flutter_ai_app/google_gemini_service.dart';
import 'package:flutter_ai_app/open_ai_service.dart';
import 'package:flutter_ai_app/pallete.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterTts = FlutterTts();
  bool speechEnabled = false;
  String lastWords = '';
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  final GoogleGeminiService googleGeminiService = GoogleGeminiService();

  String? generatedContent;
  String? generatedImageURL;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            // await openAIService.isArtPromptAPI(lastWords);
            final speech = await googleGeminiService.isArtPromptAPI(lastWords);
            if (speech.contains("https")) {
              generatedImageURL = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedContent = speech;
              generatedImageURL = null;
              setState(() {});
              await systemSpeak(speech);
            }
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Ms. Intelligent", style: TextStyle(fontWeight: FontWeight.normal),),
        leading: const Icon(Icons.menu),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //Virtual Assistant Picture
                profileWidget(),

                //Chat Bubble :
                chatBubbleWidget(),

                SizedBox.fromSize(size: const Size.fromHeight(20)),

                //suggestions list :
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 0),
                  alignment: Alignment.centerLeft,
                  child: const Text("Here are a few features", style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                ),

                //Features List :
                const Column(
                  children: [
                    FeatureBox(color: Pallete.firstSuggestionBoxColor,
                      headerText: "Chat GPT",
                      descriptionText: "A smarter way to stay organized and informed with Chat GPT",),
                    FeatureBox(color: Pallete.secondSuggestionBoxColor,
                      headerText: "DALL E ",
                      descriptionText: "Get inspired and stay creative with your personal assistant powered by Dall-E",),
                    FeatureBox(color: Pallete.thirdSuggestionBoxColor,
                      headerText: "Smart Voice Assistant",
                      descriptionText: "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBubbleWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(
        top: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Pallete.borderColor,
        ),
        borderRadius: BorderRadius.circular(20).copyWith(
            topLeft: Radius.zero,
            bottomRight: Radius.zero
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(generatedContent == null
            ? "Hi, How can I help you ?"
            : generatedContent!, style: const TextStyle(
            color: Pallete.mainFontColor, fontSize: 25
        ),),
      ),
    );
  }


  Widget profileWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              color: Pallete.assistantCircleColor, shape: BoxShape.circle),
        ),
        Container(
          height: 123,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image:
              AssetImage("assets/image/virtualAssistant.png")
              )
          ),
        )
      ],
    );
  }
}
