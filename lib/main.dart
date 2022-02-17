import 'package:flutter/material.dart';
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
  var data = [];
  var data2 = [];
  List<Map<String, dynamic>>? map;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

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
                  itemCount: data.length,
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
                              data[index].toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          subtitle: Text(data2[index]),
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

  void onSave() async {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String number = numberController.text;
      setState(() {
        data.add(name);
        data2.add(number);
      });

      DatabaseHelper instance = DatabaseHelper.instance;
      Map<String, dynamic> row = {
        'name': name,
        'mobile': number,
      };
      int x = await instance.insert(row);
      print(x);
      map = await instance.query();
      print(map);
      nameController.clear();
      numberController.clear();
    }
  }

  void toList() {}
}
