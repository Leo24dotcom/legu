import 'package:flutter/material.dart';
import 'package:league/services/league_model.dart';



Set <String> categories = {'All', 'Assassin', 'Fighter', 'Mage', 'Marksman', 'Support', 'Tank'};

String selectedCategory = 'All';


class HorizontalButtonList extends StatelessWidget {
  final LeagueModel leagueModel;
  const HorizontalButtonList({super.key, required this.leagueModel});
  List<String> get Categories => categories.toList();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Categories.length,
        itemBuilder: (context, index){
          final category = Categories[index];
          final isSelected = category == leagueModel.selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ElevatedButton(
              onPressed: (){
                leagueModel.selectCategory(Categories[index]);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.amber,
                  width: 2.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: isSelected ?Colors.grey : Color(0xFF1A1A2E)
              ),
              child: Text(Categories[index],
              style: TextStyle(
                color: Colors.white,
              ))
              )
            );
        },
        )
    );
  }

}

