import 'dart:convert';
import 'package:http/http.dart' as http;

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
    );
  }
  bool get isOnSummonersRift => maps['11'] == true;
}