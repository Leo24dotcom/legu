import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:league/models/champion.dart';
import 'package:league/models/item.dart';

class LeagueModel extends ChangeNotifier{
  String selectedType = 'All';
  String selectedItemType = 'All';
  bool isLoading = true;
  String? error;
  List<Champion> champions = [];
  List<Item> items = [];
  String? version;

  Future<void> loadChampions() async {
  try {
    version = await fetchLatestVersion();
    champions = await fetchChampionList(version!);
    items = (await fetchItems(version!))
        .where((item) => item.isOnSummonersRift)
        .toList();
    notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<String> fetchLatestVersion() async {
    final uri = Uri.parse(
      'https://ddragon.leagueoflegends.com/api/versions.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw const HttpException('Failed to get versions');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.first as String;
  }

  Future<List<Champion>> fetchChampionList(String version) async {
    final uri = Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$version/data/en_US/champion.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw const HttpException('Failed to get champions');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>;

    return data.values
        .map((v) => Champion.fromMap(v as Map<String, Object?>))
        .toList();
  }
   void selectCategory(String type) {
    selectedType = type;
    notifyListeners();
  }

  List<Champion> get filteredChampions {
    if (selectedType == 'All') return champions;
    return champions
        .where((c) => c.tags.contains(selectedType))
        .toList();
  }
  Future<List<Item>> fetchItems(String version, {String locale = 'en_US'}) async {
    final url = Uri.parse(
      'https://ddragon.leagueoflegends.com/cdn/$version/data/$locale/item.json',
    );
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch items: ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;

    return data.entries
        .map((entry) => Item.fromMap(entry.key, entry.value as Map<String, dynamic>))
        .toList();
  }
  void selectItemCategory(String type) {
    selectedItemType = type;
    notifyListeners();
  }

  List<Item> get filteredItem {
    if (selectedType == 'All') return items;
    return items
        .where((c) => c.tags.contains(selectedItemType))
        .toList();
  }
}
