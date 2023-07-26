class SocietyResident {
  SocietyResident({
    required this.success,
    required this.residentslist,
  });
  late final bool success;
  late final List<Residentslist> residentslist;
  
  SocietyResident.fromJson(Map<String, dynamic> json){
    success = json['success'];
    residentslist = List.from(json['residentslist']).map((e)=>Residentslist.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['residentslist'] = residentslist.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Residentslist {
  Residentslist({
    required this.id,
    required this.residentid,
    required this.subadminid,
    required this.country,
    required this.state,
    required this.city,
    required this.houseaddress,
    required this.vechileno,
    required this.residenttype,
    required this.propertytype,
    required this.committeemember,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.firstname,
    required this.lastname,
    required this.cnic,
    required this.address,
    required this.mobileno,
    required this.password,
    required this.roleid,
    required this.rolename,
    required this.image,
    required this.fcmtoken,
  });
  late final int id;
  late final int residentid;
  late final int subadminid;
  late final String country;
  late final String state;
  late final String city;
  late final String houseaddress;
  late final String vechileno;
  late final String residenttype;
  late final String propertytype;
  late final int committeemember;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final String firstname;
  late final String lastname;
  late final String cnic;
  late final String address;
  late final String mobileno;
  late final String password;
  late final int roleid;
  late final String rolename;
  late final String image;
  late final String fcmtoken;
  
  Residentslist.fromJson(Map<String, dynamic> json){
    id = json['id'];
    residentid = json['residentid'];
    subadminid = json['subadminid'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    houseaddress = json['houseaddress'];
    vechileno = json['vechileno'];
    residenttype = json['residenttype'];
    propertytype = json['propertytype'];
    committeemember = json['committeemember'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    cnic = json['cnic'];
    address = json['address'];
    mobileno = json['mobileno'];
    password = json['password'];
    roleid = json['roleid'];
    rolename = json['rolename'];
    image = json['image'];
    fcmtoken = json['fcmtoken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['residentid'] = residentid;
    _data['subadminid'] = subadminid;
    _data['country'] = country;
    _data['state'] = state;
    _data['city'] = city;
    _data['houseaddress'] = houseaddress;
    _data['vechileno'] = vechileno;
    _data['residenttype'] = residenttype;
    _data['propertytype'] = propertytype;
    _data['committeemember'] = committeemember;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['cnic'] = cnic;
    _data['address'] = address;
    _data['mobileno'] = mobileno;
    _data['password'] = password;
    _data['roleid'] = roleid;
    _data['rolename'] = rolename;
    _data['image'] = image;
    _data['fcmtoken'] = fcmtoken;
    return _data;
  }
}