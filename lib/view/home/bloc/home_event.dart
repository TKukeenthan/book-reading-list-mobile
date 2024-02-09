part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class CreateBookEvent extends HomeEvent {
  final Book book;
  CreateBookEvent(this.book);
}

class DeleteBookEvent extends HomeEvent {
  final Book book;
  DeleteBookEvent(this.book);
}

class EditBookEvent extends HomeEvent {
  final Book book;
  EditBookEvent(this.book);
}

class ChangeStatusEvent extends HomeEvent {
  final Book book;
  ChangeStatusEvent(this.book);
}

class SearchEvent extends HomeEvent {
  final String query;
  SearchEvent(this.query);
}

class FilterEvent extends HomeEvent {
  final String selectedStatus;
  FilterEvent(this.selectedStatus);
}
