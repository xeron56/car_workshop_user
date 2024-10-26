// lib/controllers/booking_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';
import 'dart:async';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var bookings = <BookingModel>[].obs;
  var userBookings = <BookingModel>[].obs;
  var mechanics = <UserModel>[].obs;

  final AuthController _authController = Get.find<AuthController>();

  StreamSubscription? _bookingSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchMechanics();
    _listenToBookings();
  }

  @override
  void onClose() {
    _bookingSubscription?.cancel();
    super.onClose();
  }

  void _listenToBookings() {
    isLoading.value = true;
    try {
      _bookingSubscription = _firestore
          .collection('bookings')
          .where('user_id', isEqualTo: _authController.user.value!.uid)
          .orderBy('start_datetime')
          .snapshots()
          .listen((snapshot) {
        userBookings.value = snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList();
      });
      print('Listening to bookings...');
      print("${userBookings.length}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to listen to bookings.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMechanics() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'mechanic')
          .get();
      mechanics.value = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch mechanics.');
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create booking.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBooking(String bookingId, BookingModel updatedBooking) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').doc(bookingId).update(updatedBooking.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete booking.');
    } finally {
      isLoading.value = false;
    }
  }
}
