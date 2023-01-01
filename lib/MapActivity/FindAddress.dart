import 'package:flutter/material.dart';
import 'package:myradius/MapActivity/RequestAddress.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class FindAddress extends StatefulWidget{
  static const routeName = '/FindAdress';
  @override
  _FinAddressState createState() => _FinAddressState();
}

class _FinAddressState extends State<FindAddress>{

  @override
  void initState(){
    super.initState();
  }

  var addressList = [Card()];
  var storeAddress= [];
  var searchedAddress = [];
  RequestAddress req = RequestAddress();

 _updateCardList()
 {
   //Limit the list only appear for 20 list only to reduce duration for fetch to UI.
   for(int i =0;i<storeAddress.length;i++)
   {
     setState(() {
     var newKey;
     newKey = new Key(i.toString());
     addressList.add(
         Card(key: newKey,
             
             child:Column(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 ListTile(
                  title :Text(storeAddress[i].address_name),
                  //subtitle : Text("test"),
                   onTap: (){
                   EasyLoading.show(status: 'Loading....');  
                  //print(storeAddress[i].place_id)
                  req.placeDetailsFindCoords(storeAddress[i].place_id).then((res){
                   storeAddress[i].lat = res['lat'];
                   storeAddress[i].lng = res['lng'];
                   
                    print(storeAddress[i].address_name);
                    print(storeAddress[i].place_id);
                    print(storeAddress[i].lat);
                    print(storeAddress[i].lng);
                    EasyLoading.dismiss();
                    Navigator.pop(context,storeAddress[i]);
                  });
      
                  
               },)
               ],          
             ),));
     });

   }
 }

 //Every new keyword insert by user, this array will be clear .
 _clearAddress(){
  setState(() {
        
         searchedAddress.clear();
         addressList.clear();
        });
 }


  _searchEntities(String e)
  {
    

    //query after first 4 char
      e.length >= 4 ? req.placeAutoComplete(e).then((res)=>
      {
        _clearAddress(),
        storeAddress = res.toSet().toList(),

      }).then((res2)=>{

        print(storeAddress),
       _updateCardList()

      }): print("typing..");  
  }

  @override
  Widget build(BuildContext context){



    return MaterialApp(

      home: Scaffold(
          //backgroundColor : AppsTheme.theme1,
        appBar: AppBar(
            centerTitle: true,
           // backgroundColor : AppsTheme.theme1,
            title: Text("Search Address"),
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () => {
              Navigator.pop(context),
            },
          )
      ),
        body: ListView(

          children: [
            Container(
              
              child: TextFormField(
              initialValue: '',
              onChanged: (e)=>{
                  _searchEntities(e),
                  
                
              },
              cursorColor: Theme.of(context).backgroundColor,
              decoration: InputDecoration(
                labelText: 'Search your home address',
                labelStyle: TextStyle(fontSize: 13),
              ),

            ),),

            Center(
              child: new Form(
                  child: Column(
                    children: addressList,
                  )
              ),
            ),


          ],
        )
    ));
  }


}