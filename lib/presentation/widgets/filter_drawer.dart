import 'package:events_app/core/constants/app_constants.dart';
import 'package:events_app/presentation/widgets/calendar_filter.dart';
import 'package:flutter/material.dart';



class FilterDrawer extends StatefulWidget {
  final Map<String, List<String>> currentFilters;
  final Function(Map<String, List<String>>) onFiltersChanged;
  final VoidCallback onClearAll;

  const FilterDrawer({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
    required this.onClearAll,
  }) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late Map<String, List<String>> _localFilters;

  @override
  void initState() {
    super.initState();
    _localFilters = Map<String, List<String>>.from(widget.currentFilters);
  }

  void _toggleFilter(String category, String value) {
    setState(() {
      if (_localFilters[category]!.contains(value)) {
        _localFilters[category]!.remove(value);
      } else {
        _localFilters[category]!.add(value);
      }
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_localFilters);
    Navigator.of(context).pop();
  }

  void _clearAll() {
    setState(() {
      _localFilters = {
        'date': [],
        'location': [],
        'sport': [],
        'difficulty': [],
      };
    });
    widget.onClearAll();
  }


  Color get _primaryGreen => Color(0xFF25D366);
  Color get _darkGreen => Color(0xFF128C7E);
  Color get _lightGreen => Color(0xFF25D366).withOpacity(0.1);


  @override
  Widget build(BuildContext context) {
    final totalSelected = _localFilters.values.fold<int>(0, (sum, list) => sum + list.length);
    
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
         
          _buildHeader(context, totalSelected),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildFilterSection(
                  'Date',
                  Icons.calendar_month,
                  AppConstants.dateFilters,
                  'date',
                ),
                SizedBox(height: 24),
                _buildFilterSection(
                  'Location',
                  Icons.location_on,
                  AppConstants.locationFilters,
                  'location',
                ),
                SizedBox(height: 24),
                _buildFilterSection(
                  'Sport Type',
                  Icons.sports,
                  AppConstants.sportFilters,
                  'sport',
                ),
                SizedBox(height: 24),
                _buildFilterSection(
                  'Difficulty',
                  Icons.flag,
                  AppConstants.difficultyFilters,
                  'difficulty',
                ),
                
   
                SizedBox(height: 32),
                _buildApplyButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalSelected) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: _lightGreen,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, color: _darkGreen),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                ),
              ),
              if (totalSelected > 0)
                Text(
                  '$totalSelected selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: _darkGreen.withOpacity(0.7),
                  ),
                ),
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: _clearAll,
            child: Text(
              'Clear All',
              style: TextStyle(
                color: _darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: _darkGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    IconData icon,
    List<FilterOption> options,
    String filterKey,
  ) {
    final selectedOptions = _localFilters[filterKey] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: _darkGreen),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            Spacer(),
            if (selectedOptions.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedOptions.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12),

        if (filterKey == 'date' && selectedOptions.contains('Custom Dates'))
          CalendarFilter(
            selectedDates: [], 
            onDatesSelected: (dates) {
              print('Selected dates: $dates');
            },
            onClose: () {},
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedOptions.contains(option.label);
              return MultiSelectFilterChip(
                label: option.label,
                icon: option.icon,
                selected: isSelected,
                onSelected: (selected) {
                  _toggleFilter(filterKey, option.label);
                },
                primaryGreen: _primaryGreen,
                darkGreen: _darkGreen,
                lightGreen: _lightGreen,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
          elevation: 0,
        ),
        child: Text(
          'Apply Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class MultiSelectFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Function(bool) onSelected;
  final Color primaryGreen;
  final Color darkGreen;
  final Color lightGreen;

  const MultiSelectFilterChip({
    Key? key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
    required this.primaryGreen,
    required this.darkGreen,
    required this.lightGreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: selected ? Colors.white : darkGreen,
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.white : Colors.grey.shade700,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey.shade100,
      selectedColor: primaryGreen,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? primaryGreen : Colors.grey.shade300,
          width: selected ? 1.5 : 1,
        ),
      ),
    );
  }
}