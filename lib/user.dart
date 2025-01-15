import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String description;
  String location;
  String contactno;
  String sellingitem;
  String imageurl;
  String price;
  DocumentReference reference;

  User({required this.name,required this.description,required this.contactno,required this.location,required this.reference,
    required this.sellingitem,required this.imageurl,required this.price, required String contactNo, required String imageUrl, required String sellingItem});
  User.fromMap(Map<String, dynamic> map, {required this.reference}) {
    name = map["name"];
    description=map["description"];
    location=map["location"];
    contactno=map["contactno"];
    sellingitem=map["sellingitem"];
    imageurl=map["imageurl"];
    price =map["price"];
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data as Map<String, dynamic>, reference: snapshot.reference);

  toJson() {
    return {'name': name,'description':description,"loaction":location,'imageurl'
        :imageurl,'sellingitem':sellingitem,'conactno':contactno,"price":price};
  }
}