import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Data/Api Resp/api_response.dart';
import '../../../../Model/User.dart';
import '../../../../Repo/Individual Bill Repository/individual_bill_reopsitory.dart';

import '../Model/IndividualBill.dart';

class IndividualBillController extends GetxController {
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

  final individualBillRepository = IndividualBillRepository();
  List<String> dataColumnNames = [
    "BillNames",
    "BillPrices",
    "charges",
    "latecharges",
    "tax",
    "balance",
    "payableamount",
    "totalpaidamount",
    "billstartdate",
    "billenddate",
    "duedate",
    "billtype",
    "paymenttype",
    "status",
  ];

  List<IndividualBills> li = [];
  List<BillItems> billItemsList = [];

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
    
  }

  viewAllResidentsApi({required bearerToken, required subAdminId}) async {
    setResponseStatus(Status.loading);

    await individualBillRepository.IndividualBillsForFinanceApi(
      bearerToken: bearerToken,
      subAdminId: subAdminId,
      //type: typeSociety
    ).then((value) {
      li.clear();

      update();

      for (int i = 0; i < value.individualBills.length; i++) {
        li.add(value.individualBills[i]);
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

    await individualBillRepository
        .searchIndividualBillApi(
            query: search, subAdminId: subAdminId, bearerToken: bearerToken)
        .then((value) {
      update();
      if (kDebugMode) {
        print(value);
        li.clear();

        update();
        for (int i = 0; i < value.individualBills.length; i++) {
          li.add(value.individualBills[i]);
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

    individualBillRepository
        .filterIndividualApi(
      subAdminId: subAdminId,
      bearerToken: bearerToken,
      type: propertyType,
    )
        .then((value) {
      setResponseStatus(Status.completed);

      for (int i = 0; i < value.individualBills!.length; i++) {
        li.add(value.individualBills![i]);
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
