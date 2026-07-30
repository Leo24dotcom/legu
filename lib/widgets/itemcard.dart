import 'package:flutter/material.dart';
import 'package:league/models/item.dart';

class ItemCard extends StatelessWidget{
  final Item item;
  final String version;

  const ItemCard({super.key, required this.item, required this.version});

  String parseItemDescription(String rawHtml) {
  var text = rawHtml;

  // Convert line-break-like tags into actual newlines first
  text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

  // Strip all remaining tags (attention, mainText, stats, passive, etc.)
  text = text.replaceAll(RegExp(r'<[^>]+>'), '');

  // Decode common HTML entities Riot uses
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');

  // Collapse excess blank lines/spaces
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();

  return text;
}

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
          Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(item.name, style: TextStyle(color: Colors.white)),
          
          Text(parseItemDescription(item.description), style: TextStyle(color: Colors.white), softWrap: true,),
            ],
          ),
          ),
          SizedBox(width:15),
          Text('${item.total} gold', style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}