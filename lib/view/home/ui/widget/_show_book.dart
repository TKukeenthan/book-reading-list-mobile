import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_reading_list/data/app_color.dart';
import 'package:book_reading_list/data/app_size.dart';
import 'package:book_reading_list/view/home/bloc/home_bloc.dart';
import 'package:book_reading_list/view/home/ui/widget/_edit_book.dart';
import 'package:book_reading_list/view/home/ui/widget/_status_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../../../../model/book_model.dart';
import 'package:intl/intl.dart';

class ShowBook extends StatelessWidget {
  final Book book;
  final HomeBloc bloc;
  const ShowBook({super.key, required this.book, required this.bloc});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';

    // Check if completeDate is available and then format it
    if (book.completeDate != null) {
      final DateTime completeDate = DateTime.parse(book.completeDate!);
      formattedDate = DateFormat('dd.MM.yyyy').format(completeDate);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _appBar(context),
              AppSize.h16,
              _imageContainer(context),
              AppSize.h16,
              _bottom(context, formattedDate),
              AppSize.h16,
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context, String formattedDate) {
    return Container(
      width: screenWidth(360, context),
      height: screenHeight(400, context),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          color: AppColor.cardColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primaryGray),
                          child: const Icon(
                            Icons.person,
                            size: 12,
                          )),
                      AppSize.w8,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth(160, context),
                            child: AutoSizeText(book.author,
                                maxLines: 1,
                                maxFontSize: 16,
                                minFontSize: 10,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          book.publishYear != null
                              ? Text(
                                  'Published on: ${book.publishYear}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          String status = '';
                          if (book.status == 'Start') {
                            status = 'Reading..';
                          } else if (book.status == 'Reading..') {
                            status = 'Complete';
                          } else {
                            status = 'Reading..';
                          }
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (_) => StatusPopUp(
                                  status: status, bloc: bloc, book: book));
                        },
                        child: Container(
                          width: screenWidth(60, context),
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primaryGray),
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 4, right: 12, left: 12),
                              child: Text(book.status ?? 'Start'),
                            ),
                          ),
                        ),
                      ),
                      book.status == 'Complete'
                          ? Text(
                              ' $formattedDate',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
              AppSize.h16,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    book.genre != null
                        ? _specification('Genre: ${book.genre}')
                        : Container(),
                    AppSize.w16,
                    book.isbn != null
                        ? _specification('ISBN: ${book.isbn}')
                        : Container(),
                  ],
                ),
              ),
              AppSize.h16,
              Text(
                book.note ?? '',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Image.network(book.image ?? ''),
                ),
              );
            });
      },
      child: Container(
        width: screenWidth(200, context),
        height: screenHeight(300, context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(book.image ?? ''), fit: BoxFit.cover)),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      width: screenWidth(360, context),
      height: screenHeight(80, context),
      decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryGray),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth(200, context),
              child: AutoSizeText(
                book.title,
                maxLines: 2,
                maxFontSize: 16,
                minFontSize: 10,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showAnimatedDialog(
                  barrierColor: const Color.fromARGB(111, 42, 41, 41),
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return EditBook(
                      bloc: bloc,
                      book: book,
                    );
                  },
                  animationType: DialogTransitionType.slideFromTop,
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.primaryGray),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _specification(String item) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.accentColor)),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 4.0, bottom: 4, right: 12, left: 12),
        child: Text(
          item,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
