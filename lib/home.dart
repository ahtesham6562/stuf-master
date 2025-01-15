import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuff/detailpage.dart';
import 'package:stuff/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool showTextField = false;
  bool isEditing = false;

  String collectionName = "Users";
  User? curUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Stream<QuerySnapshot> getUsers() {
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }

  void addUser() {
    User user = User(
      name: nameController.text,
      description: descriptionController.text,
      contactNo: contactController.text,
      imageUrl: imageUrlController.text,
      location: locationController.text,
      sellingItem: itemController.text,
      price: priceController.text, contactno: '', sellingitem: '', imageurl: '',
    );
    FirebaseFirestore.instance.collection(collectionName).add(user.toJson());
  }

  void updateUser(User user) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.update(user.reference!, {
        'name': nameController.text,
        'description': descriptionController.text,
        'contactNo': contactController.text,
        'imageUrl': imageUrlController.text,
        'location': locationController.text,
        'sellingItem': itemController.text,
        'price': priceController.text,
      });
    });
  }

  void deleteUser(User user) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.delete(user.reference!);
    });
  }

  void setUpdateUI(User user) {
    nameController.text = user.name;
    descriptionController.text = user.description;
    contactController.text = user.contactno;
    imageUrlController.text = user.imageurl;
    locationController.text = user.location;
    itemController.text = user.sellingitem;
    priceController.text = user.price;

    setState(() {
      showTextField = true;
      isEditing = true;
      curUser = user;
    });
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final user = User.fromSnapshot(doc);
            return InkWell(
              onTap: () => navigateToDetail(doc),
              onLongPress: () => deleteUser(user),
              onDoubleTap: () => setUpdateUI(user),
              child: ListTile(
                title: Text(user.name),
                subtitle: Text(user.sellingitem),
                trailing: Text('\$${user.price}'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void navigateToDetail(DocumentSnapshot post) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Detail(post: post),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STUFF", style: TextStyle(color: Colors.grey)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/carry'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.grey),
            onPressed: () => setState(() => showTextField = !showTextField),
          ),
        ],
      ),
      body: Column(
        children: [
          if (showTextField) buildAddOrUpdateForm(),
          Expanded(child: buildBody(context)),
        ],
      ),
    );
  }

  Widget buildAddOrUpdateForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        autovalidateMode:
        _validate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          children: [
            buildTextFormField(nameController, "Name"),
            buildTextFormField(itemController, "Item to Sell"),
            buildTextFormField(priceController, "Price", keyboardType: TextInputType.number),
            buildTextFormField(descriptionController, "Description"),
            buildTextFormField(imageUrlController, "Image URL"),
            buildTextFormField(contactController, "Contact Number", keyboardType: TextInputType.phone),
            buildTextFormField(locationController, "Location"),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) return "$label is required";
          return null;
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (isEditing) {
            updateUser(curUser!);
            setState(() => isEditing = false);
          } else {
            addUser();
          }
          setState(() => showTextField = false);
          _clearControllers();
        } else {
          setState(() => _validate = true);
        }
      },
      child: Text(isEditing ? 'Update Item' : 'Add Item'),
    );
  }

  void _clearControllers() {
    nameController.clear();
    itemController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrlController.clear();
    contactController.clear();
    locationController.clear();
  }
}
