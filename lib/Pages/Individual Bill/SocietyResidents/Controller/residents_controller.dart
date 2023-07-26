import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Data/Api Resp/api_response.dart';
import '../../../../Model/User.dart';
import '../../../../Repo/Society Residents Repo/residents_reopsitory.dart';
import '../Model/Resident.dart';

class SocietyResidentsController extends GetxController {
  var userdata = Get.arguments;
  late final User user;

  var responseStatus = Status.loading;
  TextEditingController searchController = TextEditingController();
  String typeSociety = 'society';
  String? searchQuery;
  Timer? debouncer;
  String? selectedOption;

  String startDate = "";
  String? statusVal;
  String? houseApartmentValue;

  List<String> houseApartmentTypes = ['House', 'Apartment'];

  bool loading = false;

  final societyresidentsRepo = SocietyResidentsRepository();
  List<String> dataColumnNames = [
    "Name",
    "Address",
    "mobileno",
    "propertytype",
    "vechileno",
    "residenttype",
    "Generate Bill"
  ];

  late final SocietyResident societyResident;
  List<Residentslist> li = [];

  setResponseStatus(Status val) {
    responseStatus = val;
    update();

    return responseStatus;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    user = userdata;

    viewAllResidentsApi(
        bearerToken: user.bearer, subAdminId: user.data!.subadminid);
    print(user.bearer);
  }

  viewAllResidentsApi({required bearerToken, required subAdminId}) async {
    setResponseStatus(Status.loading);

    await societyresidentsRepo
        .residentsApi(
      bearerToken: bearerToken,
      subAdminId: subAdminId,
      //type: typeSociety
    )
        .then((value) {
      li.clear();

      update();

      for (int i = 0; i < value.residentslist.length; i++) {
        li.add(value.residentslist[i]);
      }

      setResponseStatus(Status.completed);
    }).onError((error, stackTrace) {
      setResponseStatus(Status.error);

      Get.snackbar('Error', '$error ', backgroundColor: Colors.white);
      log(error.toString());
      log(stackTrace.toString());
    });
  }

  searchResidentApi(
      {required search, required bearerToken, required subAdminId}) async {
    setResponseStatus(Status.loading);

    await societyresidentsRepo
        .searchApi(
            query: search, subAdminId: subAdminId, bearerToken: bearerToken)
        .then((value) {
      update();
      if (kDebugMode) {
        print(value);
        li.clear();

        update();
        for (int i = 0; i < value.residentslist.length; i++) {
          li.add(value.residentslist[i]);
        }

        setResponseStatus(Status.completed);
      }
    }).onError((error, stackTrace) {
      setResponseStatus(Status.error);

      Get.snackbar('Error', '$error ', backgroundColor: Colors.white);
      log(error.toString());
      log(stackTrace.toString());
    });
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
      update();
    }

    debouncer = Timer(duration, callback);
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    debouncer?.cancel();
    searchController.dispose();
  }

  setHouseApartmentVal({required value}) {
    houseApartmentValue = value;
    update();
  }

  setStatusTypeVal({required value}) {
    statusVal = value;
    update();
  }

  allResidentFilterApi({
    required subAdminId,
    required bearerToken,
    String? propertyType,
  }) {
    li.clear();
    setResponseStatus(Status.loading);

    update();

    societyresidentsRepo
        .filterResidentsApi(
      subAdminId: subAdminId,
      bearerToken: bearerToken,
      type: propertyType,
    )
        .then((value) {
      setResponseStatus(Status.completed);

      for (int i = 0; i < value.residentslist!.length; i++) {
        li.add(value.residentslist![i]);
      }
      Get.back();
    }).onError((error, stackTrace) {
      setResponseStatus(Status.error);

      Get.snackbar('Error', '$error ', backgroundColor: Colors.white);
      log(error.toString());
      log(stackTrace.toString());
    });
  }
}
