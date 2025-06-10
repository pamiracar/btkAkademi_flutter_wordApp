import 'package:flutter/material.dart';
import 'package:flutter_word_app/pages/add_word.dart';
import 'package:flutter_word_app/pages/word_list.dart';
import 'package:flutter_word_app/services/isar_services.dart';

import '../models/word.dart';

class HomePage extends StatefulWidget {
  final IsarService isarService;
  const HomePage({super.key, required this.isarService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedScreen = 0;
  Word? _wordToEdit;

  void _editWord(Word guncellenecekKelime) {
    setState(() {
      selectedScreen = 1;
      _wordToEdit = guncellenecekKelime;
    });
  }

  List<Widget> getScreens() {
    return [
      WordList(isarService: widget.isarService, onEditWord: _editWord),
      AddWordScreen(
        isarService: widget.isarService,
        wordToEdit: _wordToEdit,
        onSave: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Kelime kaydedildi")));
          setState(() {
            selectedScreen = 0;
            _wordToEdit = null;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Words")),
      body: getScreens()[selectedScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedScreen,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt),
            label: "Words",
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            label: _wordToEdit == null ? "Add" : "Update",
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            selectedScreen = value;
            if(selectedScreen == 0)
              _wordToEdit = null;
          });
        },
      ),
    );
  }
}
