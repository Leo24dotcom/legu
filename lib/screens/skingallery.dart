import 'package:flutter/material.dart';
import 'package:league/models/champion.dart';
import 'package:league/screens/championdetail.dart';

class SkinGallery extends StatefulWidget{
  final Champion champion;
  final String version;

  const SkinGallery({super.key, required this.champion, required this.version});
  @override
  State<SkinGallery> createState() => SkinGalleryScreen();
}

class SkinGalleryScreen extends State<SkinGallery> {
  List<Skin>? skins;

  @override
  void initState(){
    super.initState();
    _loadSkinCount();
  }

  Future<void> _loadSkinCount() async {
  final result = await widget.champion.fetchChampionSkins(widget.version);
  setState(() {
    skins = result;
  });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
        onPressed: () {
          Navigator.pop(context,
          MaterialPageRoute(builder: (context) => ChampionDetail(champion: widget.champion, version: widget.version),));
        },
        icon: Icon(Icons.chevron_left),
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        ),
        title: Text('SKIN GALLERY', style: TextStyle(color: Color(0xFFFFD700)),),
        actions: [
          Text('${widget.champion.skins!.length} skins', style: TextStyle(
            color: Color(0xFFFFD700)
          ))
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFFFD700),
            width: 1.0
          )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
       child: Column(
        children: [
        Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 16/9,
          ),
          itemCount: widget.champion.skins?.length,
          itemBuilder: (context,index){
            return 
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFFD700), width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
            child: Column(
              children: [
            Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network('https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${widget.champion.id}_${widget.champion.skins![index].num}.jpg', fit: BoxFit.cover
              ),
            ),
            ),
            widget.champion.skins![index].name != 'default' ? Text(widget.champion.skins![index].name, style: TextStyle(color: Colors.white)) : Text(widget.champion.name, style: TextStyle(color: Colors.white),),
                    ],
                  ),
            );
  
              }
            ),
          ),
        ],
      ),
      ),
    );
  }
}