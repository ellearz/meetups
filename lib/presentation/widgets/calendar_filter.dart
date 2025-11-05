import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class CalendarFilter extends StatefulWidget {
  final List<DateTime> selectedDates;
  final Function(List<DateTime>) onDatesSelected;
  final VoidCallback onClose;

  const CalendarFilter({
    Key? key,
    required this.selectedDates,
    required this.onDatesSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  _CalendarFilterState createState() => _CalendarFilterState();
}

class _CalendarFilterState extends State<CalendarFilter> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDates = [];
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
    _selectedDates = List<DateTime>.from(widget.selectedDates);
    _showCalendar = _selectedDates.isNotEmpty;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      
      if (_selectedDates.any((date) => _isSameDay(date, selectedDay))) {
        _selectedDates.removeWhere((date) => _isSameDay(date, selectedDay));
      } else {
        _selectedDates.add(selectedDay);
      }
    });

    widget.onDatesSelected(_selectedDates);
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _clearSelection() {
    setState(() {
      _selectedDates.clear();
      _showCalendar = false;
    });
    widget.onDatesSelected(_selectedDates);
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
      if (!_showCalendar) {
        widget.onDatesSelected(_selectedDates);
      }
    });
  }

  void _selectToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDates = [today];
      _showCalendar = false; 
    });
    widget.onDatesSelected(_selectedDates);
  }

  void _selectTomorrow() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    setState(() {
      _selectedDates = [tomorrow];
      _showCalendar = false; 
    });
    widget.onDatesSelected(_selectedDates);
  }

  void _selectThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final dates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    
    setState(() {
      _selectedDates = dates;
      _showCalendar = false;
    });
    widget.onDatesSelected(_selectedDates);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickButton('Today', _selectToday),
              SizedBox(width: 8),
              _buildQuickButton('Tomorrow', _selectTomorrow),
              SizedBox(width: 8),
              _buildQuickButton('This Week', _selectThisWeek),
              SizedBox(width: 8),
              _buildQuickButton(
                _showCalendar ? 'Hide Calendar' : 'Custom Dates', 
                _toggleCalendar
              ),
              if (_selectedDates.isNotEmpty) ...[
                SizedBox(width: 8),
                _buildQuickButton('Clear', _clearSelection),
              ],
            ],
          ),
        ),
        SizedBox(height: 16),
        
    
        if (_selectedDates.isNotEmpty) 
          _buildSelectedDates(),
        
    
        if (_showCalendar) 
          _buildCalendar(),
      ],
    );
  }

  Widget _buildSelectedDates() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Selected Dates:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              Spacer(),
              Text(
                '${_selectedDates.length}',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _selectedDates.map((date) => Chip(
              label: Text(DateFormat('MMM dd, yyyy').format(date)),
              backgroundColor: Colors.blue.shade100,
              deleteIcon: Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() {
                  _selectedDates.remove(date);
                });
                widget.onDatesSelected(_selectedDates);
              },
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => _selectedDates.any((selectedDate) => _isSameDay(selectedDate, day)),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          formatButtonTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}