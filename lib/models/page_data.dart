import 'pokemon.dart';

/// Data model for managing Pokemon list pagination state
class HomePageData {
  // Add as many fields as you need to keep track of the data you want to display on the screen.

  /// Contains the Pokemon list data and pagination information
  PokemanListData? data;

  /// Creates a new instance with the given data
  HomePageData({required this.data});

  /// Creates an initial empty state
  HomePageData.initial() : data = null;

  /// Creates a new instance with optional updated data
  /// Implements immutable state updates
  HomePageData copyWith({
    PokemanListData? data,
  }) {
    return HomePageData(data: data ?? this.data);
  }
}
