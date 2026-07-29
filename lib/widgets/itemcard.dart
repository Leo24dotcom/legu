import 'package:flutter/material.dart';
import 'package:league/models/item.dart';

class ItemCard extends StatelessWidget{
  final Item item;
  final String version;

  const ItemCard({super.key, required this.item, required this.version});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFFFD700)
        )
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Image.network('https://ddragon.leagueoflegends.com/cdn/$version/img/item/${item.sprite}'),
          SizedBox(width:10),
          Text(item.name, style: TextStyle(color: Colors.white)),
          SizedBox(width: 10,),
          Text('${item.total} gold', style: TextStyle(color: Colors.white),),
          SizedBox(width:5),
          Expanded(
          child: Text(item.description.replaceAll(RegExp(r'<[^>]*>'),''), style: TextStyle(color: Colors.white), softWrap: true,),),
        ],
      ),
    );
  }
}