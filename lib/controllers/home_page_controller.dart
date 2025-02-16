import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemansdex/models/page_data.dart';
import 'package:pokemansdex/models/pokemon.dart';

import '../service/http_service.dart';

/// Controls the Pokemon list data and pagination
/// Uses StateNotifier to manage the list state and handle pagination
class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HTTPService _httpService;

  /// Initializes the controller with HTTP service and loads initial data
  HomePageController(super._state) {
    // Access the HTTP Service
    _httpService = _getIt.get<HTTPService>();
    _setup();
  }

  /// Initial setup and data loading
  Future<void> _setup() async {
    loadData();
  }

  /// Loads Pokemon data with pagination support
  ///
  /// If state.data is null, loads initial 20 Pokemon
  /// Otherwise, loads the next page using the 'next' URL from the API
  /// Updates state by either replacing or appending the new data
  Future<void> loadData() async {
    if (state.data == null) {
      // First time
      Response? response = await _httpService
          .get("https://pokeapi.co/api/v2/pokemon?limit=20&offset=0");
      if (response != null && response.data != null) {
        PokemanListData data = PokemanListData.fromJson(response.data);
        // Update the state of the StateNotifier
        state = state.copyWith(data: data);
      }
      print(state.data?.results?.first);
    } else {
      // Go to the next url
      if (state.data?.next != null) {
        Response? response = await _httpService.get(state.data!.next!);
        if (response != null && response.data != null) {
          PokemanListData data = PokemanListData.fromJson(response.data);
          // Update the state of the StateNotifier
          // While adding the old data + the new data
          state = state.copyWith(
            data: data.copyWith(
              results: [...?state.data?.results, ...?data.results],
            ),
          );
        }
      }
    }
  }
}
