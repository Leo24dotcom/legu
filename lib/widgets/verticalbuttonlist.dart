import 'package:flutter/material.dart';
import 'package:league/services/league_model.dart';
import 'package:league/models/item.dart';


const List<ItemRarity?> categories = [
  null,
  ItemRarity.start,
  ItemRarity.basic,
  ItemRarity.epic,
  ItemRarity.leg,
];

String labelFor(ItemRarity? rarity) {
  if (rarity == null) return 'All';
  return rarity.name.toUpperCase();
}

class Verticalbuttonlist extends StatelessWidget{
  final LeagueModel leagueModel;

  const Verticalbuttonlist({super.key, required this.leagueModel});

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context,index) => SizedBox(height: 5),
        itemCount: categories.length,
        itemBuilder: (context, index){
          final rarity = categories[index];
          final isSelected = rarity == leagueModel.selectedItemType;
         return AspectRatio(
            aspectRatio: 1,
          child: ElevatedButton(
            onPressed: (){
              leagueModel.selectItemCategory(rarity);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: isSelected ? Color(0x80FFFFE0) : Colors.black
            ),
            child: Text(labelFor(rarity), maxLines: 1, softWrap: false,
            style: TextStyle(fontSize: 8, color: Color(0xFFFFD700)),),
          ),
          );
        }
      )
    );
  }
}