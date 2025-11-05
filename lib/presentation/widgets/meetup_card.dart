import 'package:events_app/data/models/model.dart';
import 'package:flutter/material.dart';

class MeetupCard extends StatelessWidget {
  final Meetup meetup;
  final VoidCallback onJoin;

  const MeetupCard({
    Key? key,
    required this.meetup,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Row(
              children: [
                _buildSportBadge(meetup.sportType),
                Spacer(),
                if (meetup.isRecurring)
                  Row(
                    children: [
                      Icon(Icons.repeat, size: 16, color: Colors.blue.shade600),
                      SizedBox(width: 4),
                      Text(
                        'Weekly',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            SizedBox(height: 16),
            
           
            Text(
              meetup.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: Colors.grey.shade800,
              ),
            ),
            
            SizedBox(height: 16),
            
            
            _buildInfoRow(Icons.access_time, '${meetup.time} • ${_formatDate(meetup.date)}'),
            SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, meetup.location),
            SizedBox(height: 8),
            _buildInfoRow(Icons.flag, '${meetup.difficulty} Level'),
            
            SizedBox(height: 16),
            
            
            Row(
              children: [
                _buildParticipants(),
                Spacer(),
                ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportBadge(String sport) {
    final color = _getSportColor(sport);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        sport.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon, 
          size: 16, 
          color: Colors.grey.shade600,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipants() {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.people,
            size: 12,
            color: Colors.blue.shade600,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '${meetup.participants} joining',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getSportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'running':
        return Colors.green.shade600;
      case 'cycling':
        return Colors.orange.shade600;
      case 'swimming':
        return Colors.blue.shade600;
      case 'yoga':
        return Colors.purple.shade600;
      case 'football':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'JAN';
      case 2: return 'FEB';
      case 3: return 'MAR';
      case 4: return 'APR';
      case 5: return 'MAY';
      case 6: return 'JUN';
      case 7: return 'JUL';
      case 8: return 'AUG';
      case 9: return 'SEP';
      case 10: return 'OCT';
      case 11: return 'NOV';
      case 12: return 'DEC';
      default: return '';
    }
  }
}