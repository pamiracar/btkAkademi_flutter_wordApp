import 'package:flutter/material.dart';
import 'package:flutter_word_app/models/word.dart';
import 'package:flutter_word_app/pages/home_page.dart';
import 'package:flutter_word_app/services/isar_services.dart';
import 'package:isar/isar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = IsarService();
  try{
    await isarService.init();
    //Word eklenecekKelime = Word(englishWord: "Dictionary", turkishWord: "Sözlük", wordType: "noun");
    //isarService.saveWord(eklenecekKelime);
    final words = await isarService.getAllWords();
    debugPrint(words.toString());
  }catch(e){
    debugPrint("Main.dart'da isar service başlatılamadı $e");
  }
  runApp(WordApp(isarService: isarService,));

}

class WordApp extends StatelessWidget {
  final IsarService isarService;
  const WordApp({super.key, required this.isarService});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: HomePage(isarService: isarService,),
    );
  }
}
