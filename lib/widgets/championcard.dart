import 'package:flutter/material.dart';
import 'package:league/models/champion.dart';
import 'package:league/screens/championdetail.dart';

class Championcard extends StatelessWidget{
  final Champion champion;
  final String version;

  const Championcard({super.key, required this.champion,required this.version});

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        debugPrint('You clicked on ${champion.id}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChampionDetail(champion: champion, version: version))
        );
      },
      child: AspectRatio(
        aspectRatio: 1/2,
      child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [switch(champion.tags[0]){
          'Tank' => Color(0xFF4A90E2),
          'Fighter' => Color(0xFFC0392B),
          'Mage' => Color(0xFF7E57C2),
          'Marksman' => Color(0xFFD4AF37),
          'Support' => Color(0xFF27AE60),
          'Assasin' => Color(0xFF2C3E50),
          _ => Colors.grey}, Colors.black
          ], stops: [0.0, 0.9]
        ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
            child: Image.network(
              'https://ddragon.leagueoflegends.com/cdn/$version/img/champion/${champion.sprite}', fit: BoxFit.cover,
            ),
            ),
            Text(champion.name, style: TextStyle(color: Colors.white)),
            SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: champion.tags.length,
              separatorBuilder: (context, index) => SizedBox(width: 5),
              itemBuilder: (context, index){
                return Text(champion.tags[index], style: TextStyle(color: Color(0xFFFFFF00)));
                }, 
              ),
            ),
            ],
          ),
        
      ),
      ),
    );
  }
}