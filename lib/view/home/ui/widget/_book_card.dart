import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_reading_list/data/app_color.dart';
import 'package:book_reading_list/data/app_size.dart';
import 'package:book_reading_list/view/home/bloc/home_bloc.dart';
import 'package:book_reading_list/view/home/ui/widget/_edit_book.dart';
import 'package:book_reading_list/view/home/ui/widget/_show_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../../../../model/book_model.dart';
import '_status_popup.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final HomeBloc bloc;
  const BookCard({super.key, required this.book, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(150, context),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 150 / 240,
            child: GestureDetector(
              onTap: () {
                showAnimatedDialog(
                  barrierColor: const Color.fromARGB(111, 42, 41, 41),
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return ShowBook(
                      book: book,
                      bloc: bloc,
                    );
                  },
                  animationType: DialogTransitionType.slideFromTop,
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColor.primaryGray),
                    image: DecorationImage(
                        image: NetworkImage(
                            book.image ?? 'https://picsum.photos/250?image=9'),
                        fit: BoxFit.cover,
                        opacity: 0.3)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: screenWidth(140, context),
                    height: 60,
                    child: Column(
                      children: [
                        AutoSizeText(
                          book.title,
                          maxLines: 2,
                          maxFontSize: 16,
                          minFontSize: 10,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(book.author,
                            maxLines: 1,
                            maxFontSize: 16,
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 2, right: 10, child: _sideButtons(context)),
          Positioned(top: 16, left: 16, child: _statusButton(context))
        ],
      ),
    );
  }

  Widget _statusButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String status = '';
        if (book.status == 'Start') {
          status = 'Reading..';
        } else if (book.status == 'Reading..') {
          status = 'Complete';
        } else {
          status = 'Reading..';
        }
        showDialog(
            context: context,
            builder: (_) => StatusPopUp(
                  status: status,
                  bloc: bloc,
                  book: book,
                ));
      },
      child: Container(
        width: screenWidth(60, context),
        height: 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.primaryGray),
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 4.0, bottom: 4, right: 12, left: 12),
            child: Text(book.status ?? 'Start'),
          ),
        ),
      ),
    );
  }

  Widget _sideButtons(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            showAnimatedDialog(
              barrierColor: const Color.fromARGB(111, 42, 41, 41),
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return ShowBook(
                  book: book,
                  bloc: bloc,
                );
              },
              animationType: DialogTransitionType.slideFromTop,
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 500),
            );
          },
          icon: Icon(
            Icons.remove_red_eye,
            color: AppColor.iconColor,
          ),
        ),
        IconButton(
            onPressed: () {
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
            icon: Icon(Icons.edit, color: AppColor.iconColor)),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => deletePopUp(context));
            },
            icon: Icon(Icons.delete, color: AppColor.iconColor))
      ],
    );
  }

  Widget deletePopUp(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: screenWidth(300, context),
          height: screenHeight(300, context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.cardColor),
          child: Column(
            children: [
              AppSize.h16,
              Container(
                height: screenHeight(80, context),
                width: screenWidth(80, context),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                child: Icon(Icons.warning),
              ),
              AppSize.h16,
              Text(
                'Are You Sure ?',
                style: TextStyle(color: AppColor.primaryWhite, fontSize: 20),
              ),
              AppSize.h8,
              SizedBox(
                width: screenWidth(260, context),
                child: Text(
                  'This Book Will be Remove From This List',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.primaryWhite, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    button(context, 'Cencel', Colors.blue, () {
                      Navigator.pop(context);
                    }),
                    button(context, 'Delete', Colors.red, () {
                      bloc.add(DeleteBookEvent(book));
                      Navigator.pop(context);
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button(
      BuildContext context, String text, Color color, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth(100, context),
        height: screenHeight(40, context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
