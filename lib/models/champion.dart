import 'dart:convert';
import 'package:http/http.dart' as http;

class Champion {
  final String id;
  final String key;
  final String name;
  final String title;
  final String sprite;
  final List<String> tags;
  final Map<String, dynamic> stats;
  String? lore;

  Champion({required this.id, required this.key, required this.name, required this.title, required this.sprite, required this.tags, required this.stats, this.lore});

  factory Champion.fromMap(Map<String, dynamic> map) {
    return Champion(
      id: map['id'] as String,
      key: map['key'] as String,
      name: map['name'] as String,
      title: map['title'] as String,  
      sprite: (map['image'] as Map<String, dynamic>)['full'] as String,
      tags: List<String>.from(map['tags'] as List),
      stats: Map<String, dynamic>.from(map['stats'] as Map),
    );
  }
static List<Champion> parseChampionList(String source) {
  final decoded = json.decode(source) as Map<String, dynamic>;
  final rawData = decoded['data'] as Map<String, dynamic>;
  final champions = rawData.values
    .map((v) => Champion.fromMap(v as Map<String, dynamic>))
    .toList();
  return champions;
  } 

  Future<String> fetchLore(String version) async {
    if (lore != null) return lore!;

    final res = await http.get(Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$version/data/en_US/champion/$id.json',
    ));

    final data = jsonDecode(res.body);
    lore = data['data'][id]['lore'] as String;
    return lore!;
  }

List<Ability>? spells;
Ability? passive;

Future<void> fetchAbilities(String version) async {
  if (spells != null) return;

  final res = await http.get(Uri.parse(
    'https://ddragon.leagueoflegends.com/cdn/$version/data/en_US/champion/$id.json',
  ));

  final data = jsonDecode(res.body);
  final champData = data['data'][id];

  passive = Ability.fromMap(champData['passive'] as Map<String, dynamic>);
  spells = (champData['spells'] as List)
      .map((s) => Ability.fromMap(s as Map<String, dynamic>))
      .toList();
}

}
class Ability {
  final String? id;
  final String name;
  final String description;

  Ability({required this.id, required this.name, required this.description});

  factory Ability.fromMap(Map<String, dynamic> map) {
    return Ability(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }
}