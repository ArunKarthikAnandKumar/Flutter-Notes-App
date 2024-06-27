import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes_app/constants/routes.dart';
import 'package:mynotes_app/main.dart';
import 'package:mynotes_app/services/auth/auth_service.dart';
import 'package:mynotes_app/services/auth/bloc/auth_event.dart';
import 'package:mynotes_app/services/cloud/cloud_note.dart';
import 'package:mynotes_app/views/notes/notes_list_view.dart';
import 'dart:developer' as devtools show log;
import '../../enums/menu_action.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/cloud/firebase_cloude_storage.dart';
import '../../utilites/dialog/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Ui'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CreateOrUpdateRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  bool shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                    devtools.log('User chose to log out');
                  } else {
                    devtools.log('User canceled logout');
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data!;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      CreateOrUpdateRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
