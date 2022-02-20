class Contact {
   int? id;
   String? name;
   String? number;

  Contact({this.id,this.name,this.number});


  void display(){
    print('$id $name $number');
  }
}