import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myradius/model/AddressListModel.dart';
import 'package:myradius/util/APIKey.dart';

class RequestAddress{

    Future <List<dynamic>>  placeAutoComplete(search) async {

      //protection to avoid code from read special characters
      var userSearch = Uri.encodeFull(search);

      var response = await http.get(
          Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?'+
          'input='+userSearch+'&'+
          'key='+APIKey.googleAPIKey1+'&'+
          'inputtype=textquery+'+'&'+
          'location'+'&'+
          'language=ms'+'&'+
          'components=country:my'+'&'
          
          'sessiontoken=1234567890'),
      );



      var parseJson = json.decode(response.body);
      List<AddressListModel> addressList = [];
      var ID_NO = 1;
      //print(parseJson['predictions']['description']);
      for(var obj in parseJson['predictions']) {

        //print(obj['description']);
        //print(obj['place_id']);
      
        var addressObj = new AddressListModel.forModel();
        addressObj.id= ID_NO;
        addressObj.place_id = obj['place_id'];
        addressObj.address_name = obj['description'];
        addressList.add(addressObj);
        ID_NO++;
      }

      return Future.value(addressList);
    }

    Future <dynamic>  placeDetailsFindCoords(place_id) async {

      var coords = {
        'lat' : 0.0,
        'lng' : 0.0
      };
      var response = await http.get(
          Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?'+
          'key='+APIKey.googleAPIKey1+'&'+
          'place_id='+place_id+'&'+
          'sessiontoken=1234567890'),
      );
       var parseJson = json.decode(response.body);
       
       coords['lat'] = parseJson['result']['geometry']['location']['lat'];
       coords['lng'] = parseJson['result']['geometry']['location']['lng'];

     

      return Future.value(coords);
    }



}