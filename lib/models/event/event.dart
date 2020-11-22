class Event {
  String eventID;
  String eventName;
  List user;
  String createdby;

  Event({
    this.eventID,
    this.eventName,
    this.user,
    this.createdby
  });

  factory Event.fromJson(Map<String, dynamic> item) {
    return Event(
      eventID: item['eventID'],
      eventName: item['eventName'],
      user: item['user'],
      createdby: item['createdby'],
    );
  }
}
