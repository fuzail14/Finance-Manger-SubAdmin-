import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildDataColumnStatusCard extends StatelessWidget {
  final String? text;
  final Color color;
  final double? height;
  final double? width;
  

  const BuildDataColumnStatusCard({super.key, this.text, this.height,this.width,  required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 40.w,
        width: width ?? 80.w,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8.r)),
        child: Center(
            child: Text(text!,
                style: GoogleFonts.inder(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
                textAlign: TextAlign.center)));
  }
}
