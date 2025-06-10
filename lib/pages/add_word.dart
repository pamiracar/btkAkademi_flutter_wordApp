import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_word_app/models/word.dart';
import 'package:flutter_word_app/pages/word_list.dart';
import 'package:flutter_word_app/services/isar_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_word_app/pages/home_page.dart';

class AddWordScreen extends StatefulWidget {
  final IsarService isarService;
  final VoidCallback onSave;

  const AddWordScreen({
    super.key,
    required this.isarService,
    required this.onSave,
  });

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();
  final _storyController = TextEditingController();
  String _selectedWordType = "Noun";
  bool _isLearned = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  List<String> wordType = [
    "Noun",
    "Adjective",
    "Verb",
    "Adverb",
    "Phrasal Verb",
    "Idiom",
  ];

  @override
  void dispose() {
    super.dispose();
    _englishController.dispose();
    _turkishController.dispose();
    _storyController.dispose();
  }

  Future<void> _resimSec() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _saveWord() async {
    if (_formKey.currentState!.validate()) {
      var _englishWord = _englishController.text;
      var _turkishWord = _turkishController.text;
      var _story = _storyController.text;

      await widget.isarService.saveWord(
        Word(
          englishWord: _englishWord,
          turkishWord: _turkishWord,
          wordType: _selectedWordType,
          story: _story,
          imageBytes: _imageFile != null
              ? await _imageFile!.readAsBytes()
              : null,
        ),
      );
      widget.onSave();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter english word";
                }
                return null;
              },
              controller: _englishController,
              decoration: InputDecoration(
                labelText: "English Word",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedWordType,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Word Type",
              ),
              items: wordType.map((e) {
                return DropdownMenuItem<String>(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWordType = value!;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter turkish word";
                }
                return null;
              },
              controller: _turkishController,
              decoration: InputDecoration(
                labelText: "Turkish Word",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                labelText: "Word Story",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text("Learned"),
                    value: _isLearned,
                    onChanged: (value) {
                      setState(() {
                        _isLearned = !_isLearned;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _resimSec,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: Center(child: Text("Add Image")),
                      icon: Icon(Icons.image),
                    ),
                    SizedBox(height: 10),
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveWord,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Save Word"),
            ),
          ],
        ),
      ),
    );
  }
}
