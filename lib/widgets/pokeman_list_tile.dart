import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemansdex/models/pokemon.dart';
import 'package:pokemansdex/providers/pokeman_data_provider.dart';
import 'package:pokemansdex/widgets/pokeman_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemanListTile extends ConsumerWidget {
  final String pokemanUrl;

  late FavoritePokemansProvider _favoritePokemansProvider;
  late List<String> _favoritePokemans;

  PokemanListTile({super.key, required this.pokemanUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the Pokeman data from the provider
    final pokeman = ref.watch(pokemanDataProvider(pokemanUrl));
    _favoritePokemansProvider = ref.watch(favoritePokemansProvider.notifier);
    _favoritePokemans = ref.watch(favoritePokemansProvider);
    return pokeman.when(
      data: (data) {
        return _tile(context, false, data);
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokeman? pokeman) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemanStatsCard(pokemanUrl: pokemanUrl);
                });
          }
        },
        child: ListTile(
          leading: pokeman != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokeman.sprites!.frontDefault!),
                )
              : CircleAvatar(backgroundColor: Colors.grey),
          title: Text(
            pokeman != null
                ? pokeman.name!.toUpperCase()
                : 'Currently loading name for Pokeman',
          ),
          subtitle: Text("Has ${pokeman?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
            onPressed: () {
              // Check if the pokeman is already in the favorites
              if (_favoritePokemans.contains(pokemanUrl)) {
                _favoritePokemansProvider.removeFavoritePokeman(pokemanUrl);
              } else {
                _favoritePokemansProvider.addFavoritePokeman(pokemanUrl);
              }
            },
            icon: Icon(
              _favoritePokemans.contains(pokemanUrl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
