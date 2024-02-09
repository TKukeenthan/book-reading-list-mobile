import 'package:bloc/bloc.dart';
import 'package:book_reading_list/data/app_services.dart/app_service.dart';
import 'package:book_reading_list/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildContext context;
  HomeBloc(this.context) : super(HomeInitial()) {
    on<HomeInitialEvent>(fetchData);
    on<CreateBookEvent>(createBook);
    on<DeleteBookEvent>(deleteBook);
    on<EditBookEvent>(editBook);
    on<SearchEvent>(searchBook);
    on<FilterEvent>(filterBook);
  }
  List<Book> _bookList = [];
  List<Book> get bookList => _bookList;
  Future<void> fetchData(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitial());
    try {
      _bookList = await AppService.fetchBooks();
      emit(HomeSuccsessState(_bookList));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> createBook(
      CreateBookEvent event, Emitter<HomeState> emit) async {
    try {
      await AppService.postBook(event.book).then((value) {
        add(HomeInitialEvent());
        Navigator.pop(context);
      });
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> deleteBook(
      DeleteBookEvent event, Emitter<HomeState> emit) async {
    try {
      await AppService.deleteBook(event.book).then((value) {
        add(HomeInitialEvent());
      });
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<void> editBook(EditBookEvent event, Emitter<HomeState> emit) async {
    try {
      await AppService.editBook(event.book).then((value) {
        add(HomeInitialEvent());
        Navigator.pop(context);
        print(value);
      });
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }

  List<Book> _filterBookList = [];
  Future<void> searchBook(SearchEvent event, Emitter<HomeState> emit) async {
    if (event.query.isNotEmpty || event.query != '') {
      _filterBookList = _bookList
          .where((book) =>
              book.title.toLowerCase().contains(event.query.toLowerCase()) ||
              book.author.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(HomeSuccsessState(_filterBookList));
    } else {
      emit(HomeSuccsessState(_bookList));
    }
  }

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  Future<void> filterBook(FilterEvent event, Emitter<HomeState> emit) async {
    _selectedStatus = event.selectedStatus;

    // If 'All' is selected, emit the original book list
    if (_selectedStatus == 'All') {
      emit(HomeSuccsessState(_bookList));
      return;
    }

    // Filter the book list based on the selected status
    _filterBookList =
        _bookList.where((book) => book.status == _selectedStatus).toList();

    // Emit the filtered book list
    emit(HomeSuccsessState(_filterBookList));
  }
}
