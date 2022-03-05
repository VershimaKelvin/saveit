class Contact {
   int? id;
   String? name;
   String? number;

  Contact({this.id,this.name,this.number});


  Map<String, dynamic> toMap(){

    return {
      'id':id,
      'name':name,
      'number':number
    };
  }
}