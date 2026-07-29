import 'package:flutter/material.dart';
import 'package:league/services/league_model.dart';
import 'package:league/models/item.dart';
import 'package:league/widgets/itemcard.dart';
import 'package:league/screens/championselect.dart';

class ItemScreen extends StatefulWidget{
  final LeagueModel leagueModel;
  const ItemScreen({super.key, required this.leagueModel});
  
  @override
  State<ItemScreen> createState() => ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {

  List<Item> list = [];
  List<Item> found = [];
  @override
  void initState(){
    super.initState();
    list = widget.leagueModel.filteredItem;
    found = list;
    widget.leagueModel.addListener(sync);
  } 

  void sync(){
    setState(() {
      list = widget.leagueModel.filteredItem;
      found = list;
    });
  }

  void runFilter(String enteredKeyword) {
    List<Item> results = [];
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
    widget.leagueModel.removeListener(sync);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text('Item Store', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
          ),)
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: widget.leagueModel, 
          builder: (context, _) => Column(
          children: [
          SearchBar(
            hintText: 'Search da champion',
            onChanged: (value) => runFilter(value),
            leading: const Icon(Icons.search)
          ),
          SizedBox(height: 10),
          Expanded(
            child: found.isNotEmpty ? ListView.separated(
              key: UniqueKey(),
              separatorBuilder: (context, index) => SizedBox(height:5),
              padding: EdgeInsets.all(12), 
              itemCount: found.length,
              itemBuilder: (context, index){
                return ItemCard(item: found[index], version: widget.leagueModel.version!);
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