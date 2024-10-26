// lib/pages/booking_details_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../controllers/booking_controller.dart';
import '../controllers/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingDetailsPage extends StatelessWidget {
  final BookingModel booking = Get.arguments as BookingModel;
  final BookingController bookingController = Get.find<BookingController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details').animate().fadeIn(duration: 500.ms),
        actions: [
          if (authController.userModel.value!.role == 'user')
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteBooking(context);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/background.jpg',
        fit: BoxFit.cover,
      ).animate().blur(begin: Offset(0, 0), end: Offset(6, 6), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildSectionTitle('Booking Title'),
          _buildSectionContent(booking.bookingTitle),
          _buildSectionTitle('Car Details'),
          _buildSectionContent(
              '${booking.carMake} ${booking.carModel} (${booking.carYear})\nRegistration Plate: ${booking.registrationPlate}'),
          _buildSectionTitle('Customer Details'),
          _buildSectionContent(
              'Name: ${booking.customerName}\nPhone: ${booking.customerPhone}\nEmail: ${booking.customerEmail}'),
          _buildSectionTitle('Booking Schedule'),
          _buildSectionContent(
              'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}\nEnd: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endDatetime.toDate())}'),
          if (booking.assignedMechanic != null)
            _buildSectionTitle('Assigned Mechanic ID'),
          if (booking.assignedMechanic != null)
            _buildSectionContent('${booking.assignedMechanic}'),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
        .animate()
        .slideX(begin: -0.5, end: 0, duration: 500.ms)
        .fadeIn();
  }

  Widget _buildSectionContent(String content) {
    return Text(content).animate().fadeIn(duration: 500.ms).paddingOnly(bottom: 16);
  }

  void _deleteBooking(BuildContext context) {
    Get.defaultDialog(
      title: 'Delete Booking',
      middleText: 'Are you sure you want to delete this booking?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        bookingController.deleteBooking(booking.id!).then((_) {
          Get.back();
          Get.back();
          Get.snackbar('Success', 'Booking deleted successfully.',
              snackPosition: SnackPosition.BOTTOM);
        }).catchError((error) {
          Get.back();
          Get.snackbar('Error', 'Failed to delete booking.',
              snackPosition: SnackPosition.BOTTOM);
        });
      },
    );
  }
}
