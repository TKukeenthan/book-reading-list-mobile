part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccsessState extends HomeState {
  final List<Book> book;
  HomeSuccsessState(this.book);
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);
}
