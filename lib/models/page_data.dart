import 'pokemon.dart';

class HomePageData {
  /// Add as many fields as you need to keep track of the data you want to display on the screen.
  PokemanListData? data;

  HomePageData({required this.data});

  HomePageData.initial() : data = null;

  HomePageData copyWith({
    PokemanListData? data,
  }) {
    return HomePageData(data: data ?? this.data);
  }
}
