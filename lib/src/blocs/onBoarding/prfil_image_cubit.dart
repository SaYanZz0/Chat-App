import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<File?> {
  final _picker = ImagePicker();
  ProfileImageCubit() : super(null);

  Future<void> getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        emit(File(pickedFile.path));
      }
    } catch (e) {
      print(e);
    }
  }
}
