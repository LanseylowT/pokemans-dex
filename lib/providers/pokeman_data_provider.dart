import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemansdex/models/pokemon.dart';
import 'package:pokemansdex/service/database_services.dart';
import 'package:pokemansdex/service/http_service.dart';

final pokemanDataProvider =
    FutureProvider.family<Pokeman?, String>((ref, url) async {
  HTTPService httpService = GetIt.instance.get<HTTPService>();
  Response? response = await httpService.get(url);

  if (response != null && response.data != null) {
    return Pokeman.fromJson(response.data);
  }
  return null;
});

final favoritePokemansProvider =
    StateNotifierProvider<FavoritePokemansProvider, List<String>>((ref) {
  return FavoritePokemansProvider([]);
});

class FavoritePokemansProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService = GetIt.instance.get<DatabaseService>();
  String FAVORITE_POKEMAN_LIST_KEY = 'FAVORITE_POKEMAN_LIST_KEY';
  FavoritePokemansProvider(super._state) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result = await _databaseService.getList(FAVORITE_POKEMAN_LIST_KEY);
    state = result ?? [];
  }

  // Add a favorite pokeman
  void addFavoritePokeman(String pokemanUrl) {
    state = [...state, pokemanUrl];
    _databaseService.saveList(FAVORITE_POKEMAN_LIST_KEY, state);
  }

  void removeFavoritePokeman(String pokemanUrl) {
    state = state.where((e) => e != pokemanUrl).toList();
    _databaseService.saveList(FAVORITE_POKEMAN_LIST_KEY, state);
  }
}
