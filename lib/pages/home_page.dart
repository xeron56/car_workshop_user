// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/booking_card.dart';
import 'create_booking_page.dart';
import 'calendar_view_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatelessWidget {
  final BookingController bookingController = Get.find<BookingController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings').animate().fadeIn(duration: 500.ms),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Get.to(() => CalendarViewPage());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Obx(() {
            if (bookingController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (bookingController.userBookings.isEmpty) {
              return Center(child: Text('No bookings found.'));
            }

            return ListView.builder(
              itemCount: bookingController.userBookings.length,
              itemBuilder: (context, index) {
                final booking = bookingController.userBookings[index];
                return BookingCard(
                  booking: booking,
                  onTap: () {
                    Get.toNamed('/booking-details', arguments: booking);
                  },
                ).animate().fadeIn(delay: (index * 100).ms, duration: 500.ms);
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateBookingPage());
        },
        child: Icon(Icons.add),
        tooltip: 'Create Booking',
      ).animate().scale(delay: 500.ms, duration: 500.ms),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/background.jpg',
        fit: BoxFit.cover,
      ).animate().blur(begin: Offset(0, 0), end: Offset(2, 2), duration: const Duration(seconds: 2)),
    );
  }
}
