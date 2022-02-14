class Contact{
  static const tblContact='contacts';
  static  const colId='id';
  static  const colName='name';
  static const colMobile='mobile';


int? id;
String? name;
String? mobile;

Contact({this.id,this.name,this.mobile});


Map<String,dynamic> toMap(){
  var map=<String,dynamic>{colName:name,colMobile:mobile};
  if(id!=null)map[colId]=id;
  return map;
  }
  
Contact.fromMap(Map<dynamic,dynamic>map){
id=map[colId];
name=map[colName];
mobile=map[colMobile];
}
}
