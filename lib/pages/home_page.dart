
import 'package:flutter/material.dart';
import 'package:flutter_word_app/pages/add_word.dart';
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
      AddWordScreen(isarService: widget.isarService,onSave:() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kelime kaydedildi")),
        );
        setState(() {
          selectedScreen = 0;
        });
      },),
    ];
  }

  int selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Words"),),
      body: getScreens()[selectedScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedScreen,
        destinations: [
          NavigationDestination(icon: Icon(Icons.list_alt), label: "Words"),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: "Add")
        ],
        onDestinationSelected: (value) {
          setState(() {
            selectedScreen = value;
          });
        },
      )
    );

  }
}
