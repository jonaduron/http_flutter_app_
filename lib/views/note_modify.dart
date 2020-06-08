import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todoApp/models/note_manipulation.dart';

import './../services/notes_service.dart';
import './../models/node.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  
  bool get _isEditing => widget.noteID != null;  

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage; 
  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    if (_isEditing) {
      setState(() {
        _isLoading = true;
      });

      notesService.getNote(widget.noteID)
      .then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
          child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Note title'
              ),
            ),

            Container(height: 12),
            
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Note content'
              ),
            ),
            Container(height: 16),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  if(_isEditing) {
                    setState((){
                      _isLoading = true;
                    });

                    final note = NoteManipulation( noteTitle: _titleController.text, noteContent: _contentController.text);
                    final result = await notesService.updateNote(widget.noteID, note);

                    final title = 'Done!';
                    final text = result.error ? (result.errorMessage ?? 'An error occured') : 'You just updated a note';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]
                      )
                    ).then((data) {
                      if(result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    
                    setState((){
                      _isLoading = true;
                    });

                    final note = NoteManipulation( noteTitle: _titleController.text, noteContent: _contentController.text);
                    final result = await notesService.createNote(note);

                    final title = 'Done!';
                    final text = result.error ? (result.errorMessage ?? 'An error occured') : 'You just created a note';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]
                      )
                    ).then((data) {
                      if(result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}