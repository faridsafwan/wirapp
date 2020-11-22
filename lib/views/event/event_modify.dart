import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiprapp/models/event/event.dart';
import 'package:wiprapp/models/event/events_insert.dart';
import 'package:wiprapp/services/event_service.dart';

class EventModify extends StatefulWidget {
  final String eventID;
  EventModify({this.eventID});

  @override
  _EventModifyState createState() => _EventModifyState();
}

class _EventModifyState extends State<EventModify> {
  bool get isEditing => widget.eventID != null;

  EventsService get eventsService => GetIt.I<EventsService>();

  String errorMessage;
  Event event;
  String name = '';

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
    final String userId = prefs.getString('username');

    if (userId != null) {
      setState(() {
        name = userId;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit event' : 'Create event')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                      decoration: InputDecoration(hintText: 'Event Name'),
                      controller: _nameController),
                  Container(height: 8),
                  // TextField(
                  //   decoration: InputDecoration(hintText: 'Note Content'),
                  //   controller: _contentController,
                  // ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });
                            final event = EventManipulation(
                              eventName: _nameController.text,
                            );
                            final result = await eventsService.updateEvent(
                                widget.eventID, event);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? "An error occured")
                                : 'Your event was updated';

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
                          } else {
                            // Navigator.of(context).pop();
                            setState(() {
                              _isLoading = true;
                            });
                            final event = EventManipulation(
                                eventName: _nameController.text,
                                createdby: name);
                            final result =
                                await eventsService.createEvent(event);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? "An error occured")
                                : 'Your event was created';

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
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
      ),
    );
  }
}
