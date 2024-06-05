import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/routes/appRouter.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, initial: true, children: [
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: ProfileRoute.page),
          AutoRoute(page: RankingTeamsRoute.page),
          AutoRoute(page: CartRoute.page),
        ]),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
      ];
}
