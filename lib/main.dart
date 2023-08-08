import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(TextToSpeechApp());
}

class TextToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: TextToSpeechScreen(),
    );
  }
}

class TextToSpeechScreen extends StatefulWidget {
  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  FlutterTts flutterTts = FlutterTts();
  String text = '';
  List<dynamic> languages = [];
  String selectedLanguage = 'en-US';
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(1.0);

    languages = await flutterTts.getLanguages;
    setState(() {});
  }

  Future<void> speakText() async {
    setState(() {
      isSpeaking = true;
    });

    await flutterTts.speak(text);

    setState(() {
      isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text-to-Speech App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (value) async {
                selectedLanguage = value!;
                await flutterTts.setLanguage(selectedLanguage);
                setState(() {});
              },
              items: languages.map<DropdownMenuItem<String>>((locale) {
                return DropdownMenuItem<String>(
                  value: locale,
                  child: Text(locale),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter text...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSpeaking ? null : speakText,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: isSpeaking
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Speak'),
            ),
            ElevatedButton(
              onPressed: () async {
                await flutterTts.stop();
                setState(() {
                  isSpeaking = false;
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}

