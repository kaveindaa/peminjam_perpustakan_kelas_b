import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:peminjam_perpustakaan_kelas_b/app/data/provider/api_provider.dart';
import 'package:peminjam_perpustakaan_kelas_b/app/data/provider/storage_provider.dart';
import 'package:peminjam_perpustakaan_kelas_b/app/routes/app_pages.dart';
import '../../../data/constant/endpoint.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/provider/api_provider.dart';
import '../../../data/provider/storage_provider.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final loading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //TODO: Implement LoginController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    String status = StorageProvider.read(StorageKey.status);
    log("status : $status");
    if(status == "logged"){
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  register() async{
    loading(true);
    try{
      FocusScope.of(Get.context!).unfocus();
      formKey.currentState?.save();
      if(formKey.currentState!.validate()){
        final response = await ApiProvider.instance().post(Endpoint.register,
            data: dio.FormData.fromMap(
                {"nama":namaController.text.toString(),
                  "username":usernameController.text.toString(),
                  "telp":telpController.text.toString(),
                  "alamat":alamatController.text.toString(),
                  "password":passwordController.text.toString(),}));
        if(response.statusCode == 201){
          await StorageProvider.write(StorageKey.status, "logged");
          Get.offAllNamed(Routes.HOME);
        }else{
          Get.snackbar("Sorry", "Register Gagal", backgroundColor: Colors.orange);
        }
      }loading(false);
    }on dio.DioException catch (e){
      loading(false);
      if(e.response != null){
        if(e.response?.data != null){
          Get.snackbar("Sorry", "${e.response?.data['message']}", backgroundColor: Colors.orange);
        }
      }else{
        Get.snackbar("Sorry", e.message ?? "", backgroundColor: Colors.red);
      }
    }catch (e) {loading(false);
    Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }
}