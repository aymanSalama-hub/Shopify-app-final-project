import 'package:Shopify/features/person/presentation/cubit/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  String name = '';
  String email = '';
  String imageUrl =
      'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String profileImageUrl =
      'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png';
  bool isEditing = false;
  Future<void> pickImage() async {
    emit(ProfileLoadingState());
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImageUrl = image.path;
    }
    emit(ProfileSuccessState());
  }

  void loadUserData() async {
    emit(ProfileLoadingState());
    // Mock user data - replace with actual data fetching
    try {
      final firebase = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        // Not logged in
        emit(ProfileErrorState());
        return;
      }
      print(userId);

      final doc = await firebase.collection('users').doc(userId).get();
      final data = doc.data();
      if (data == null) {
        emit(ProfileErrorState());
        return;
      }
      profileImageUrl = (data['photoURL'] as String?) ?? profileImageUrl;
      nameController.text = (data['name'] as String?) ?? '';
      emailController.text = (data['email'] as String?) ?? '';
      phoneController.text = (data['phone number'] as String?) ?? '';
      addressController.text = (data['address'] as String?) ?? '';
      name = (data['name'] as String?) ?? '';
      email = (data['email'] as String?) ?? '';
      imageUrl = (data['photoURL'] as String?) ?? imageUrl;
      emit(ProfileSuccessState());
    } catch (e) {
      emit(ProfileErrorState());
    }
  }

  void toggleEditing() {
    isEditing = !isEditing;
    emit(ProfileSuccessState());
  }

  void saveProfile() async {
    emit(ProfileLoadingState());
    // Save profile data (in real app, save to API/SharedPreferences)
    final firebase = FirebaseFirestore.instance;
    try {
      isEditing = false;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(ProfileErrorState());
        return;
      }

      await firebase.collection('users').doc(userId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone number': phoneController.text,
        'address': addressController.text,
        'photoURL': profileImageUrl,
      });
      // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Profile updated successfully!'),
      //     backgroundColor: Theme.of(context).colorScheme.primary,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      // );
      emit(ProfileSuccessState());
    } catch (e) {
      emit(ProfileErrorState());
    }
  }
}
