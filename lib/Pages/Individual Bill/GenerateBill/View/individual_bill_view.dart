import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartgatefinance/Constants/size_box.dart';
import 'package:smartgatefinance/Routes/set_routes.dart';
import '../../../../Constants/colors.dart';
import '../../../../Constants/validations.dart';
import '../../../../Data/Api Resp/api_response.dart';
import '../../../../Widgets/Loader/loader.dart';
import '../../../../Widgets/My App Bar/my_app_bar.dart';
import '../../../../Widgets/My Button/my_button.dart';

import '../../../../Widgets/My TextForm Field/my_textform_field.dart';
import '../../../Bill Page/Widgets/build_data_column_status_card.dart';
import '../../../Bill Page/Widgets/build_data_column_text.dart';
import '../../../Bill Page/Widgets/build_data_row_text.dart';
import '../../../Bill Page/Widgets/custom_alert_dialog.dart';
import '../../../Bill Page/Widgets/reusable_dropdown.dart';
import '../Controller/individual_bill_controller.dart';
import '../Model/IndividualBill.dart';

class IndividualBillView extends GetView {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualBillController>(
        init: IndividualBillController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: whiteColor,
              appBar: MyAppBar(
                  title: 'Individual Bill',
                  onTap: () {
                    Get.offNamed(societyResidentsView,
                        arguments: controller.user);
                  }),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 104.w),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        57.h.ph,
                        _heading(),
                        71.h.ph,
                        _buildSearchBarRow(controller, context),
                        57.h.ph,
                        if (controller.responseStatus == Status.loading)
                          Loader()
                        else if (controller.responseStatus == Status.completed)
                          _buildDataTable(controller, context)
                        else
                          const Text("SomeThing went Wrong")
                      ]),
                ),
              ));
        });
  }

  Container _buildDataTable(
      IndividualBillController controller, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: HexColor(
              '#F3F3F3',
            )),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columnSpacing: 40,
                columns: controller.dataColumnNames
                    .map((e) => _dataColumns(name: e.toString()))
                    .toList(),
                rows: [
                  for (int i = 0; i < controller.li.length; i++) ...[
                    _dataRows(
                      billName: controller.li[i].billItems,
                      billPrice: controller.li[i].billItems,
                      charges: controller.li[i].charges,
                      latecharges:
                          controller.li[i].latecharges.toString().toUpperCase(),
                      tax: controller.li[i].tax.toUpperCase().toString(),
                      balance: controller.li[i].balance,
                      payableamount: controller.li[i].payableamount,
                      totalpaidamount: controller.li[i].totalpaidamount,
                      billstartdate: controller.li[i].billstartdate,
                      billenddate: controller.li[i].billenddate,
                      duedate: controller.li[i].duedate,
                      billtype: controller.li[i].billtype,
                      paymenttype: controller.li[i].paymenttype,
                      status: controller.li[i].status,
                      context: context,
                      index: i,
                      controller: controller,
                    ),
                  ]
                ])));
  }

  Text _heading() {
    return Text(
      "Residents",
      style: GoogleFonts.montserrat(
          color: secondaryColor,
          fontSize: 40.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
    );
  }

  DataColumn _dataColumns({
    required name,
  }) {
    return DataColumn(
      label: BuildDataColumnText(text: name),
    );
  }

  DataRow _dataRows({
    required List<dynamic> billName,
    required List<dynamic> billPrice,
    required charges,
    required latecharges,
    required tax,
    required balance,
    required payableamount,
    required totalpaidamount,
    required billstartdate,
    required billenddate,
    required duedate,
    required billtype,
    required paymenttype,
    required status,
    required BuildContext context,
    required index,
    required IndividualBillController controller,
  }) {
    return DataRow(
      color: MaterialStateProperty.resolveWith(
          (states) => index % 2 == 0 ? HexColor('#FDFDFD') : null),
      cells: <DataCell>[
        DataCell(Container(
          width: 200.w,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.li.length,
            itemBuilder: (context, itemIndex) {
              IndividualBills individualBill = controller.li[itemIndex];

              List<BillItems> billItems = individualBill.billItems;

              List<String> billNames =
                  billItems.map((billItem) => billItem.billname).toList();

              String billNamesString = billNames.join(", ");

              return Text(billNamesString);
            },
          ),
        )),
        DataCell(Container(
          width: 200.w,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.li.length,
            itemBuilder: (context, itemIndex) {
              IndividualBills individualBill = controller.li[itemIndex];

              List<BillItems> billItems = individualBill.billItems;

              List<String> billPrices =
                  billItems.map((billItem) => billItem.billprice).toList();

              String billPricesString = billPrices.join(", ");

              return Text(billPricesString);
            },
          ),
        )),
        DataCell(BuildDataRowText(text: charges ?? "")),
        DataCell(BuildDataRowText(text: latecharges ?? "")),
        DataCell(BuildDataRowText(text: tax ?? "")),
        DataCell(BuildDataRowText(text: balance ?? "")),
        DataCell(BuildDataRowText(text: payableamount ?? "")),
        DataCell(BuildDataRowText(text: totalpaidamount ?? "")),
        DataCell(BuildDataRowText(text: billstartdate ?? "")),
        DataCell(BuildDataRowText(text: billenddate ?? "")),
        DataCell(BuildDataRowText(text: duedate ?? "")),
        DataCell(BuildDataRowText(text: billtype ?? "")),
        DataCell(BuildDataRowText(text: paymenttype ?? "")),
        DataCell(BuildDataRowText(text: status ?? "")),
      ],
    );
  }

  Row _buildSearchBarRow(
      IndividualBillController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return _generateBillDialog(context);
                });
          },
          child: BuildDataColumnStatusCard(
              height: 60.h,
              width: 150.w,
              text: "generate bill",
              color: Colors.orange),
        ),
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _filterDialog(context);
                  });
            },
            child: SvgPicture.asset(
              'assets/bill_page_filter.svg',
              color: HexColor('#AFAFAF'),
            )),
        IconButton(
          iconSize: 30,
          tooltip: 'Resfresh',
          icon: const Icon(
            Icons.refresh,
            color: Colors.green,
          ),
          onPressed: () {
            controller.searchController.clear();
            controller.viewIndividualBillApi(
                subAdminId: controller.user.data!.subadminid,
                bearerToken: controller.user.bearer.toString());
          },
        )
      ],
    );
  }

  GetBuilder<IndividualBillController> _filterDialog(BuildContext context) {
    return GetBuilder<IndividualBillController>(
        init: IndividualBillController(),
        builder: (controller) {
          return CustomAlertDialog(
            context: context,
            icon: Icons.filter_list_outlined,
            positiveButtonColor: primaryColor,
            titleText: 'Filters',
            positiveButtonText: 'Filters',
            negativeButtonText: 'Clear',
            onTapNegative: () {
              controller.viewIndividualBillApi(
                  subAdminId: controller.user.data!.subadminid,
                  bearerToken: controller.user.bearer.toString());

              Get.back();
            },
            onTapPositive: () async {
              if (controller.startDate == "" &&
                  controller.statusVal == null &&
                  controller.paymentTypeValue == null) {
                controller.viewIndividualBillApi(
                    subAdminId: controller.user.data!.subadminid,
                    bearerToken: controller.user.bearer.toString());
                Get.back();
              } else {
                controller.filterBillsApi(
                    bearerToken: controller.user.bearer.toString(),
                    subAdminId: controller.user.data!.subadminid.toString(),
                    // financeManagerId:
                    //     controller.billPageController.user.data!.id,

                    startDate: controller.startDate.toString(),
                    endDate: controller.endDate.toString(),
                    status: controller.statusVal.toString(),
                    paymentType: controller.paymentTypeValue.toString());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Start Date',
                          style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontSize: 14.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          controller.startDate.toString() ??
                              'Select Start Date',
                          style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () => controller.selectDate(context),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'End Date',
                          style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontSize: 14.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          controller.endDate.toString() ?? 'Select End Date',
                          style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () => controller.selectEndDate(context),
                      ),
                    ),
                  ],
                ),
                20.h.ph,
                Text(
                  "PaymentType",
                  style: GoogleFonts.montserrat(
                      color: primaryColor,
                      fontSize: 14.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                ),
                10.h.ph,
                ReusableDropdown(
                  value: controller.paymentTypeValue,
                  items: controller.paymentTypes,
                  onChanged: (value) {
                    controller.setPaymentTypeVal(value: value);
                  },
                  hint: "Select Payment Method",
                ),
                20.h.ph,
                Text(
                  "StatusType",
                  style: GoogleFonts.montserrat(
                      color: primaryColor,
                      fontSize: 14.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                ),
                10.h.ph,
                ReusableDropdown(
                    value: controller.statusVal,
                    items: controller.statusTypes,
                    onChanged: (value) {
                      controller.setStatusTypeVal(value: value);
                    },
                    hint: 'Select Status Type')
              ],
            ),
          );
        });
  }

  GetBuilder<IndividualBillController> _generateBillDialog(
      BuildContext context) {
    return GetBuilder<IndividualBillController>(
        init: IndividualBillController(),
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: CustomAlertDialog(
              context: context,
              icon: Icons.filter_list_outlined,
              positiveButtonColor: primaryColor,
              titleText: 'Generate Bill',
              positiveButtonText: 'Generate',
              negativeButtonText: 'Clear',
              loading: controller.loading,
              onTapNegative: () {
                controller.viewIndividualBillApi(
                    subAdminId: controller.user.data!.subadminid,
                    bearerToken: controller.user.bearer.toString());

                Get.back();
              },
              onTapPositive: () async {
                if (controller.loading == false) {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.startDate == null) {
                      Get.snackbar('Date', 'Please Select Start Date',
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else if (controller.endDate == null) {
                      Get.snackbar('Date', 'Please Select End Date',
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else if (controller.dueDate == null) {
                      Get.snackbar('Date', 'Please Select Due Date',
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      controller.generateIndividualBillApi(
                          subAdminId: controller.user.data!.subadminid,
                          financeManagerId: controller.user.data!.id,
                          dueDate: controller.dueDate,
                          billStartDate: controller.startDate,
                          billEndDate: controller.endDate,
                          bearerToken: controller.user.bearer,
                          residentid: controller.residentid,
                          //propertyid: propertyid,
                          billtype: controller.propertyType,
                          latecharges: controller.lateChargesController.text,
                          tax: controller.taxPriceController.text,
                          bill_items: controller.billItems.map((item) => item.toJson()).toList(),

                          );
                    }
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: controller.addItemformKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: controller.billNameController,
                            suffixIcon: const Icon(Icons.add_task),
                            fillColor: Colors.white,
                            validator: emptyStringValidator,
                            hintText: 'Bill Name',
                            labelText: 'Bill Name',
                          ),
                          20.ph,
                          MyTextFormField(
                            controller: controller.billPriceController,
                            suffixIcon: const Icon(Icons.price_change),
                            fillColor: Colors.white,
                            validator: emptyStringValidator,
                            hintText: 'Bill Price',
                            labelText: 'Bill Price',
                          ),
                          20.ph,
                          MyButton(
                            loading: controller.loading,
                            name: 'Add Item',
                            height: 60.h,
                            width: 200.w,
                            maxLines: 2,
                            onPressed: () async {
                              if (!controller.loading) {
                                if (controller.addItemformKey.currentState!
                                    .validate()) {
                                  controller.addBillItem();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Display the entered bill items
                    20.ph,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.billItems.map((billItem) {
                        return Text(
                          '${billItem.billname}: \$${billItem.billprice}',
                          style: GoogleFonts.montserrat(
                              color: primaryColor,
                              fontSize: 24.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700),
                        );
                      }).toList(),
                    ),
                    20.ph,
                    MyTextFormField(
                      controller: controller.taxPriceController,
                      suffixIcon:
                          const Icon(Icons.account_balance_wallet_sharp),
                      fillColor: Colors.white,
                      validator: emptyStringValidator,
                      hintText: 'Tax',
                      labelText: 'Tax',
                    ),

                    20.ph, 20.ph,
                    MyTextFormField(
                      controller: controller.lateChargesController,
                      suffixIcon: const Icon(Icons.assignment_late),
                      fillColor: Colors.white,
                      validator: emptyStringValidator,
                      hintText: 'Late Charges',
                      labelText: 'Late Charges',
                    ),

                    20.ph,

                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Bill Start Date',
                              style: GoogleFonts.montserrat(
                                  color: primaryColor,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              controller.startDate.toString() ??
                                  'Select Start Date',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            onTap: () => controller.selectDate(context),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Bill End Date',
                              style: GoogleFonts.montserrat(
                                  color: primaryColor,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              controller.endDate.toString() ??
                                  'Select End Date',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            onTap: () => controller.selectEndDate(context),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Bill Due Date',
                              style: GoogleFonts.montserrat(
                                  color: primaryColor,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              controller.dueDate.toString() ??
                                  'Select Due Date',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600),
                            ),
                            onTap: () => controller.selectDueDate(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
