import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemansdex/models/pokemon.dart';
import 'package:pokemansdex/service/database_services.dart';
import 'package:pokemansdex/service/http_service.dart';

/// Provides individual Pokemon data from the PokeAPI
/// Takes a Pokemon URL and returns a Future<Pokeman?>
final pokemanDataProvider =
    FutureProvider.family<Pokeman?, String>((ref, url) async {
  HTTPService httpService = GetIt.instance.get<HTTPService>();
  Response? response = await httpService.get(url);

  if (response != null && response.data != null) {
    return Pokeman.fromJson(response.data);
  }
  return null;
});

/// Provides the list of favorite Pokemon from local storage
/// Takes a List<String> and returns a StateNotifier<List<String>>
final favoritePokemansProvider =
    StateNotifierProvider<FavoritePokemansProvider, List<String>>((ref) {
  return FavoritePokemansProvider([]);
});

/// Manages the list of favorite Pokemon
/// Persists data using SharedPreferences through DatabaseService
class FavoritePokemansProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  /// Key used for storing favorites in SharedPreferences
  String FAVORITE_POKEMAN_LIST_KEY = 'FAVORITE_POKEMAN_LIST_KEY';

  /// Initializes the provider and loads saved favorites
  FavoritePokemansProvider(super._state) {
    _setup();
  }

  /// Loads saved favorites from local storage
  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVORITE_POKEMAN_LIST_KEY);
    state = result ?? [];
  }

  /// Adds a Pokemon to favorites and persists the update
  void addFavoritePokeman(String pokemanUrl) {
    state = [...state, pokemanUrl];
    _databaseService.saveList(FAVORITE_POKEMAN_LIST_KEY, state);
  }

  /// Removes a Pokemon from favorites and persists the update
  void removeFavoritePokeman(String pokemanUrl) {
    state = state.where((e) => e != pokemanUrl).toList();
    _databaseService.saveList(FAVORITE_POKEMAN_LIST_KEY, state);
  }
}
