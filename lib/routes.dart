import 'package:green_bin/pages/auth/auth.dart';
import 'package:green_bin/pages/auth/change_password.dart';
import 'package:green_bin/pages/auth/create_account.dart';
import 'package:green_bin/pages/auth/forgot_password.dart';
import 'package:green_bin/pages/auth/update_username.dart';
import 'package:green_bin/pages/guide/article_content.dart';
import 'package:green_bin/pages/guide/article_detail.dart';
import 'package:green_bin/pages/legal/privacy_policy_page.dart';
import 'package:green_bin/pages/legal/terms_page.dart';
import 'package:green_bin/pages/location/recycling_center_detail_page.dart';
import 'package:green_bin/pages/profile/recycling_history.dart';
import 'package:green_bin/pages/profile/settings.dart';
import 'package:green_bin/pages/profile/user_levels.dart';
import 'package:green_bin/pages/scan_item/scan_item_main.dart';

final appRoutes = {
  '/': (context) => AuthPage(),
  TermsPage.routeName: (context) => TermsPage(),
  PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),

  CreateAccountPage.routeName: (context) => CreateAccountPage(),
  ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(),

  ScanItemMainPage.routeName: (context) => ScanItemMainPage(),

  ArticleDetailPage.routeName: (context) => ArticleDetailPage(),
  ArticleContentPage.routeName: (context) => ArticleContentPage(),

  RecyclingCenterDetailPage.routeName: (context) => RecyclingCenterDetailPage(),

  UserLevelsPage.routeName: (context) => UserLevelsPage(),
  RecyclingHistoryPage.routeName : (context) => RecyclingHistoryPage(),

  SettingsPage.routeName: (context) => SettingsPage(),
  UpdateUsernamePage.routeName: (context) => UpdateUsernamePage(),
  ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
};