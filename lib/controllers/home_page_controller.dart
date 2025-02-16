import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemansdex/models/page_data.dart';
import 'package:pokemansdex/models/pokemon.dart';

import '../service/http_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;
  late HTTPService _httpService;

  HomePageController(super._state) {
    // Access the HTTP Service
    _httpService = _getIt.get<HTTPService>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

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
