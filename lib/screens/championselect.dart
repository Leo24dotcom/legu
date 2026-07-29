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
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text('Champion Select', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
        ),
      leading: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) => ItemScreen(leagueModel: leagueModel,) ));
        },
        child: Text('Item Shop'),)
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: leagueModel, 
          builder: (context, _) => Column(
          children: [
          SearchBar(
            hintText: 'Search da champion',
            onChanged: (value) => runFilter(value),
            leading: const Icon(Icons.search)
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


