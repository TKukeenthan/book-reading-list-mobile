import 'package:book_reading_list/data/app_color.dart';
import 'package:book_reading_list/data/app_size.dart';
import 'package:book_reading_list/view/home/bloc/home_bloc.dart';
import 'package:book_reading_list/view/home/ui/widget/_create_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/_book_card.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc(context);
    homeBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeInitial) {
          return loadingScaffold();
        } else if (state is HomeSuccsessState) {
          return mainScaffold(context, state);
        } else if (state is HomeErrorState) {
          return Text(state.error);
        } else {
          return Container();
        }
      },
    );
  }

  Scaffold loadingScaffold() => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );

  Widget mainScaffold(BuildContext context, HomeSuccsessState state) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: AppColor.cardColor,
          title: const Center(
            child: Text(
              'Book List',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildSearchField(context),
                          buildFilter(context),
                        ],
                      ),
                      AppSize.h16,
                      SingleChildScrollView(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 150 / 240,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount:
                              state.book.length, // Use filtered book list
                          itemBuilder: (context, index) {
                            return BookCard(
                              book: state.book[index], // Use filtered book list
                              bloc: homeBloc,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  showAnimatedDialog(
                    barrierColor: const Color.fromARGB(111, 42, 41, 41),
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return CreateBook(
                        bloc: homeBloc,
                      );
                    },
                    animationType: DialogTransitionType.slideFromTop,
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.accentColor,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    weight: 3,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilter(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'All',
            child: Text('All'),
          ),
          const PopupMenuItem<String>(
            value: 'Start',
            child: Text('Start'),
          ),
          const PopupMenuItem<String>(
            value: 'Reading..',
            child: Text('Reading..'),
          ),
          const PopupMenuItem<String>(
            value: 'Complete',
            child: Text('Complete'),
          ),
        ];
      },
      child: Container(
        width: screenWidth(120, context),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor.cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  homeBloc.selectedStatus,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      onSelected: (String value) {
        homeBloc.add(FilterEvent(value.trim()));
      },
    );
  }

  Widget buildSearchField(BuildContext context) {
    return Container(
      width: screenWidth(200, context),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.cardColor,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search ',
          prefixIcon: const Icon(Icons.search),
          hintStyle: TextStyle(color: AppColor.primaryGray, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
        style: TextStyle(color: AppColor.primaryWhite),
        onChanged: (query) {
          homeBloc.add(SearchEvent(query));
        },
      ),
    );
  }
}
