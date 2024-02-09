import 'package:book_reading_list/data/app_color.dart';
import 'package:book_reading_list/data/app_size.dart';
import 'package:book_reading_list/model/book_model.dart';
import 'package:book_reading_list/view/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

class EditBook extends StatelessWidget {
  final HomeBloc bloc;
  final Book book;
  const EditBook({super.key, required this.bloc, required this.book});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController publishYearController = TextEditingController();
    TextEditingController isbnController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController genreController = TextEditingController();
    imageController.text = book.image ??
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/495px-No-Image-Placeholder.svg.png?20200912122019';
    titleController.text = book.title;
    authorController.text = book.author;
    publishYearController.text = '${book.publishYear ?? 0}';
    isbnController.text = book.isbn ?? '';
    noteController.text = book.note ?? '';
    genreController.text = book.genre ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: screenWidth(330, context),
          height: screenHeight(600, context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.cardColor),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Book',
                      style:
                          TextStyle(color: AppColor.primaryWhite, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColor.primaryWhite,
                      ),
                    )
                  ],
                ),
                const Divider(),
                AppSize.h16,
                _textField(
                    context, 'Text *', 'Enter Book Title ', titleController, 1),
                _textField(context, 'Author *', 'Enter Author Name ',
                    authorController, 1),
                _textField(context, 'Publish Year', 'Enter Publish Year ',
                    publishYearController, 1),
                _textField(context, 'Genre', 'Enter Publish Year ',
                    genreController, 1),
                _textField(
                    context, 'ISBN', 'Enter ISBN Number ', isbnController, 1),
                _textField(context, 'Note', 'Enter Small Discription ',
                    noteController, 2),
                _textField(
                    context, 'Image', 'Enter Image Url ', imageController, 1),
                _submitButton(context, () {
                  bloc.add(EditBookEvent(Book(
                      title: titleController.text,
                      author: authorController.text,
                      publishYear: int.parse(publishYearController.text.trim()),
                      isbn: isbnController.text,
                      note: noteController.text,
                      image: imageController.text,
                      id: book.id,
                      status: book.status,
                      genre: genreController.text,
                      completeDate: book.completeDate)));
                })
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(BuildContext context, String title, String hint,
      TextEditingController controller, int maxLine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        AppSize.h8,
        Container(
          width: screenWidth(260, context),
          // height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
              border: Border.all(color: AppColor.primaryGray)),
          child: TextField(
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColor.primaryGray, fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8),
            ),
            style: TextStyle(color: AppColor.primaryWhite),
            onChanged: (value) {},
          ),
        ),
        AppSize.h16
      ],
    );
  }

  Widget _submitButton(BuildContext context, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth(160, context),
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.accentColor),
        child: const Center(
            child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
