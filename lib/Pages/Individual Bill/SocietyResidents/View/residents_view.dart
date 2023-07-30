import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartgatefinance/Constants/size_box.dart';
import 'package:smartgatefinance/Routes/set_routes.dart';

import '../../../../Constants/colors.dart';
import '../../../../Data/Api Resp/api_response.dart';
import '../../../../Widgets/Loader/loader.dart';
import '../../../../Widgets/My App Bar/my_app_bar.dart';

import '../../../Bill Page/Widgets/build_data_column_status_card.dart';
import '../../../Bill Page/Widgets/build_data_column_text.dart';
import '../../../Bill Page/Widgets/build_data_row_text.dart';
import '../../../Bill Page/Widgets/custom_alert_dialog.dart';
import '../../../Bill Page/Widgets/reusable_dropdown.dart';
import '../Controller/residents_controller.dart';

class SocietyResidentsView extends GetView {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocietyResidentsController>(
        init: SocietyResidentsController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: whiteColor,
              appBar: MyAppBar(
                  title: 'Residents',
                  onTap: () {
                    Get.offNamed(homePage, arguments: controller.user);
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
      SocietyResidentsController controller, BuildContext context) {
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
                        residentid: controller.li[i].residentid,
                        Name: controller.li[i].firstname
                                .toUpperCase()
                                .toString() +
                            " " +
                            controller.li[i].lastname.toString().toUpperCase(),
                        mobileno: controller.li[i].mobileno,
                        Address:
                            controller.li[i].address.toString().toUpperCase(),
                        propertytype: controller.li[i].propertytype
                            .toUpperCase()
                            .toString(),
                        vechileno: controller.li[i].vechileno,
                        residenttype: controller.li[i].residenttype,
                        context: context,
                        index: i,
                        user: controller.user),
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
    required Name,
    required Address,
    required propertytype,
    required mobileno,
    required vechileno,
    required residenttype,
    required residentid,
    required BuildContext context,
    required index,
    required user,
  }) {
    return DataRow(
      color: MaterialStateProperty.resolveWith(
          (states) => index % 2 == 0 ? HexColor('#FDFDFD') : null),
      cells: <DataCell>[
        DataCell(BuildDataRowText(text: Name ?? "")),
        DataCell(BuildDataRowText(text: Address ?? "")),
        DataCell(BuildDataRowText(text: mobileno ?? "")),
        DataCell(BuildDataRowText(text: propertytype ?? "")),
        DataCell(BuildDataRowText(text: vechileno ?? "")),
        DataCell(BuildDataRowText(text: residenttype ?? "")),
        DataCell(
            BuildDataColumnStatusCard(
                height: 40.h,
                width: 100.w,
                text: "generate bill",
                color: Colors.orange), onTap: () {
          Get.offNamed(individualBillView,
              arguments: [user, residentid, propertytype]);
        })
      ],
    );
  }

  Row _buildSearchBarRow(
      SocietyResidentsController controller, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextField(
            style: GoogleFonts.inder(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                fontStyle: FontStyle.normal,
                color: HexColor('#000000')),
            controller: controller.searchController,
            onChanged: (value) => controller.debounce(
              () async {
                controller.searchQuery = value.toString();
                if (controller.searchQuery!.isEmpty) {
                  controller.viewAllResidentsApi(
                      subAdminId: controller.user.data!.subadminid,
                      bearerToken: controller.user.bearer.toString());
                } else {
                  controller.searchResidentApi(
                      search: controller.searchQuery,
                      bearerToken: controller.user.bearer,
                      subAdminId: controller.user.data!.subadminid);
                }
              },
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
              filled: true,
              //<-- SEE HERE
              fillColor: HexColor("#F7F8FA"),

              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Search',
              hintStyle: GoogleFonts.inder(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: HexColor('#ACACAC')),
              suffixIcon: InkWell(
                child: const Icon(Icons.cancel),
                onTap: () {
                  if (controller.searchController.text.isEmpty) {
                    print("empty");
                  } else {
                    controller.searchController.clear();

                    controller.viewAllResidentsApi(
                        subAdminId: controller.user.data!.subadminid,
                        bearerToken: controller.user.bearer.toString());
                  }
                },
              ),
              prefixIcon: const Icon(
                Icons.search,
              ),
              suffixIconColor: HexColor('#AFAFAF'),
              prefixIconColor: HexColor('#AFAFAF'),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: InkWell(
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
                ))),
        IconButton(
          iconSize: 30,
          tooltip: 'Resfresh',
          icon: const Icon(
            Icons.refresh,
            color: Colors.green,
          ),
          onPressed: () {
            controller.searchController.clear();
            controller.viewAllResidentsApi(
                subAdminId: controller.user.data!.subadminid,
                bearerToken: controller.user.bearer.toString());
          },
        )
      ],
    );
  }

  GetBuilder<SocietyResidentsController> _filterDialog(BuildContext context) {
    return GetBuilder<SocietyResidentsController>(
        init: SocietyResidentsController(),
        builder: (controller) {
          return CustomAlertDialog(
            context: context,
            icon: Icons.filter_list_outlined,
            positiveButtonColor: primaryColor,
            titleText: 'Filters',
            positiveButtonText: 'Filters',
            negativeButtonText: 'Clear',
            onTapNegative: () {
              controller.viewAllResidentsApi(
                  subAdminId: controller.user.data!.subadminid,
                  bearerToken: controller.user.bearer.toString());

              Get.back();
            },
            onTapPositive: () async {
              if (controller.houseApartmentValue == null) {
                controller.viewAllResidentsApi(
                    subAdminId: controller.user.data!.subadminid,
                    bearerToken: controller.user.bearer.toString());

                Get.back();
              } else {
                controller.allResidentFilterApi(
                    bearerToken: controller.user.bearer.toString(),
                    subAdminId: controller.user.data!.subadminid.toString(),
                    propertyType: controller.houseApartmentValue.toString());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "House/Apartment",
                  style: GoogleFonts.montserrat(
                      color: primaryColor,
                      fontSize: 14.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600),
                ),
                10.h.ph,
                ReusableDropdown(
                  value: controller.houseApartmentValue,
                  items: controller.houseApartmentTypes,
                  onChanged: (value) {
                    controller.setHouseApartmentVal(value: value);
                  },
                  hint: "Filter House Apartment",
                ),
              ],
            ),
          );
        });
  }
}
