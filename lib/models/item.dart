import 'dart:convert';
import 'package:http/http.dart' as http;

enum ItemRarity{
  start,
  basic,
  epic,
  leg,
}

class Item {
  final String id;
  final String name;
  final String description;
  final int total;
  final int base;
  final int sell;
  final Map<String, dynamic> stats;
  final String sprite;
  final List<String> tags;
  final Map<String, bool> maps;
  final bool purchasable;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.total,
    required this.base,
    required this.sell,
    required this.stats,
    required this.sprite,
    required this.tags,
    required this.maps,
    required this.purchasable,
  });

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    final gold = map['gold'] as Map<String, dynamic>;
    return Item(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      total: gold['total'] as int,
      base: gold['base'] as int,
      sell: gold['sell'] as int,
      stats: Map<String, dynamic>.from(map['stats'] as Map? ?? {}),
      sprite: (map['image'] as Map<String, dynamic>)['full'] as String,
      tags: (map['tags'] as List?)?.cast<String>() ?? [],
      maps: Map<String, bool>.from(map['maps'] as Map? ?? {}),
      purchasable: gold['purchasable'] as bool,
    );
  }
  bool get isOnSummonersRift => maps['11'] == true;
  bool get isPurchasable => purchasable == true;

  static const Set<String> _starterItemIds = {
    '1054', // Doran's Shield
    '1055', // Doran's Blade
    '1056', // Doran's Ring
    '1082', // Dark Seal
    '1083', // Cull
    '2003', // Health Potion
    '2031', // Refillable Potion
    '1086', // Doran's Bow
    '1120', // Doran's Helm
  };

  bool get isStarterItem => _starterItemIds.contains(id);

  ItemRarity get rarity {
    if (isStarterItem) return ItemRarity.start;
    if (total >= 2500) return ItemRarity.leg;
    if (total >= 1000) return ItemRarity.epic;
    return ItemRarity.basic;
  }

}