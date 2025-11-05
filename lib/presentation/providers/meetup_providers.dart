import 'package:events_app/data/models/model.dart';
import 'package:events_app/data/repositories/meetup_repository_impl.dart';
import 'package:events_app/domain/meetup_repository.dart';
import 'package:flutter/foundation.dart';

class MeetupProvider with ChangeNotifier {
  final MeetupRepository repository;
  
  List<Meetup> _meetups = [];
  List<Meetup> _filteredMeetups = [];
  bool _isLoading = false;
  bool _hasLoaded = false;

  Map<String, List<String>> _activeFilters = {
    'date': [],
    'location': [],
    'sport': [],
    'difficulty': [],
  };

  MeetupProvider() : repository = MeetupRepositoryImpl();

  List<Meetup> get meetups => _filteredMeetups;
  Map<String, List<String>> get activeFilters => _activeFilters;
  bool get isLoading => _isLoading;
  
  bool get hasActiveFilters => _activeFilters.entries.any(
        (filter) => filter.value.isNotEmpty,
      );


  Future<void> loadMeetups() async {
    if (_hasLoaded) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _meetups = await repository.getMeetups();
      _filteredMeetups = _meetups;
      _hasLoaded = true;
    } catch (e) {
   
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyFilters(Map<String, List<String>> newFilters) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _activeFilters = newFilters;
      
      await Future.delayed(Duration(milliseconds: 300));
      
      _filteredMeetups = await repository.getFilteredMeetups(newFilters);
    } catch (e) {
     } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFilter(String category, String value) {
    final newFilters = Map<String, List<String>>.from(_activeFilters);
    
    if (newFilters[category]!.contains(value)) {
   
      newFilters[category]!.remove(value);
    } else {
  
      newFilters[category]!.add(value);
    }
    
    applyFilters(newFilters);
  }

  void clearAllFilters() {
    _activeFilters = {
      'date': [],
      'location': [],
      'sport': [],
      'difficulty': [],
    };
    _filteredMeetups = _meetups;
    notifyListeners();
  }

  void clearCategoryFilters(String category) {
    final newFilters = Map<String, List<String>>.from(_activeFilters);
    newFilters[category] = [];
    applyFilters(newFilters);
  }
}