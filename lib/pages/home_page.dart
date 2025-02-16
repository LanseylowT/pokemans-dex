import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemansdex/controllers/home_page_controller.dart';
import 'package:pokemansdex/models/pokemon.dart';
import 'package:pokemansdex/widgets/pokeman_card.dart';
import 'package:pokemansdex/widgets/pokeman_list_tile.dart';

import '../models/page_data.dart';
import '../providers/pokeman_data_provider.dart';

// Create the provider
final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemanListsScrollController = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritePokemans;

  @override
  void initState() {
    _allPokemanListsScrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _allPokemanListsScrollController.removeListener(_scrollListener);
    _allPokemanListsScrollController.dispose();
    super.dispose();
  }

  // Pagination
  void _scrollListener() {
    if (_allPokemanListsScrollController.offset >=
            _allPokemanListsScrollController.position.maxScrollExtent &&
        !_allPokemanListsScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemans = ref.watch(favoritePokemansProvider);

    return Scaffold(
      body: _buildUI(context),
    );
  }

  _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemansList(context),
              _allPokemansList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allPokemansList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemans",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                controller: _allPokemanListsScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemanListResult pokeman =
                      _homePageData.data!.results![index];
                  return PokemanListTile(pokemanUrl: pokeman.url!);
                }),
          ),
        ],
      ),
    );
  }

  Widget _favoritePokemansList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorites",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemans.isEmpty)
                  const Text("No Favorite Pokemans yet! :("),
                if (_favoritePokemans.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: _favoritePokemans.length,
                      itemBuilder: (context, index) {
                        String pokemanUrl = _favoritePokemans[index];
                        return PokemanCard(pokemanUrl: pokemanUrl);
                      },
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
