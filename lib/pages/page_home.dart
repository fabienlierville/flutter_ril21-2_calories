import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  bool genre = false;
  double? age;
  double? taille;
  double? poids;
  Map<int, String> activiteSportive = {
    0:"Faible",
    1:"Modéré",
    2:"Forte",
  };
  int? activiteSportiveSelection;
  int? calorieBase;
  int? calorieAvecActivite;

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: getColor(),
          middle: TextAvecStyle("Calcul de Calories", color: Colors.white),
        ),
          child: body()
      );
      
    }else{
      return Scaffold(
        appBar: AppBar(
          title: TextAvecStyle("Calcul de Calories", color: Colors.white),
          backgroundColor: getColor(),
        ),
        body: body(),
      );
    }
    
    

  }

  Widget body(){
   return  Center(
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
                 TextAvecStyle("Votre taille est de ${taille?.toInt()} cm"),
                 Slider(
                   value: taille ?? 100,
                   onChanged: (double d){
                     setState(() {
                       taille = d;
                     });
                   },
                   min: 100,
                   max: 250,
                   activeColor: getColor(),
                 ),
                 TextField(
                   keyboardType: TextInputType.number,
                   onChanged: (String value){
                     setState(() {
                       poids = double.tryParse(value);
                     });
                   },
                   decoration: const InputDecoration(labelText: "Entrez votre poids en Kilos."),
                 ),
                 TextAvecStyle("Quelle est votre activité sportive ?", color: getColor()),
                 rowActiviteSportive(),
               ],
             ),
           ),
           ElevatedButton(
             onPressed: calculerNombreDeCalories,
             child: TextAvecStyle("Calculer", color: Colors.white),
             style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.all<Color>(getColor())
             ),
           )
         ],
       ) ,
     ) ,
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


  Row rowActiviteSportive(){
    List<Column> c = [];

    activiteSportive.forEach((key, value) {

      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: key,
            groupValue: activiteSportiveSelection,
            onChanged: (int? index){
              setState(() {
                activiteSportiveSelection = index;
              });
            },
          ),
          TextAvecStyle(value, color: getColor())
        ],
      );

      c.add(colonne);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: c,
    );

  }


  void calculerNombreDeCalories(){
    //Vérification des champs
    if(age != null && poids != null && activiteSportiveSelection != null && taille != null){
      if(genre){
        calorieBase = (66.4730 + (13.7516 * poids!) + (5.0033 * taille!) - (6.7550 * age!)).toInt();
      }else{
        calorieBase = (655.0955 + (9.5634 * poids!) + (1.8496 * taille!) - (4.6756 * age!)).toInt();
      }
      switch(activiteSportiveSelection){
        case 0:
          calorieAvecActivite = (calorieBase! * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase! * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase! * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }
      dialogue();
    }else{
      //Alerte erreur
      alerte();
    }
  }


  Future<void> dialogue() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
          return SimpleDialog(
            title: TextAvecStyle("Votre besoin en calories", color: getColor()),
            contentPadding: EdgeInsets.all(5.0),
            children: [
              TextAvecStyle("De base : ${calorieBase!}"),
              TextAvecStyle("Avec Sport : ${calorieAvecActivite!}"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(contextDialog);
                },
                child: TextAvecStyle("Ok", color: Colors.white),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        getColor())
                ),
              ),
            ],
          );
        }
    );
  }

  Future<void> alerte() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextDialog){
          return AlertDialog(
            title: Text("Erreur", textScaleFactor: 2,),
            content: Text("Tous les champs de sont pas remplis"),
            contentPadding: EdgeInsets.all(5.0),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(contextDialog);
                  },
                  child: Text("Ok", style: TextStyle(color: Colors.red),)
              ),
            ],
          );
        }
    );
  }

}
