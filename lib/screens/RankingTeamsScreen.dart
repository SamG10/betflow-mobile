import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RankingTeamsScreen extends StatelessWidget {
  const RankingTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Ranking teams'),
    );
  }
}
