import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Constants/date_formatter.dart';
import '../../../../Data/Api Resp/api_response.dart';
import '../../../../Model/User.dart';
import '../../../../Repo/Individual Bill Repository/individual_bill_reopsitory.dart';

import '../Model/IndividualBill.dart';

class IndividualBillController extends GetxController {
  var userdata = Get.arguments;
  late final User user;
  int? residentid;
  String? propertyType;

  var responseStatus = Status.loading;
  TextEditingController searchController = TextEditingController();
  String typeSociety = 'society';
  String? searchQuery;
  Timer? debouncer;
  String? selectedOption;

  String? startDate;
  String? endDate;
  String? dueDate;

  String? statusVal;

  bool loading = false;

  String? paymentTypeValue;

  List<String> paymentTypes = ['Cash', 'BankTransfer', 'Online', 'NA'];

  List<String> statusTypes = ['paid', 'unpaid'];
  TextEditingController billNameController = TextEditingController();
  TextEditingController billPriceController = TextEditingController();
  TextEditingController lateChargesController = TextEditingController();
  TextEditingController taxPriceController = TextEditingController();

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

  List<Map<String, dynamic>> billItems = [];
  final formKey = GlobalKey<FormState>();
  final addItemformKey = GlobalKey<FormState>();

  setResponseStatus(Status val) {
    responseStatus = val;
    update();

    return responseStatus;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    user = userdata[0];
    residentid = userdata[1];
    propertyType = userdata[2];

    viewIndividualBillApi(
        bearerToken: user.bearer, subAdminId: user.data!.subadminid);
  }

  viewIndividualBillApi({required bearerToken, required subAdminId}) async {
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

  setPaymentTypeVal({required value}) {
    paymentTypeValue = value;
    update();
  }

  setStatusTypeVal({required value}) {
    statusVal = value;
    update();
  }

  selectDate(BuildContext context) async {
    startDate = await DateFormatter().selectDate(context) ?? "";

    update();
  }

  selectEndDate(BuildContext context) async {
    endDate = await DateFormatter().selectDate(context) ?? "";

    update();
  }

  selectDueDate(BuildContext context) async {
    dueDate = await DateFormatter().selectDate(context) ?? "";

    update();
  }

  filterBillsApi({
    required subAdminId,
    required bearerToken,
    //required financeManagerId,

    String? startDate,
    String? endDate,
    String? paymentType,
    String? status,
  }) {
    li.clear();
    setResponseStatus(Status.loading);

    update();

    individualBillRepository
        .filterIndividualBillsApi(
            subAdminId: subAdminId,
            //financeManagerId: financeManagerId,
            bearerToken: bearerToken,
            paymentType: paymentType,
            status: status,
            endDate: endDate,
            startDate: startDate)
        .then((value) {
      setResponseStatus(Status.completed);

      for (int i = 0; i < value.individualBills.length; i++) {
        li.add(value.individualBills[i]);
      }
      Get.back();
    }).onError((error, stackTrace) {
      setResponseStatus(Status.error);

      Get.snackbar('Error', '$error ', backgroundColor: Colors.white);
      log(error.toString());
      log(stackTrace.toString());
    });
  }

  void addBillItem(billName, billPrice) {
    double billPriceParsed = double.tryParse(billPrice) ?? 0.0;
    print("billPriceParsed $billPriceParsed");

    if (billName.isNotEmpty && billPriceParsed > 0.0) {
      Map<String, dynamic> billData = {
        "billname": billName,
        "billprice": billPriceParsed,
      };
      billItems.add(billData);

      billNameController.clear();
      billPriceController.clear();

      update();
    }
  }

  generateIndividualBillApi({
    required subAdminId,
    required financeManagerId,
    required dueDate,
    required billStartDate,
    required billEndDate,
    required bearerToken,
    required residentid,
    //required propertyid,
    required billtype,
    //required paymenttype,
    required latecharges,
    required tax,
    required List<Map<String, dynamic>> bill_items,
  }) {
    loading = true;
    update();

    print(financeManagerId);
    // String billItemsJson = jsonEncode(bill_items);

    Map<String, String> data = <String, String>{
      'subadminid': subAdminId.toString(),
      'financemanagerid': financeManagerId.toString(),
      'residentid': residentid.toString(),
      'duedate': dueDate.toString(),
      'billstartdate': billStartDate.toString(),
      'billenddate': billEndDate.toString(),
      'status': "unpaid",
      'paymenttype': 'NA',
      'billtype': billtype.toString(),
      'latecharges': latecharges.toString(),
      'tax': tax.toString(),
      'isbilllate': 0.toString(),
      //'bill_items': billItemsJson,
    };

    // Add the bill_items directly to the data map
    for (int i = 0; i < bill_items.length; i++) {
      data['bill_items[$i][billname]'] = bill_items[i]['billname'];
      data['bill_items[$i][billprice]'] = bill_items[i]['billprice'].toString();

      print(data['bill_items[$i][billname]']);
      print(data['bill_items[$i][billprice]']);
    }

    individualBillRepository
        .generateIndividualBillApi(bearerToken: bearerToken, data: data)
        .then((value) {
      loading = false;
      update();

      if (kDebugMode) {
        print(value);
        Get.snackbar('Message', value, backgroundColor: Colors.white);
        setResponseStatus(Status.completed);
        Get.back();
      }
    }).onError((error, stackTrace) {
      loading = false;
      update();
      setResponseStatus(Status.error);
      Get.snackbar('Error', '$error ', backgroundColor: Colors.white);
      log(error.toString());
      log(stackTrace.toString());
    });
  }
}
