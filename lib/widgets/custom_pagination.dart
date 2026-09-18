import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';

class CustomPagination extends StatelessWidget {
  final Function(int?) onPageChange;
  final int totalPage;
  final int show;
  final int currentPage;
  final double lngRadius;

  const CustomPagination({
    super.key, 
    required this.onPageChange, 
    required this.totalPage, 
    required this.show, 
    required this.currentPage, 
    this.lngRadius = 40, 
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      scrollDirection: Axis.horizontal,
      child: Pagination(
        paginateButtonStyles: PaginateButtonStyles(
          backgroundColor: Color(0xff424242),
          activeBackgroundColor: Color(0XFF0e0e0e),
        ), 
        prevButtonStyles: PaginateSkipButton(
          buttonBackgroundColor: Color(0xff424242),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(lngRadius),
            bottomLeft: Radius.circular(lngRadius)
          )
        ), 
        nextButtonStyles: PaginateSkipButton(
          buttonBackgroundColor: Color(0xff424242),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(lngRadius),
            bottomRight: Radius.circular(lngRadius)
          )
        ), 
        onPageChange: onPageChange, 
        totalPage: totalPage, 
        show: show, 
        currentPage: currentPage
      ),
    );
  }
}
