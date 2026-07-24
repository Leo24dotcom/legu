import 'package:flutter/material.dart';
import 'package:league/models/champion.dart';
import 'package:league/screens/championselect.dart';

class ChampionDetail extends StatefulWidget{
  final Champion champion;
  final String version;
  const ChampionDetail({super.key, required this.champion, required this.version});

  @override
  State<ChampionDetail> createState() => ChampionDetailScreen();
}

class ChampionDetailScreen extends State<ChampionDetail> {
  String? lore;
  List<String> stat = ['hp','mp','attackdamage','armor','spellblock','movespeed'];
  List<String> stat2 = ['HP','MP','AD','AR','MR','MS'];
  List<String> keyList = ['P','Q','W','E','R'];
  Ability? selectedAbility;

  @override
  void initState() {
    super.initState();
    _loadLore();
    _loadAbilities();
  }

  Future<void> _loadLore() async {
    final result = await widget.champion.fetchLore(widget.version);
    setState(() {
      lore = result;
    });
  }

  Future<void> _loadAbilities() async {
      try {
    await widget.champion.fetchAbilities(widget.version);
  } catch (e, st) {
    debugPrint('fetchAbilities error: $e');
  }
  if (!mounted) return;
  setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: (){
              Navigator.pop(context, 
              MaterialPageRoute(builder: (context) => ChampSelectScreen())
              );
            }, 
          icon: Icon(Icons.chevron_left)),
          Text(widget.champion.name, style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40
          ),
          ),
          Text(widget.champion.title),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.champion.tags.length,
              separatorBuilder: (context, index) => SizedBox(width: 5),
              itemBuilder: (context, index){
                return Text(widget.champion.tags[index], style: TextStyle(color: Colors.black));
                }, 
              ),
            ),
          
         Image.network('https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${widget.champion.id}_0.jpg'),
         lore == null ? const CircularProgressIndicator() : Text(lore!, maxLines: 3, overflow: TextOverflow.ellipsis,),
         SizedBox(height:15),
         Text('BASE STATS'),
         SizedBox(
          height: 65,
         child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            return AspectRatio(
              aspectRatio: 1/1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber
                )
              ),
              child: Column(children: [
                Text('${widget.champion.stats[stat[index]]}'),
                Text(stat2[index])
                ],
              ),
            ),
            );
          }, 
          separatorBuilder: (context, index) => SizedBox(width:5), 
          itemCount: stat.length
          ),
         ),
         SizedBox(height:5),
         Text('Abilities'),
         widget.champion.spells == null || widget.champion.passive == null ? const CircularProgressIndicator() : SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              final ability = index == 0 ? widget.champion.passive! : widget.champion.spells![index-1];
              return 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(
                height:40,
                width: 40,
              child: TextButton(
              onPressed: (){
              setState(() {
                selectedAbility = ability;
                }
              );
            },
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.green)),
            child: Text(keyList[index]),
              ),
            ),
                ],
            );
            },
            separatorBuilder: (context,index) => SizedBox(width: 5), 
            itemCount: keyList.length),
            ), if (selectedAbility != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(selectedAbility!.name),
              Text(
                selectedAbility!.description.replaceAll(RegExp(r'<[^>]*>'),'').trim(),
                style: const TextStyle(fontSize: 14),
                ),
                ],
              ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}