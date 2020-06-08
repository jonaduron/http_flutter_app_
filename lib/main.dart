import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import './views/noteList.dart';
import './services/notes_service.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NotesService());
}
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteList(),
    );
  }
}

