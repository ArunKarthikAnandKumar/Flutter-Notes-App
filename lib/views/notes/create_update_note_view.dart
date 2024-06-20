import 'package:flutter/material.dart';
import 'package:mynotes_app/services/auth/auth_service.dart';
import 'package:mynotes_app/services/cloud/cloud_note.dart';
import 'package:mynotes_app/services/cloud/firebase_cloude_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilites/cannot_share_empty_notes_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  final CloudNote? note;

  const CreateUpdateNoteView({
    super.key,
    this.note,
  });

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
    createOrGetExistingNote();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<void> createOrGetExistingNote() async {
    final widgetNote = widget.note;
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _setupTextControllerListener();
      return;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userID = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userID);
    setState(() {
      _note = newNote;
    });
    _setupTextControllerListener();
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _note == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 18.0, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Start typing your notes...',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                ),
              ),
      ),
    );
  }
}
