import 'dart:convert';

import 'package:wiprapp/models/api_response.dart';
import 'package:wiprapp/models/event/event.dart';
import 'package:http/http.dart' as http;
import 'package:wiprapp/models/event/events_insert.dart';

class EventsService {
  static const API = 'https://wipr.smartcp.app';
  static const headers = {'Content-Type': "application/json"};

  Future<APIResponse<List<Event>>> getEventsList() {
    return http.get(API + '/event', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final event = <Event>[];
        for (var item in jsonData) {
          event.add(Event.fromJson(item));
        }
        return APIResponse<List<Event>>(data: event);
      } else if (data.statusCode == 404) {
        return APIResponse<List<Event>>(error: true,errorMessage: "No event created");
      }

      return APIResponse<List<Event>>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((_) => APIResponse<List<Event>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Event>> getEvent(String eventID) {
    return http.get(API + '/event/' + eventID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Event>(data: Event.fromJson(jsonData));
      }
      return APIResponse<Event>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<Event>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> createEvent(EventManipulation item) {
    return http
        .post(API + '/event/',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> registerEvent(String eventID,EventManipulation item) {
    return http
        .post(API + '/event/register/'+ eventID,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
          final jsonData = json.decode(data.body);
      var message = jsonData['message'];
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: message);
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> updateEvent(String eventID, EventManipulation item) {
    return http
        .put(API + '/event/' + eventID,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> deleteEvent(String eventID) {
    return http
        .delete(API + '/event/' + eventID, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }
}
