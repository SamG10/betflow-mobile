import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/modals/auth.dart';
import 'package:betflow_mobile_app/modals/cart.dart';
import 'package:betflow_mobile_app/services/bets.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final BetsService betsService = BetsService();
  List<Map<String, dynamic>> bets = [];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cart = Provider.of<Cart>(context);

    void _saveBets(BuildContext context) async {
      if (!auth.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to place a bet ;)')),
        );
        return;
      }

      final cart = Provider.of<Cart>(context, listen: false);
      bets = cart.items.map((item) {
        return {
          'stake': item['stake'],
          'odd': item['odd'],
          'team': item['betType'] == 'home'
              ? 'HOME_TEAM'
              : item['betType'] == 'draw'
                  ? 'DRAW'
                  : 'AWAY_TEAM',
          'endDateEvent': item['lastUpdated'],
          'eventId': item['id'],
          'homeTeamOdd': item['odds']['homeWin'],
          'drawTeamOdd': item['odds']['draw'],
          'awayTeamOdd': item['odds']['awayWin'],
          'homeTeamName': item['homeTeam']['name'],
          'awayTeamName': item['awayTeam']['name'],
          'homeTeamLogo': item['homeTeam']['crest'],
          'awayTeamLogo': item['awayTeam']['crest'],
          'eventDate': item['utcDate'],
        };
      }).toList();

      try {
        await betsService.createBets(bets);
        cart.clear();
        auth.fetchUserProfile();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save bets')),
        );
      }
    }

    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];

                return Card(
                  color: Color(0xff1c1c24),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x36a7abad), width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              child: Text(
                                "${item['homeTeam']['name']} - ${item['awayTeam']['name']}",
                                softWrap: true,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                              ),
                              onPressed: () => {
                                setState(() {
                                  cart.removeItem(item);
                                })
                              },
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // Display the selected team or draw
                              item['betType'] == 'home'
                                  ? item['homeTeam']['name']
                                  : item['betType'] == 'draw'
                                      ? 'Draw'
                                      : item['awayTeam']['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            OutlinedButton(
                              onPressed: () => {},
                              child: Text(item['odd'].toString()),
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(width: 2.0, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color(0x3587a1af),
                            hintText: 'Stake',
                            hintStyle: TextStyle(color: Colors.white),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEFEFEF)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              item['stake'] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () => _saveBets(context),
              child: Text('Save Bets'),
            ),
          ),
        ],
      ),
    ));
  }
}
