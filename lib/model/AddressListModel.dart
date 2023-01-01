
class AddressListModel{

  int id;
  var place_id;
  String address_name;
  double lat;
  double lng;



  //This constructor used for Model
  AddressListModel.forModel();

  //Constructor overloading in dart. you cant have redundant constructor same name like java :)
  //This constructor used for pass argument to other activity
  AddressListModel.forPassArgs(this.id,this.place_id,this.address_name);



}
