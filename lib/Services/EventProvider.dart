import 'package:flutter/material.dart';
import 'package:web_event/Services/database_services.dart';
import 'package:web_event/models/EventModel.dart';

class Eventprovider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<EventModel> _events = [];
  EventModel? _selectedEvent;

  List<EventModel> get events => _events;
  EventModel? get selectedEvent => _selectedEvent;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _value = "Pending";

  String get value => _value;

  void fetchEvents(String value) {
    _databaseService.getPendingEvents(value).listen((event) {
      _events = event;
      notifyListeners();
    });
  }

  void selectEvent(EventModel event) {
    _selectedEvent = event;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> updateField(
      {required String collectionPath,
      required String docId,
      required String field,
      required dynamic newValue}) async {
    setLoading(true);
    try {
      await _databaseService.UpdateEvent(
          collectionPath: collectionPath,
          docId: docId,
          field: field,
          newValue: newValue);
    } catch (e) {
      print(e.toString());
    } finally {
      setLoading(false);
    }
  }

  void updateValue(String newValue) {
    _value = newValue;
    notifyListeners();
  }

  Future<void> fetchLable(String value) async {
    _value = value;
    notifyListeners();
    fetchEvents(value);
  }
}
