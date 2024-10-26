// lib/pages/create_booking_page.dart

import 'package:car_workshop_user/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../controllers/booking_controller.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CreateBookingPage extends StatefulWidget {
  @override
  _CreateBookingPageState createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController registrationPlateController =
      TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController =
      TextEditingController();
  final TextEditingController customerEmailController =
      TextEditingController();
  final TextEditingController bookingTitleController = TextEditingController();

  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTime;

  UserModel? selectedMechanic;

  final BookingController bookingController = Get.find<BookingController>();
  final _authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    carMakeController.dispose();
    carModelController.dispose();
    carYearController.dispose();
    registrationPlateController.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerEmailController.dispose();
    bookingTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Booking').animate().fadeIn(duration: 500.ms),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Obx(() {
            return bookingController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildForm().animate().fadeIn(duration: 500.ms),
                  );
          }),
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Car Details'),
          SizedBox(height: 8),
          _buildTextField(
            controller: carMakeController,
            label: 'Make',
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter car make' : null,
          ),
          SizedBox(height: 8),
          _buildTextField(
            controller: carModelController,
            label: 'Model',
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter car model' : null,
          ),
          SizedBox(height: 8),
          _buildTextField(
            controller: carYearController,
            label: 'Year',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter car year';
              }
              if (int.tryParse(value.trim()) == null) {
                return 'Please enter a valid year';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          _buildTextField(
            controller: registrationPlateController,
            label: 'Registration Plate',
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Please enter registration plate'
                : null,
          ),
          SizedBox(height: 16),
          _buildSectionTitle('Customer Details'),
          SizedBox(height: 8),
          _buildTextField(
            controller: customerNameController,
            label: 'Name',
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter customer name' : null,
          ),
          SizedBox(height: 8),
          _buildTextField(
            controller: customerPhoneController,
            label: 'Phone Number',
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter phone number' : null,
          ),
          SizedBox(height: 8),
          _buildTextField(
            controller: customerEmailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter email';
              }
              if (!GetUtils.isEmail(value.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildSectionTitle('Booking Details'),
          SizedBox(height: 8),
          _buildTextField(
            controller: bookingTitleController,
            label: 'Booking Title',
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter booking title' : null,
          ),
          SizedBox(height: 8),
          _buildDateTimePicker(
            label: 'Start Date & Time',
            selectedDateTime: selectedStartDateTime,
            onSelected: (dateTime) {
              setState(() {
                selectedStartDateTime = dateTime;
              });
            },
          ),
          SizedBox(height: 8),
          _buildDateTimePicker(
            label: 'End Date & Time',
            selectedDateTime: selectedEndDateTime,
            onSelected: (dateTime) {
              setState(() {
                selectedEndDateTime = dateTime;
              });
            },
          ),
          SizedBox(height: 8),
          _buildMechanicDropdown(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitBooking,
            child: Text('Create Booking'),
          ).animate().fadeIn(duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ).animate().slideX(begin: -0.5, end: 0, duration: 500.ms).fadeIn();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime? selectedDateTime,
    required ValueChanged<DateTime> onSelected,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(selectedDateTime != null
          ? DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime)
          : 'Select $label'),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await _selectDateTime(context, selectedDateTime);
        if (pickedDate != null) {
          onSelected(pickedDate);
        }
      },
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildMechanicDropdown() {
    return DropdownSearch<UserModel>(
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: 'Search Mechanics',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      items: bookingController.mechanics.toList(),
      itemAsString: (UserModel u) => u.email,
      onChanged: (UserModel? selected) {
        setState(() {
          selectedMechanic = selected;
        });
      },
      selectedItem: selectedMechanic,
      validator: (value) => value == null ? 'Please select a mechanic' : null,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Assign Mechanic',
          border: OutlineInputBorder(),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (selectedStartDateTime == null || selectedEndDateTime == null) {
        Get.snackbar('Error', 'Please select both start and end date & time.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (selectedEndDateTime!.isBefore(selectedStartDateTime!)) {
        Get.snackbar('Error', 'End date & time must be after start date & time.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (selectedMechanic == null) {
        Get.snackbar('Error', 'Please assign a mechanic.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      BookingModel newBooking = BookingModel(
        carMake: carMakeController.text.trim(),
        carModel: carModelController.text.trim(),
        carYear: int.parse(carYearController.text.trim()),
        registrationPlate: registrationPlateController.text.trim(),
        customerName: customerNameController.text.trim(),
        customerPhone: customerPhoneController.text.trim(),
        customerEmail: customerEmailController.text.trim(),
        bookingTitle: bookingTitleController.text.trim(),
        startDatetime: Timestamp.fromDate(selectedStartDateTime!),
        endDatetime: Timestamp.fromDate(selectedEndDateTime!),
        assignedMechanic: selectedMechanic!.id,
        userId: _authController.user.value!.uid,
      );

      bookingController.createBooking(newBooking).then((_) {
        Get.back();
        Get.snackbar('Success', 'Booking created successfully.',
            snackPosition: SnackPosition.BOTTOM);
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to create booking.',
            snackPosition: SnackPosition.BOTTOM);
      });
    }
  }

  Future<DateTime?> _selectDateTime(
      BuildContext context, DateTime? initialDateTime) async {
    DateTime initialDate = initialDateTime ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialDateTime != null
          ? TimeOfDay.fromDateTime(initialDateTime)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);
  }
}
