// lib/routes/app_pages.dart

import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/home_page.dart';
import '../pages/create_booking_page.dart';
import '../pages/calendar_view_page.dart';
import '../pages/booking_details_page.dart';
import '../bindings/auth_binding.dart';
import '../bindings/booking_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      //binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      //binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      bindings: [
       // AuthBinding(),
        BookingBinding(),
      ],
    ),
    GetPage(
      name: Routes.CREATE_BOOKING,
      page: () => CreateBookingPage(),
      bindings: [
        //AuthBinding(),
        BookingBinding(),
      ],
    ),
    GetPage(
      name: Routes.CALENDAR_VIEW,
      page: () => CalendarViewPage(),
      bindings: [
        //AuthBinding(),
        BookingBinding(),
      ],
    ),
    GetPage(
      name: Routes.BOOKING_DETAILS,
      page: () => BookingDetailsPage(),
      bindings: [
        //AuthBinding(),
        BookingBinding(),
      ],
    ),
    // Add other pages here
  ];
}
