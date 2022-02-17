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
  List<Map<String,dynamic>>? map;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  const Center(child: Text('SQLITE CRUD')),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: TextFormField(
                        controller:nameController,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return 'Enter a name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'full name'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: TextFormField(
                          controller: numberController,
                        validator: (value){
                          if(value==null || value.isEmpty || value.length < 10){
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'mobile'
                        ),
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
                  child:const Text(
                      'Save',
                    style: TextStyle(
                      color: Colors.white
                    ),

                  ),

                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
 void onSave()async{
    if(formKey.currentState!.validate()){
      String name = nameController.text;
      String number = numberController.text;
      DatabaseHelper instance = DatabaseHelper.instance;
      Map<String,dynamic> row = {
        'name':name,
        'mobile':number,
      };
      int x = await instance.insert(row);
      print(x);
      map = await instance.query();
      print(map);
    }
  }

  void toList(){

  }
}
