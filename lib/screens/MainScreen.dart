import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/modals/auth.dart';
import 'package:betflow_mobile_app/modals/cart.dart';
import 'package:betflow_mobile_app/routes/appRouter.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cart = Provider.of<Cart>(context);

    print(authProvider);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ProfileRoute(),
        RankingTeamsRoute(),
        CartRoute()
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xff13131a),
            title: Image.asset(
              "assets/logo.png",
              scale: 6,
            ),
            actions: <Widget>[
              if (!authProvider.isAuthenticated)
                OutlinedButton(
                    onPressed: () =>
                        context.router.navigate(const LoginRoute()),
                    child: Text("Login"))
              else
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await authProvider.logout();
                  },
                )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: tabsRouter.activeIndex,
            backgroundColor: Color(0xff1c1c24),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            onTap: (value) {
              tabsRouter.setActiveIndex(value);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked),
                label: 'Ranking Teams',
              ),
              BottomNavigationBarItem(
                icon: badges.Badge(
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(Icons.shop_2_outlined),
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                ),
                label: 'Cart',
              ),
            ],
          ),
        );
      },
    );
  }
}
