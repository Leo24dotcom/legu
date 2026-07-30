import 'package:flutter/material.dart';
import 'package:league/services/league_model.dart';
import 'package:league/models/item.dart';
import 'package:league/widgets/itemcard.dart';
import 'package:league/widgets/verticalbuttonlist.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Item Store', style: TextStyle(
          color: Color(0xFFFFD700),
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFFFD700),
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
          ),
          ),
          shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFFFD700),
            width: 1.0
          )),
          actions: [
            SizedBox(
              width: 120,
              height: 40,
            child: SearchBar(
            backgroundColor: WidgetStateProperty.all(Colors.black),
            hintText: 'Search',
            hintStyle: WidgetStateProperty.all(
              const TextStyle(color: Color(0xFFFFD700))
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(color: Color(0xFFFFD700))
            ),
            onChanged: (value) => runFilter(value),
            leading: const Icon(Icons.search, color: Color(0xFFFFD700),),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero,
              side: BorderSide(color: Color(0xFFFFD700), width: 2))
            )
          ),
            ),
          ],
      ),
      body: Padding(
        padding: EdgeInsets.only(right:12, bottom: 12, left: 12),
        child: Row(
          children: [
        SizedBox(height: 12),
        Expanded(
        child: Verticalbuttonlist(leagueModel: widget.leagueModel),
        ),
        VerticalDivider(
          color: Color(0xFFFFD700),
          thickness: 1,
          width: 20,
        ),
        Expanded(
          flex: 5,
        child: ListenableBuilder(
          listenable: widget.leagueModel, 
          builder: (context, _) => Column(
          children: [
          SizedBox(height: 12,),
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
          ],
        ),
      ),
    );
  }
}