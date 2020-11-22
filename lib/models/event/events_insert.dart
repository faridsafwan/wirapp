class EventManipulation {
  String eventName;
  String createdby;
  String user;
  EventManipulation({
    this.eventName,
    this.createdby,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {"eventName": eventName, "createdby": createdby, "user": user};
  }
}
