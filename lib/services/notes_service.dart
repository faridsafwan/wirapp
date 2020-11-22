import 'dart:convert';

import 'package:wiprapp/models/api_response.dart';
import 'package:wiprapp/models/note/note.dart';
import 'package:wiprapp/models/note/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:wiprapp/models/note/notes_insert.dart';

class NotesService {
  static const API = 'https://wipr.smartcp.app';
  static const headers = {
    'apiKey': 'sasasas',
    'Content-Type': "application/json"
  };

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occurred'));

    // return [
    //   new NoteForListing(
    //       noteID: "1",
    //       createDateTime: DateTime.now(),
    //       latestEditDateTime: DateTime.now(),
    //       noteTitle: "Note 1"),
    //   new NoteForListing(
    //       noteID: "2",
    //       createDateTime: DateTime.now(),
    //       latestEditDateTime: DateTime.now(),
    //       noteTitle: "Note 2"),
    //   new NoteForListing(
    //       noteID: "3",
    //       createDateTime: DateTime.now(),
    //       latestEditDateTime: DateTime.now(),
    //       noteTitle: "Note 3")
    // ];
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(API + '/notes/',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item) {
    return http
        .put(API + '/notes/' + noteID,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http.delete(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }
}
