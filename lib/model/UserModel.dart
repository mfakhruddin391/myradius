
class UserModel{

  String _fullName = '';
  String _email = '';
  String _password ='';
  double _lat = 0.0;
  double _lng = 0.0;
  String _address_name = '';
  String _place_id = '';

  //page variable will determine which page was navigate to mapscreen.
  String _activity_name = '';


  //This constructor override used for Model

  String getEmail(){
    return this._email;
  }

  void setEmail(email){
    this._email = email;
  }

  String getPassword(){
    return this._password;
  }
  
  void setPassword(pass){
    return this._password = pass;
  }

  double getLat(){
    return this._lat;
  }
  
  void setLat(lat){
    return this._lat = lat;
  }

  double getLng(){
    return this._lng;
  }
  
  void setLng(lng){
    return this._lng = lng;
  }

  String getAddress(){
    return this._address_name;
  }

  void setAddress(address){
    this._address_name = address;
  }

  String getActivity(){
    return this._activity_name;
  }

  void setActivity(activityname){
    this._activity_name = activityname;
  }

    String getFullName(){
    return this._fullName;
  }

  void setFullName(String fullname){
    this._fullName = fullname;
  }

  String getPlaceId(){
    return this._place_id;
  }

  void setPlaceId(placeid){
    this._place_id = placeid;
  }
}
