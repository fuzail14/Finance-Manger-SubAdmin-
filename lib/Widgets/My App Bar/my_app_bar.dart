import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final void Function()? onTap;

  const MyAppBar({required this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      leading: GestureDetector(
        onTap: onTap ?? (){
          Get.back();
        },
        child: Icon(Icons.arrow_back)),

      title: Text(title!,
          style: GoogleFonts.montserrat(
              color: secondaryColor,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 36.sp)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
