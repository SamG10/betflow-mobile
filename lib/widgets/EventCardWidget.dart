import 'package:betflow_mobile_app/modals/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class EventCardWidget extends StatefulWidget {
  final Map<String, dynamic> match;

  const EventCardWidget({Key? key, required this.match}) : super(key: key);

  @override
  _EventCardWidgetState createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  bool isHomeSelected = false;
  bool isDrawSelected = false;
  bool isAwaySelected = false;

  void _toggleItemInCart(
      BuildContext context, Map<String, dynamic> event, String betType) {
    final cart = Provider.of<Cart>(context, listen: false);

    Map<String, dynamic> item = {
      ...event,
      'betType': betType, // Add bet type
      'odd': event['odds'][betType == 'home'
          ? 'homeWin'
          : betType == 'draw'
              ? 'draw'
              : 'awayWin']
    };

    if (cart.containsItem(item)) {
      cart.removeItem(item);
      _resetSelection(betType);
    } else {
      cart.addItem(item);
      _setSelection(betType);
    }
  }

  void _setSelection(String betType) {
    setState(() {
      if (betType == 'home') {
        isHomeSelected = true;
        isDrawSelected = false;
        isAwaySelected = false;
      } else if (betType == 'draw') {
        isHomeSelected = false;
        isDrawSelected = true;
        isAwaySelected = false;
      } else if (betType == 'away') {
        isHomeSelected = false;
        isDrawSelected = false;
        isAwaySelected = true;
      }
    });
  }

  void _resetSelection(String betType) {
    setState(() {
      if (betType == 'home') {
        isHomeSelected = false;
      } else if (betType == 'draw') {
        isDrawSelected = false;
      } else if (betType == 'away') {
        isAwaySelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final isInCart = cart.containsItem(widget.match);

    return Card(
      color: Color.fromARGB(0, 17, 19, 56),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.match['competition']['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.match['utcDate'],
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    widget.match['homeTeam']['crest'].endsWith('.svg')
                        ? SvgPicture.network(
                            widget.match['homeTeam']['crest'],
                            width: 50,
                          )
                        : Image.network(
                            widget.match['homeTeam']['crest'],
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(width: 50, height: 50);
                            },
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 70,
                      child: Text(widget.match['homeTeam']['name'],
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    isHomeSelected
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'home'),
                            child: Text(
                              widget.match['odds']['homeWin'].toString(),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: Colors.blue),
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'home'),
                            child: Text(
                              widget.match['odds']['homeWin'].toString(),
                            ),
                          )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(width: 50, height: 50),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 70,
                      child: Text("Draw",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    isDrawSelected
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'draw'),
                            child: Text(
                              widget.match['odds']['draw'].toString(),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: Colors.blue),
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'draw'),
                            child: Text(
                              widget.match['odds']['draw'].toString(),
                            ),
                          )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.match['awayTeam']['crest'].endsWith('.svg')
                        ? SvgPicture.network(
                            widget.match['awayTeam']['crest'],
                            width: 50,
                          )
                        : Image.network(
                            widget.match['awayTeam']['crest'],
                            width: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(width: 50, height: 50);
                            },
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 70,
                      child: Text(widget.match['awayTeam']['name'],
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    isAwaySelected
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'away'),
                            child: Text(
                              widget.match['odds']['awayWin'].toString(),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: Colors.blue),
                            ),
                            onPressed: () => _toggleItemInCart(
                                context, widget.match, 'away'),
                            child: Text(
                              widget.match['odds']['awayWin'].toString(),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
