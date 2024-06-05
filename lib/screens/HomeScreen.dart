import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/services/events.service.dart';
import 'package:betflow_mobile_app/widgets/EventCardWidget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventsService _eventsService = EventsService();

  List<dynamic> _matches = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    List<dynamic> matches = await _eventsService.fetchEvents();

    setState(() {
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: ListView.builder(
        itemCount: _matches.length,
        itemBuilder: (context, index) {
          var match = _matches[index];
          return EventCardWidget(match: match);
        },
      ),
    ));
  }
}
