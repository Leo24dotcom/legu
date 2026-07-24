import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:league/models/champion.dart';

class LeagueModel extends ChangeNotifier{
  String selectedType = 'All';
  bool isLoading = true;
  String? error;
  List<Champion> champions = [];
  String? version;

  Future<void> loadChampions() async {
  try {
    version = await fetchLatestVersion();
    champions = await fetchChampionList(version!);
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


}
