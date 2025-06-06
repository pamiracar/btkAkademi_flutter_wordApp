
import 'package:flutter/material.dart';
import 'package:flutter_word_app/pages/word_list.dart';
import 'package:flutter_word_app/services/isar_services.dart';

class HomePage extends StatefulWidget {
  final IsarService isarService;
  const HomePage({super.key, required this.isarService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Widget> getScreens(){
    return [
      WordList(isarService: widget.isarService,),
      Center(child: Text("Kelime Ekleme Formu"),),
    ];
  }

  int _selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelimelerim"),),
      body: getScreens()[_selectedScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedScreen,
        destinations: [
          NavigationDestination(icon: Icon(Icons.list_alt), label: "Kelimeler"),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: "Ekle")
        ],
        onDestinationSelected: (value) {
          setState(() {
            _selectedScreen = value;
          });
        },
      )
    );

  }
}
