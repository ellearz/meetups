import 'package:events_app/presentation/providers/meetup_providers.dart';
import 'package:events_app/presentation/screens/meetup_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeetupProvider(),
      child: MaterialApp(
        title: 'MyMeetups',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: MeetupListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}