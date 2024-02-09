import 'package:flutter/material.dart';

import '../../../../data/app_color.dart';
import '../../../../data/app_size.dart';
import '../../../../model/book_model.dart';
import '../../bloc/home_bloc.dart'; // Import your button widget

class StatusPopUp extends StatelessWidget {
  final String status;
  final HomeBloc bloc;
  final Book book;

  const StatusPopUp({
    Key? key,
    required this.status,
    required this.bloc,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: screenWidth(300, context),
          height: screenHeight(300, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.cardColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSize.h16,
              Container(
                height: screenHeight(80, context),
                width: screenWidth(80, context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(Icons.book, size: 40, color: AppColor.primaryWhite),
              ),
              AppSize.h16,
              Text(
                'Congratulations!',
                style: TextStyle(color: AppColor.primaryWhite, fontSize: 20),
              ),
              AppSize.h8,
              SizedBox(
                width: screenWidth(260, context),
                child: Text(
                  'You $status the Book',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.primaryWhite, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: button(context, 'OK', Colors.red, () {
                  if (status == 'Complete') {
                    bloc.add(EditBookEvent(Book(
                      id: book.id,
                      title: book.title,
                      author: book.author,
                      status: status,
                      image: book.image,
                      note: book.note,
                      isbn: book.isbn,
                      genre: book.genre,
                      publishYear: book.publishYear,
                      completeDate: DateTime.now().toString(),
                    )));
                  } else {
                    bloc.add(EditBookEvent(Book(
                      id: book.id,
                      title: book.title,
                      author: book.author,
                      status: status,
                      image: book.image,
                      note: book.note,
                      isbn: book.isbn,
                      genre: book.genre,
                      publishYear: book.publishYear,
                    )));
                  }
                }),
              ),
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
