import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/modals/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .fetchUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    print("user.....................");
    print(user);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                user?['coins'].toString() ?? '0',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "./assets/logo.png",
                width: 30,
              )
            ],
          ),
          SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "IN PROGRESS"),
              Tab(text: "FINISH"),
            ],
          ),
          Expanded(
              child: user == null || user['bets'] == null
                  ? Center(child: Text("You don't have any bets"))
                  : TabBarView(controller: _tabController, children: [
                      _buildBetList(
                          user['bets']
                              .where((b) => b['status'] == 'IN_PROGRESS')
                              .toList(),
                          "IN_PROGRESS"),
                      _buildBetList(
                          user['bets']
                              .where((b) => b['status'] == 'FINISH')
                              .toList(),
                          "FINISH"),
                    ])),
        ],
      ),
    ));
  }

  Widget _buildBetList(List bets, String status) {
    Widget _buildImage(String url) {
      if (url.endsWith('.svg')) {
        return SvgPicture.network(
          url,
          width: 50,
          placeholderBuilder: (context) => SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
          fit: BoxFit.contain,
        );
      } else {
        return Image.network(
          url,
          width: 50,
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(width: 50, height: 50);
          },
        );
      }
    }

    return ListView.builder(
      itemCount: bets.length,
      itemBuilder: (context, index) {
        final bet = bets[index];

        return Card(
          elevation: 10.0,
          color: Color.fromARGB(0, 17, 19, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _buildImage(bet['homeTeamLogo']),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            bet['homeTeamName'],
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Text("SCORE"),
                    Column(
                      children: [
                        _buildImage(bet['awayTeamLogo']),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            bet['awayTeamName'],
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Stake: ${bet['stake']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Gains: ${bet['coinsGain'] ?? 'IN_PROGRESS'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        bet['coinsGain'] != null ? Colors.green : Colors.orange,
                  ),
                ),
                Text('Match Date: ${bet['eventDate'].split('T')[0]}'),
                Text('Result: ${bet['betResult'] ?? ''}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
