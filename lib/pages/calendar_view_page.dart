// lib/pages/calendar_view_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/booking_controller.dart';
import '../models/booking_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalendarViewPage extends StatefulWidget {
  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  late final ValueNotifier<List<BookingModel>> _selectedBookings;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final BookingController bookingController = Get.find<BookingController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedBookings = ValueNotifier(_getBookingsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedBookings.dispose();
    super.dispose();
  }

  List<BookingModel> _getBookingsForDay(DateTime day) {
    return bookingController.userBookings.where((booking) {
      DateTime bookingDay = booking.startDatetime.toDate();
      return isSameDay(bookingDay, day);
    }).toList();
  }

  Map<DateTime, List<BookingModel>> _groupBookings(List<BookingModel> userBookings) {
    Map<DateTime, List<BookingModel>> data = {};
    for (var booking in userBookings) {
      DateTime date = DateTime(
          booking.startDatetime.toDate().year,
          booking.startDatetime.toDate().month,
          booking.startDatetime.toDate().day);
      if (data[date] == null) {
        data[date] = [booking];
      } else {
        data[date]!.add(booking);
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings Calendar').animate().fadeIn(duration: 500.ms),
      ),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        List<BookingModel> userBookings = authController.userModel.value!.role == 'user'
            ? bookingController.userBookings
            : [];

        Map<DateTime, List<BookingModel>> groupedBookings = _groupBookings(userBookings);

        return Column(
          children: [
            TableCalendar<BookingModel>(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return groupedBookings[DateTime(day.year, day.month, day.day)] ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _selectedBookings.value = _getBookingsForDay(selectedDay);
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<BookingModel>>(
                valueListenable: _selectedBookings,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return Center(child: Text('No bookings for this day.'));
                  }
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final booking = value[index];
                      return Card(
                        child: ListTile(
                          title: Text(booking.bookingTitle),
                          subtitle: Text(
                              '${booking.carMake} ${booking.carModel} (${booking.carYear})\nCustomer: ${booking.customerName}\nStart: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}'),
                          isThreeLine: true,
                          onTap: () {
                            _showBookingDetails(booking);
                          },
                        ),
                      ).animate().fadeIn(duration: 500.ms);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showBookingDetails(BookingModel booking) {
    Get.dialog(
      AlertDialog(
        title: Text(booking.bookingTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Car Details:'),
              Text('${booking.carMake} ${booking.carModel} (${booking.carYear})'),
              Text('Registration Plate: ${booking.registrationPlate}'),
              SizedBox(height: 8),
              Text('Customer Details:'),
              Text('Name: ${booking.customerName}'),
              Text('Phone: ${booking.customerPhone}'),
              Text('Email: ${booking.customerEmail}'),
              SizedBox(height: 8),
              Text('Booking Details:'),
              Text(
                  'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}'),
              Text(
                  'End: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endDatetime.toDate())}'),
              if (booking.assignedMechanic != null)
                Text('Assigned Mechanic ID: ${booking.assignedMechanic}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Close'),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
