import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  bool genre = false;
  double? age;
  double taille = 150;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextAvecStyle("Calcul de Calories", color: Colors.white),
        backgroundColor: getColor(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child:Column(
            children: [
              TextAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextAvecStyle("Femme", color: Colors.pink),
                        Switch(
                            value: genre,
                            onChanged: (bool b){
                              setState(() {
                                genre = b;
                              });
                            },
                          inactiveTrackColor: Colors.pink,
                          activeColor: Colors.blue,
                        ),
                        TextAvecStyle("Homme", color: Colors.blue),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: (){
                          selectionDate();
                        }, 
                        child: TextAvecStyle((age == null) ? "Appuyez pour votre age" : "Votre age est de ${age!.toInt()} ans", color: Colors.white),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(getColor())
                      ),
                    ),
                    TextAvecStyle("Votre taille est de ${taille.toInt()} cm"),
                    Slider(
                        value: taille,
                        onChanged: (double d){
                          setState(() {
                            taille = d;
                          });
                        },
                      min: 100,
                      max: 250,
                      activeColor: getColor(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: null,
                child: TextAvecStyle("Calculer", color: Colors.white),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(getColor())
                ),
              )
            ],
          ) ,
        ) ,
      ),
    );
  }

  
  Text TextAvecStyle(String data, {color: Colors.black, fontSize: 15.0}){
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color,
          fontSize: fontSize
      ),
    );
  }

  Color getColor(){
    //Genre est à true alors homme sinon femme
    if(genre) {
      return Colors.blue;
    }else{
      return  Colors.pink;
    }
  }

  Future<void> selectionDate() async{
    DateTime? datechoisie = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
    );

    if(datechoisie != null) {
      Duration difference = DateTime.now().difference(datechoisie);
      int jours = difference.inDays;
      double ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }
  

}
