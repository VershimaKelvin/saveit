import 'package:flutter/material.dart';
import 'package:saveit/models/contact.dart';
import 'package:saveit/utils/database_helper.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // var data = [];
  // var data2 = [];
  var itemCount;
  List<Contact> contactList = [];
  List<Map<String, dynamic>>? returnedList;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  void getDatabase() async {
    DatabaseHelper instance = DatabaseHelper.instance;
    returnedList = await instance.query();
    returnedList!.forEach((element) {
      Map<String, dynamic> contacts = element;
        Contact contactObject = Contact(
            id: contacts['id'],
            name: contacts['name'],
            number: contacts['mobile']);
        setState(() {
          contactList.add(contactObject);
        });
        contacts={};
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('SQLITE CRUD')),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a name';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'full name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: TextFormField(
                        controller: numberController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 10) {
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'mobile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                color: Colors.grey,
                child: TextButton(
                  onPressed: () {
                    onSave();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.blue[600],
                          ),
                          title: Text(
                            contactList[index].name!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(contactList[index].number!),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }


  //after saved is clicked
  void onSave() async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved'),));
      String name = nameController.text;
      String number = numberController.text;

      DatabaseHelper instance = DatabaseHelper.instance;
      Map<String, dynamic> row = {
        'name': name,
        'mobile': number,
      };
      int x = await instance.insert(row);
      savingToList(name,number);
      nameController.clear();
      numberController.clear();
    }
  }

  forSaving()async{
    DatabaseHelper instance = DatabaseHelper.instance;
    returnedList = await instance.query();

    returnedList!.forEach((element) {
      Map<String, dynamic> contacts = element;
      Contact contactObject = Contact(
          id: contacts['id'],
          name: contacts['name'],
          number: contacts['mobile']);

      contactList.add(contactObject);

      contacts={};
    });
    print(contactList);
  }

  void savingToList(String name, String mobile)async{
    DatabaseHelper instance = DatabaseHelper.instance;
    returnedList = await instance.query();
    Map<String,dynamic> contacts = returnedList![itemCount];
    Contact contactObject = Contact(
        id: contacts['id'],
        name: contacts['name'],
        number: contacts['mobile']);
    setState(() {
      contactList.add(contactObject);
    });
    contacts={};
  }

  // void toList() async {
  //   DatabaseHelper instance = DatabaseHelper.instance;
  //   returnedList = await instance.query();
  //   for (var i = 0; i <= returnedList!.length; i++) {
  //     Map<String, dynamic> contacts = returnedList![i];
  //     Contact contactObject = Contact(
  //         id: contacts['id'],
  //         name: contacts['name'],
  //         number: contacts['number']);
  //     contactList.add(contactObject);
  //   }
  // }
}
