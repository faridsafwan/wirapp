import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiprapp/models/api_response.dart';
import 'package:wiprapp/models/event/event.dart';
import 'package:wiprapp/services/event_service.dart';
import 'package:wiprapp/views/event/event_delete.dart';
import 'package:wiprapp/views/event/event_register.dart';
import 'package:wiprapp/views/login/login.dart';

class EventRegisterList extends StatefulWidget {
  @override
  _EventRegisterListState createState() => _EventRegisterListState();
}

class _EventRegisterListState extends State<EventRegisterList> {
  EventsService get service => GetIt.I<EventsService>();

  // List<NoteForListing> notes = [];
  APIResponse<List<Event>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    // notes = service.getNotesList();
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getEventsList();

    setState(() {
      _isLoading = false;
    });
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('userID', null);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List of Events'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                logout();
              },
            )
          ],
        ),
        body: Builder(builder: (_) {
          if (_isLoading) {
            return CircularProgressIndicator();
          }
          if (_apiResponse.error) {
            return Center(
              child: Text(_apiResponse.errorMessage),
            );
          }

          return ListView.separated(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].eventID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => EventDelete());
                    if (result) {
                      final deleteResult = await service
                          .deleteEvent(_apiResponse.data[index].eventID);

                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'The event was deleted successfully';
                      } else {
                        message =
                            deleteResult?.errorMessage ?? "An error occured";
                      }

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Done"),
                                content: Text(message),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'))
                                ],
                              ));

                      return deleteResult?.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse.data[index].eventName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        "Created by " + _apiResponse.data[index].createdby),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Text(
                            "${_apiResponse.data[index].user.length}"), // icon-1
                        Icon(Icons.people), // icon-2
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) => EventRegister(
                                  eventID: _apiResponse.data[index].eventID)))
                          .then((data) {
                        _fetchNotes();
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.green,
                  ),
              itemCount: _apiResponse.data.length);
        }));
  }
}
