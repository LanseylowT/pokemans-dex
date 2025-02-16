import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokeman_data_provider.dart';

class PokemanStatsCard extends ConsumerWidget {
  final String pokemanUrl;

  const PokemanStatsCard({super.key, required this.pokemanUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokeman = ref.watch(pokemanDataProvider(pokemanUrl));
    return AlertDialog(
      title: const Text("Statistics"),
      content: pokeman.when(data: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data?.stats?.map((stat) {
                return Text("${stat.stat?.name?.toUpperCase()}: ${stat.baseStat}");
              }).toList() ??
              [],
        );
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return CircularProgressIndicator();
      }),
    );
  }
}
