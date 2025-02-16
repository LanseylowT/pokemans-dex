import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemansdex/widgets/pokeman_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';
import '../providers/pokeman_data_provider.dart';

class PokemanCard extends ConsumerWidget {
  final String pokemanUrl;
  late FavoritePokemansProvider _favoritePokemansProvider;

  PokemanCard({super.key, required this.pokemanUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access pokeman data provider
    final pokeman = ref.watch(pokemanDataProvider(pokemanUrl));
    _favoritePokemansProvider = ref.watch(favoritePokemansProvider.notifier);
    return pokeman.when(
        data: (data) {
          return _card(context, false, data);
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () {
          return _card(context, true, null);
        });
  }

  Widget _card(BuildContext context, bool isLoading, Pokeman? pokeman) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(context: context, builder: (_) {
              return PokemanStatsCard(pokemanUrl: pokemanUrl);
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
              boxShadow: const [
                BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 2),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokeman?.name?.toUpperCase() ?? "Pokeman",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "#${pokeman?.id?.toString()}" ?? "Pokeman",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundImage: pokeman != null
                      ? NetworkImage(pokeman.sprites!.frontDefault!)
                      : null,
                  radius: MediaQuery.sizeOf(context).height * 0.05,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${pokeman?.moves?.length} Moves",
                    style: const TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemansProvider.removeFavoritePokeman(pokemanUrl);
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
