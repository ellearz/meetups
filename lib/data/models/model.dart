class Meetup {
  final String id;
  final String title;
  final String time;
  final String location;
  final String sportType;
  final String difficulty;
  final int participants;
  final bool isRecurring;
  final DateTime date; 

  Meetup({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.sportType,
    required this.difficulty,
    required this.participants,
    required this.isRecurring,
    required this.date, 
  });

  factory Meetup.fromJson(Map<String, dynamic> json) {
    return Meetup(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      sportType: json['sportType'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginner',
      participants: json['participants'] ?? 0,
      isRecurring: json['isRecurring'] ?? false,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}