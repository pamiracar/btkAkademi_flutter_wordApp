
import 'package:flutter/material.dart';
import 'package:flutter_word_app/models/word.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
class IsarService{

  late Isar isar;


  Future<void> init() async {
    try{
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([WordSchema], directory: directory.path);
      debugPrint("Isar başlatıldı ${directory.path}");
    }catch(e){
      debugPrint("Isar init olurken hata $e");
    }
  }

  Future<void> saveWord(Word word) async{
    try{
      await isar.writeTxn(() async {
        final id = await isar.words.put(word);
        debugPrint("Yeni kelime olan ${word.englishWord} $id idysi ile eklendi");
      },);
    }catch(e){
      debugPrint("Kelime eklenirken hata çıktı $e");
    }
  }

  Future<List<Word>> getAllWords() async{
    try{
      final words = await isar.words.where().findAll();
      return words;

    }catch(e){
      debugPrint("Tüm kelimeler getirilirken hata $e");
      return [];
    }
  }

  Future<void> deleteWord(int id) async{
    try{
      await isar.writeTxn(() async {
        final result = await isar.words.delete(id);
        debugPrint("id değeri $id olan kelime silindi");
      },);
    }catch(e){
      debugPrint("Silinirken hata çıktı $e");
    }
  }

  Future<void> updateWord(Word word) async{
    try{
      await isar.writeTxn(() async {
        final id = await isar.words.put(word);
        debugPrint("Yeni kelime olan ${word.englishWord} $id idysi ile güncellendi");
      },);
    }catch(e){
      debugPrint("Kelime güncellenirken hata çıktı $e");

    }
  }

  Future<void> toogleWordLearned(int id) async{
    try{
      await isar.writeTxn(() async {
        final word = await isar.words.get(id);
        if(word != null){
          word.isLearned = !word.isLearned;
          await isar.words.put(word);
          debugPrint("Kelime güncellendi");
        }else{
          debugPrint("Kelime bulunamadı");
        }


      },);
    }catch(e){
    debugPrint("Kelime güncellenirken hata çıktı $e");
    }
  }
}