// lib/widgets/booking_card.dart

import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(Icons.directions_car, color: Colors.blueAccent),
        title: Text(booking.bookingTitle),
        subtitle: Text(
            '${booking.carMake} ${booking.carModel} (${booking.carYear})\nCustomer: ${booking.customerName}\nStart: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}'),
        isThreeLine: true,
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    ).animate().slideX(begin: -1, end: 0, duration: 500.ms).fadeIn();
  }
}
