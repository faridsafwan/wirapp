import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiprapp/models/event/event.dart';
import 'package:wiprapp/models/event/events_insert.dart';
import 'package:wiprapp/services/event_service.dart';

class EventRegister extends StatefulWidget {
  final String eventID;
  EventRegister({this.eventID});

  @override
  _EventRegisterState createState() => _EventRegisterState();
}

class _EventRegisterState extends State<EventRegister> {
  bool get isEditing => widget.eventID != null;

  EventsService get eventsService => GetIt.I<EventsService>();

  String errorMessage;
  Event event;
  String userID = '';

  TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    autoGetUsername();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      eventsService.getEvent(widget.eventID).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        event = response.data;
        _nameController.text = event.eventName;
      });
    }
  }

  void autoGetUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userID');

    if (userId != null) {
      setState(() {
        userID = userId;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register event')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(height: 100),
                  Text("Are you sure want to register this event?"),
                  Container(height: 100),
                  SizedBox(
                    height: 35,
                    child: Wrap(children: [
                      RaisedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final event = EventManipulation(user: userID);
                            final result = await eventsService.registerEvent(
                                widget.eventID, event);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? "An error occured")
                                : 'Your attendance has been recorded! Thank you for participating';

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: [
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    )).then((data) {
                              if (result.data) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor),
                      Container(width: 70),
                      RaisedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor),
                    ]),
                  )
                ],
              ),
      ),
    );
  }
}
