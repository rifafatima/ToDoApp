import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  TextEditingController  _titleController;
  bool isEditingText = false;
  bool toggle=false;
  DateTime id;
  String editId="null";
  String input;
  
  createTodoItem(){

    id=DateTime.now();

    DocumentReference documentReference= Firestore.instance.collection("ToDo").document(id.toString());

    Map<String, dynamic> todo= {
      "id": id.toString(),
      "todoTitle":input,
      "check":false,
    };

    documentReference.setData(todo).whenComplete(() => print("$input created"));
  }


  deleteTodoItem(item){
    DocumentReference documentReference= Firestore.instance.collection("ToDo").document(item);

    documentReference.delete().whenComplete(() => print("$item deleted"));
  }

  editTodoItem(item){
     DocumentReference documentReference= Firestore.instance.collection("ToDo").document(item);

    documentReference.updateData({"todoTitle": input}).whenComplete(() => print("$input updated"));
  }

  toggleCheckBox(item){
    DocumentReference documentReference= Firestore.instance.collection("ToDo").document(item);

    documentReference.updateData({"check": toggle}).whenComplete(() => print("$input updated"));
  }

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: input);
  }

  
@override
void dispose() {
  _titleController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO DO APP',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
          wordSpacing: 6,
        ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [

          SizedBox(
            height: 10,
          ),

              Row(
                children: [
                  Container(
                    width: 300,
                    child: Card(
                       margin: EdgeInsets.all(10),
                       elevation: 5,
                       child:Container(
                         padding: EdgeInsets.only(
                           top: 10, 
                           left:10, 
                           right:10, 
                           bottom: 10),
                         child: TextField(
                           decoration:InputDecoration(
                             labelText: 'Enter to do task here.',
                             labelStyle: TextStyle(
                               fontSize: 16,
                             ),
                             ),
                           controller: _titleController,
                           onChanged: (String value){
                            setState(() {
                               input=value;
                            });
                           },
                         ),
                          ),
                       ),
                      ),
                  
                    MaterialButton(
                      onPressed: () {
                        if(isEditingText)
                        {
                          editTodoItem(editId);
                          setState(() {
                             isEditingText=false;
                          });
                          
                        }
                        else
                        {
                          createTodoItem();
                        } 
              
                         _titleController.clear();
                         FocusScope.of(context).unfocus();
                         

                        },
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      //padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                      ), 
      
                ],
              ),
        
          SizedBox(
            height: 10,
          ),

          StreamBuilder(
              stream: Firestore.instance.collection("ToDo").snapshots(),
              builder: (context, snapshots){

                if(snapshots.connectionState == ConnectionState.waiting || !snapshots.hasData)
                {
                  return CircularProgressIndicator();
                } 
                else 
                {
                  return Expanded(
                  child: ListView.builder(
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index){
                  DocumentSnapshot documentSnapshot= snapshots.data.documents[index];
                  return Container(
                    child: Card(
                      margin: EdgeInsets.all(8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(

                        title: Text(documentSnapshot["todoTitle"], 
                        style: TextStyle(
                               fontSize: 18,
                             ),
                        ),

                        leading: IconButton(

                                  icon: Icon( (documentSnapshot["check"]==true && toggle==true)  ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded ),
                                  // icon: Icon(Icons.check_box_outline_blank_rounded),
                                  
                                  color: Colors.grey,
                                  onPressed: (){
                                     setState(() {
                                       toggle=!toggle;
                                    });
                                    toggleCheckBox(documentSnapshot["id"]);
                                  },
                                  ),

                        trailing: Wrap(
                          spacing: 8,
                          children: [

                             IconButton(
                              icon: Icon(Icons.edit),
                              color: Theme.of(context).accentColor,
                              onPressed: (){
                                 _titleController.text = documentSnapshot["todoTitle"];
                                  _titleController.selection = TextSelection.fromPosition(TextPosition(offset: _titleController.text.length));
                                  editId=documentSnapshot["id"];
                                 
                                  setState(() {
                                   isEditingText=true;
                                  });

                                  print(isEditingText);
                                                     
                                  //the logic to turn the list item into text field
                                }
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: (){
                                    deleteTodoItem(documentSnapshot["id"]);
                                  },
                                  ),
                        ],
                        ), 
                      ),
                      ),
                  );
              },
              ),
                );
                }
              } ,)
        ],
      ),
    );
  }
}
