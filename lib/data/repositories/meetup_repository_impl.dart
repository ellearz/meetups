

import 'package:events_app/data/models/model.dart';
import 'package:events_app/domain/meetup_repository.dart';


class MeetupRepositoryImpl implements MeetupRepository {
  @override
  Future<List<Meetup>> getMeetups() async {
    await Future.delayed(Duration(milliseconds: 100));
    
    return [
      Meetup(
        id: '1',
        title: 'W1NNAS RUN',
        time: '19:00',
        location: 'Händelstraße 27, 50674 Köln',
        sportType: 'Running',
        difficulty: 'Intermediate',
        participants: 15,
        isRecurring: false,
        date: DateTime(2025, 11, 3), 
      ),
      Meetup(
        id: '2',
        title: 'rappid. runs cologne - tuesdays',
        time: '18:30',
        location: 'Weyertal 13',
        sportType: 'Running',
        difficulty: 'Beginner',
        participants: 12,
        isRecurring: true,
        date: DateTime(2025, 11, 4),
      ),
      Meetup(
        id: '3',
        title: 'Weekend Cycling Group',
        time: '09:00',
        location: 'Rheinpark, Cologne',
        sportType: 'Cycling',
        difficulty: 'Intermediate',
        participants: 8,
        isRecurring: true,
        date: DateTime(2025, 11, 8), 
      ),
      Meetup(
        id: '4',
        title: 'Morning Yoga by the Rhine',
        time: '07:00',
        location: 'Rheinufer, Köln',
        sportType: 'Yoga',
        difficulty: 'Beginner',
        participants: 20,
        isRecurring: true,
        date: DateTime(2025, 11, 5),
      ),
      Meetup(
        id: '5',
        title: 'Advanced Swimming Training',
        time: '20:00',
        location: 'Sportpark Müngersdorf',
        sportType: 'Swimming',
        difficulty: 'Advanced',
        participants: 6,
        isRecurring: false,
        date: DateTime(2025, 11, 6), 
      ),
      Meetup(
        id: '6',
        title: 'Urban Football Session',
        time: '17:00',
        location: 'Stadion am Zoo',
        sportType: 'Football',
        difficulty: 'Intermediate',
        participants: 18,
        isRecurring: true,
        date: DateTime(2025, 11, 7),
      ),
    ];
  }

  @override
  Future<List<Meetup>> getFilteredMeetups(Map<String, List<String>> filters) async {
    final allMeetups = await getMeetups();

    if (filters.values.every((values) => values.isEmpty)) {
    
      return allMeetups;
    }
    
    final filtered = allMeetups.where((meetup) {
      bool matches = true;

      if (filters['date']!.isNotEmpty) {
        final matchesDate = _matchesDateFilter(meetup, filters['date']!);

        if (!matchesDate) matches = false;
      }
      
    
      if (filters['location']!.isNotEmpty) {
        final matchesLocation = _matchesLocationFilter(meetup, filters['location']!);

        if (!matchesLocation) matches = false;
      }
  
      if (filters['sport']!.isNotEmpty) {
        final matchesSport = _matchesSportFilter(meetup, filters['sport']!);

        if (!matchesSport) matches = false;
      }

      if (filters['difficulty']!.isNotEmpty) {
        final matchesDifficulty = _matchesDifficultyFilter(meetup, filters['difficulty']!);

        if (!matchesDifficulty) matches = false;
      }
      
      
      return matches;
    }).toList();
    

    
    return filtered;
  }
bool _matchesDateFilter(Meetup meetup, List<String> dateFilters) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(Duration(days: 1));
  
  for (final dateFilter in dateFilters) {
    switch (dateFilter) {
      case 'Today':
        if (_isSameDay(meetup.date, today)) return true;
        break;
      case 'Tomorrow':
        if (_isSameDay(meetup.date, tomorrow)) return true;
        break;
      case 'This Week':
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        if (meetup.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            meetup.date.isBefore(endOfWeek.add(Duration(days: 1)))) {
          return true;
        }
        break;
      case 'Custom Dates':
    
        return true;
      default:
        return true;
    }
  }
  return false;
}
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  bool _matchesLocationFilter(Meetup meetup, List<String> locationFilters) {
    for (final location in locationFilters) {
      if (meetup.location.toLowerCase().contains(location.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
  
  bool _matchesSportFilter(Meetup meetup, List<String> sportFilters) {
    return sportFilters.contains(meetup.sportType);
  }
  
  bool _matchesDifficultyFilter(Meetup meetup, List<String> difficultyFilters) {
    return difficultyFilters.contains(meetup.difficulty);
  }
}