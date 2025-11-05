import 'package:events_app/data/models/model.dart';
import 'package:events_app/presentation/providers/meetup_providers.dart';
import 'package:events_app/presentation/widgets/filter_drawer.dart';
import 'package:events_app/presentation/widgets/meetup_card.dart';
import 'package:flutter/material.dart';


class MeetupListScreen extends StatefulWidget {
  @override
  _MeetupListScreenState createState() => _MeetupListScreenState();
}

class _MeetupListScreenState extends State<MeetupListScreen> {
  final MeetupProvider _provider = MeetupProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadMeetups();
  }

  Future<void> _loadMeetups() async {
    await _provider.loadMeetups();
  }

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _joinMeetup(Meetup meetup) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${meetup.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildActiveFiltersBar(BuildContext context) {
    final allActiveFilters = _provider.activeFilters.entries
        .expand((entry) => entry.value)
        .toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue.shade50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(Icons.filter_alt, size: 16, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text(
              'Active:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(width: 8),
            ...allActiveFilters.map((filter) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade100,
                    deleteIcon: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    onDeleted: () => _removeSpecificFilter(filter),
                  ),
                ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _removeSpecificFilter(String filterValue) {
    final newFilters = Map<String, List<String>>.from(_provider.activeFilters);
    for (final entry in newFilters.entries) {
      if (entry.value.contains(filterValue)) {
        entry.value.remove(filterValue);
        break;
      }
    }
    
    _provider.applyFilters(newFilters);
  }

  Widget _buildWhatsAppCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Redirecting to WhatsApp community...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF25D366),
              Color(0xFF128C7E),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join WhatsApp Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Never miss events of your sport',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: Colors.blue.shade600,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading meetups...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16),
          Text(
            'No meetups found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _provider.clearAllFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.event_available_rounded,
              color: Colors.blue.shade600,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'MyMeetups',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _provider.hasActiveFilters 
                        ? Colors.blue.shade100
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _provider.hasActiveFilters
                          ? Colors.blue.shade600
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _provider.isLoading ? null : _openFilterDrawer,
                    icon: _provider.isLoading 
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade600,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.tune_rounded,
                            color: _provider.hasActiveFilters
                                ? Colors.blue.shade600
                                : Colors.grey.shade600,
                          ),
                    tooltip: 'Filter & Sort',
                  ),
                ),
                
                if (_provider.hasActiveFilters && !_provider.isLoading)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade600.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        _provider.activeFilters.entries
                            .fold<int>(0, (sum, entry) => sum + entry.value.length)
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        currentFilters: _provider.activeFilters,
        onFiltersChanged: (newFilters) => _provider.applyFilters(newFilters),
        onClearAll: _provider.clearAllFilters,
      ),
      body: AnimatedBuilder(
        animation: _provider,
        builder: (context, child) {
          if (_provider.isLoading && _provider.meetups.isEmpty) {
            return _buildLoadingState();
          }
          
          return Column(
            children: [
            
              if (_provider.hasActiveFilters) _buildActiveFiltersBar(context),
              
              
              _buildWhatsAppCard(),
              
             
              if (_provider.meetups.isNotEmpty) 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${_provider.meetups.length} found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Meetup list
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _provider.meetups.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadMeetups,
                          color: Colors.blue.shade600,
                          child: ListView.separated(
                            itemCount: _provider.meetups.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final meetup = _provider.meetups[index];
                              return MeetupCard(
                                meetup: meetup,
                                onJoin: () => _joinMeetup(meetup),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}