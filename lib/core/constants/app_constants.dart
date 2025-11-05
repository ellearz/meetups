import 'package:flutter/material.dart';

class AppConstants {
  static const List<FilterOption> dateFilters = [
    FilterOption('Today', Icons.today),
    FilterOption('Tomorrow', Icons.today_outlined),
    FilterOption('This Week', Icons.calendar_view_week),
    FilterOption('Custom Dates', Icons.date_range),
  ];

  static const List<FilterOption> locationFilters = [
    FilterOption('Cologne', Icons.location_city),
    FilterOption('Berlin', Icons.location_city),
    FilterOption('Hamburg', Icons.location_city),
    FilterOption('Munich', Icons.location_city),
    FilterOption('Frankfurt', Icons.location_city),
  ];

  static const List<FilterOption> sportFilters = [
    FilterOption('Running', Icons.directions_run),
    FilterOption('Cycling', Icons.directions_bike),
    FilterOption('Swimming', Icons.pool),
    FilterOption('Yoga', Icons.self_improvement),
    FilterOption('Football', Icons.sports_soccer),
    FilterOption('Basketball', Icons.sports_basketball),
    FilterOption('Tennis', Icons.sports_tennis),
  ];

  static const List<FilterOption> difficultyFilters = [
    FilterOption('Beginner', Icons.arrow_upward),
    FilterOption('Intermediate', Icons.arrow_upward),
    FilterOption('Advanced', Icons.arrow_upward),
    FilterOption('All Levels', Icons.accessible),
  ];
}

class FilterOption {
  final String label;
  final IconData icon;

  const FilterOption(this.label, this.icon);
}