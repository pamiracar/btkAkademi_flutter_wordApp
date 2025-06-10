import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_word_app/models/word.dart';
import 'package:flutter_word_app/services/isar_services.dart';
import 'package:isar/isar.dart';

class WordList extends StatefulWidget {
  final IsarService isarService;
  const WordList({super.key, required this.isarService});

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  late Future<List<Word>> _getAllWords;
  List<Word> _kelimeler = [];

  @override
  void initState() {
    super.initState();
    _getAllWords = _getWordsFromDB();
  }

  Future<List<Word>> _getWordsFromDB() async {
    return await widget.isarService.getAllWords();
  }

  void _refreshWords() {
    setState(() {
      _getAllWords = _getWordsFromDB();
    });
  }

  void _toggleUpdateWord(Word oAnkiKelime) async {
    await widget.isarService.toogleWordLearned(oAnkiKelime.id);
    setState(() {
      final index = _kelimeler.indexWhere(
        (element) => element.id == oAnkiKelime.id,
      );
      var degistirilecekKelime = _kelimeler[index];
      degistirilecekKelime.isLearned = !degistirilecekKelime.isLearned;
      _kelimeler[index] = degistirilecekKelime;
    });
  }

  void _deleteWord(Word oAnkiKelimed) async {
    await widget.isarService.deleteWord(oAnkiKelimed.id);
    _kelimeler.removeWhere((element) => element.id == oAnkiKelimed.id,);
    debugPrint("liste boyutu ${_kelimeler.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(),
        Expanded(
          child: FutureBuilder<List<Word>>(
            future: _getAllWords,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Hata var: ${snapshot.error.toString()}"),
                );
              }
              if (snapshot.hasData) {
                return snapshot.data?.length == 0
                    ? Center(child: Text("Please add words"))
                    : _buildListView(snapshot.data!);
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  _buildListView(List<Word> data) {
    _kelimeler = data.reversed.toList();
    debugPrint("Kelimeler liste uzunluğu ${_kelimeler.length}");
    return ListView.builder(
      itemBuilder: (context, index) {
        var oAnkiKelime = _kelimeler[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _deleteWord(oAnkiKelime),
          confirmDismiss: (direction) async {
            return await showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Kelime Sil"),
                content: Text("${oAnkiKelime.englishWord} kelimesini silmek istediğinize emin misiniz?"),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop(false);
                  }, child: Text("Cancel")),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop(true);
                  }, child: Text("Delete"))
                ],
              );
            },);
          },
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_forever_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(oAnkiKelime.englishWord),
                      subtitle: Text(oAnkiKelime.turkishWord),
                      leading: Chip(label: Text(oAnkiKelime.wordType)),
                      trailing: Switch(
                        value: oAnkiKelime.isLearned,
                        onChanged: (value) => _toggleUpdateWord(oAnkiKelime),
                      ),
                    ),
                    if (oAnkiKelime.story != null &&
                        oAnkiKelime.story!.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb),
                                  SizedBox(width: 8),
                                  Text("Reminder Note"),
                                ],
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  oAnkiKelime.story ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (oAnkiKelime.imageBytes != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                          Uint8List.fromList(oAnkiKelime.imageBytes!),
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: data.length,
    );
  }


}
