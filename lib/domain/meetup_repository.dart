import 'package:events_app/data/models/model.dart';

abstract class MeetupRepository {
  Future<List<Meetup>> getMeetups();
  Future<List<Meetup>> getFilteredMeetups(Map<String, List<String>> filters);
}