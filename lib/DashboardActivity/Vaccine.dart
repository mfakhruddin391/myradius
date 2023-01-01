import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Vaccine extends StatelessWidget{

  static const routeName = "/Vaccine";
  static final titleBar = "Vaccine Info";

  static CarouselOptions _carouseloption = CarouselOptions(
          height: 400,
          aspectRatio: 16/9,
          autoPlay: true,
          viewportFraction: 0.8,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,

          );
  final vaccinInfo = [
    {'img' : 'lib/img/astra.jpg','title':'Astra Zeneca','country':'United States, U.S','description':'COVID-19 Vaccine AstraZeneca stimulates the body natural defences (immune system). It causes the body to produce its own protection(antibodies) against the virus.',},
    {'img' : 'lib/img/covaxin.jpg','title':'Covaxin','country':'India','description':'Indias First Indigenous COVID-19 Vaccine.The indigenous, inactivated vaccine is developed and manufactured in Bharat Biotechs BSL-3 (Bio-Safety Level 3) high containment facility.',},
    {'img' : 'lib/img/sinovac.jpg','title':'Sinovac','country':'China','description':'CoronaVac, also known as the Sinovac COVID-19 vaccine, is an inactivated virus COVID-19 vaccine developed by the Chinese company Sinovac Biotech. It has been in Phase III clinical trials in Brazil, Chile, Indonesia, Philippines, and Turkey.'},
    {'img' : 'lib/img/pfizer.jpg','title':'Pfizer-BioNTech','country':'United State, U.S','description':'The German company BioNTech is the developer of the vaccine, and partnered for support with clinical trials, logistics and manufacturing with American company Pfizer as well as Chinese company Fosun for China, Hong Kong, Macau and Taiwan.'},
    {'img' : 'lib/img/sputnikv.jpg','title':'Sputnik V','country':'Russia','description':'Sputnik V uses a weakened virus to deliver small parts of a pathogen and stimulate an immune response. It is a vector vaccine based on adenovirus DNA, in which the SARS - CoV - 2 coronavirus gene is integrated.'}
      ];        

  List<Widget> _vaccineContainer(context){
  List<Widget> storeContainerArr = [];

   vaccinInfo.forEach((e) {

     var storeContainer = Container(
              width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset(
                        e['img'],
                        fit: BoxFit.cover,
                        width: 1000.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                       
                        decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.blueAccent)),
                        padding: EdgeInsets.all(6),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  e['title'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  e['country'],
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15.0
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                      e['description'],
                                      style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11.0
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            );

    storeContainerArr.add(storeContainer);
    });
     
     return storeContainerArr;
  }




  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        body:Center(
            child: new Form(
        child: Column
        (children: <Widget>[
        SizedBox(height: 110),
        CarouselSlider(
          options:_carouseloption,
          items: _vaccineContainer(context)
        ,
        ),
      ]),),
      
    ))
    );


   
  }
}
