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
  List<String> tabList = ['LORE', 'STATS', 'SKILLS'];
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            switch(widget.champion.tags[0]){
              'Fighter' => Color(0xFFC0392B),
              'Tank' => Color(0xFF4A90E2),
              'Mage' => Color(0xFF7E57C2),
              'Assassin' => Color(0xFF2C3E50),
              'Marksman' => Color(0xFFD4AF37),
              'Support' => Color(0xFF27AE60),
              _ => Colors.grey
            },
            Color(0xFF0A0A0F)
          ],
          stops: [0.0,0.3],
        ),
      ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
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
          Text(widget.champion.title, style: TextStyle(color: Color(0xFFFFD700), fontSize: 15),),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.champion.tags.length,
              separatorBuilder: (context, index) => SizedBox(width: 5),
              itemBuilder: (context, index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: switch(widget.champion.tags[index]){
              'Fighter' => Color(0xFFC0392B),
              'Tank' => Color(0xFF4A90E2),
              'Mage' => Color(0xFF7E57C2),
              'Assassin' => Color(0xFF2C3E50),
              'Marksman' => Color(0xFFD4AF37),
              'Support' => Color(0xFF27AE60),
              _ => Colors.grey
            },
            border: Border.all(
              color: Colors.black, width: 2,
            )
                  ),                
                  padding: const EdgeInsets.all(4),
                child: Text(widget.champion.tags[index], style: TextStyle(color: Colors.white)));
                }, 
              ),
            ),
            SizedBox(height:10),
          
         Image.network('https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${widget.champion.id}_0.jpg'),
         SizedBox(height:10),
         Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('LORE', style: TextStyle(color: Color(0xFFFFD700), 
                decoration: TextDecoration.underline, 
                decorationColor: Color(0xFFFFD700), 
                decorationThickness: 2,
                fontWeight: FontWeight.bold),
                ),
                Text('Stats', style: TextStyle(color: Colors.white)),
                Text('SKILLS', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
         lore == null ? const CircularProgressIndicator() : Text(lore!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(
          color: Colors.white,
         ),),
         SizedBox(height:15),
         Text('BASE STATS', style: TextStyle(color: Color(0xFFFFD700)),),
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
                  color: Color(0xFFFFD700)
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(children: [
                Text('${widget.champion.stats[stat[index]]}', style: TextStyle(color: Colors.white),),
                Text(stat2[index], style: TextStyle(color: Color(0xFFFFD700)),)
                ],
              ),
            ),
            );
          }, 
          separatorBuilder: (context, index) => SizedBox(width:5), 
          itemCount: stat.length
          ),
         ),
         SizedBox(height:15),
         Text('Abilities', style: TextStyle(color: Color(0xFFFFD700)),),
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
                height:60,
                width: 60,
              child: TextButton(
              onPressed: (){
              setState(() {
                selectedAbility = ability;
                }
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: switch(keyList[index]){
                'P' => Color(0xFF006400),
                'Q' => Color(0xFF301934),
                'W' => Color(0xFF8B0000),
                'E' => Color(0xFF8B8000),
                'R' => Color(0xFF00008B),
                _=> Colors.grey
                },
              side: BorderSide(
                color: switch(keyList[index]){
                'P' => Color(0xFF66FF00),
                'Q' => Color(0xFFBF40BF),
                'W' => Color(0xFFFF0000),
                'E' => Color.fromARGB(255, 255, 166, 0),
                'R' => Color(0xFF0096FF),
                _=> Colors.grey
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),    
            ),
            child: Text(keyList[index],
            style: TextStyle(
              color: switch(keyList[index]){
                'P' => Color(0xFF66FF00),
                'Q' => Color(0xFFBF40BF),
                'W' => Color(0xFFFF0000),
                'E' => Color(0xFFFFA500),
                'R' => Color(0xFF0096FF),
                _=> Colors.grey
                },
            ),
            ),
              ),
            ),
                ],
            );
            },
            separatorBuilder: (context,index) => SizedBox(width: 5), 
            itemCount: keyList.length),
            ), if (selectedAbility != null)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(selectedAbility!.name, style: TextStyle(color: Colors.white),),
              Text(
                selectedAbility!.description.replaceAll(RegExp(r'<[^>]*>'),'').trim(),
                style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                ],
              ),
              ),
          ],
        ),
      ),
      )
    ),
    );
  }
}