import 'package:flutter/material.dart';
import 'package:league/models/item.dart';
import 'package:league/widgets/championcard.dart';
import 'package:league/services/league_model.dart';
import 'package:league/models/champion.dart';
import 'package:league/widgets/horizontalclasslist.dart';
import 'package:league/screens/championdetail.dart';
import 'package:league/screens/itemscreen.dart';

class ChampSelectScreen extends StatefulWidget{
  const ChampSelectScreen({super.key});

  @override
  State<ChampSelectScreen> createState() => _ChampSelectScreenState();
}

class _ChampSelectScreenState extends State<ChampSelectScreen>{
  final LeagueModel leagueModel = LeagueModel();

  List<Champion> list = [];
  List<Champion> found = [];
  String type = '';
  final SearchController searchController = SearchController();
  @override
  void initState(){
    super.initState();
    leagueModel.loadChampions();
    leagueModel.addListener(sync);
  } 

  void sync(){
    list = leagueModel.filteredChampions;
    found = list;
    setState((){});
  }

  void runFilter(String enteredKeyword) {
    type = enteredKeyword;
    List<Champion> results = [];
    if(enteredKeyword.isEmpty){
      results = list;
    } else{
      results = list.where((champion) => champion.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState((){
    found = results;
  });
  }

  @override
  void dispose() {
    leagueModel.removeListener(sync);
    leagueModel.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Champion Select', style: TextStyle(
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
          ),
        ),
      leadingWidth: 85,
      leading: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) => ItemScreen(leagueModel: leagueModel,) ));
        },
        style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.black,
              side: const BorderSide(
                color: Color(0xFFFFD700),
                width: 2.0,
              )
            ),
        child: Text('Item Shop', style: TextStyle(color: Color(0xFFFFD700)),),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: leagueModel, 
          builder: (context, _) => Column(
          children: [
          SearchBar(
            hintText: 'Search da champion',
            controller: searchController,
            onChanged: (value) => runFilter(value),
            leading: const Icon(Icons.search, color: Color(0xFFFFD700),),
            backgroundColor: WidgetStateProperty.all(Colors.black),
            hintStyle: WidgetStateProperty.all(
              const TextStyle(color: Color(0xFFFFD700))
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(color: Color(0xFFFFD700))
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Color(0xFFFFD700), width: 2))
            )
          ),
          SizedBox(height: 10),
          HorizontalButtonList(leagueModel: leagueModel),
          SizedBox(height:10),
          Expanded(
            child: found.isNotEmpty ? GridView.builder(
              key: UniqueKey(),
              padding: EdgeInsets.all(12),
              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,), 
              itemCount: found.length,
              itemBuilder: (context, index){
                return Championcard(champion: found[index], version: leagueModel.version!,);
              })
            : const Center(child: Text('No Results found')),
          ),
          ]
        ),
        ),
      ),
    );
  }
}


