import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check/Widgets/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/new_button.dart';

class UpdateAvailability extends StatelessWidget {
  const UpdateAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DriveCheck"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Update Availability", style: TextStyle(fontSize: 25),),
            subtitle: Text("You have to specify genuine reason to mark you un-availability, Admin will verify the reason.", style: TextStyle(fontSize: 10),),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){updateAvailability("Available", "");}, child: Text("Available")),
              ElevatedButton(onPressed: (){handleNo(context);}, child: Text("Not Available")),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateAvailability(String availability, String? reason) async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String uid = auth.currentUser!.uid;
    if(reason==null){
      Map<String, dynamic> data = {
        "Availability": availability,
      };
      try{
        db.collection('users').doc(uid).set(data);  //TODO add setOption to merger here to manage overwriting of fields
      } on FirebaseException catch(e){
        print(e);
      }
    }
    else{
      Map<String, dynamic> data = {
        "Availability": availability,
        "Reason": reason
      };
      try{
        db.collection('users').doc(uid).set(data);  //TODO add setOption to merger here to manage overwriting of fields
      } on FirebaseException catch(e){
        print(e);
      }
    }
  }

  Future<void> handleNo(BuildContext context) async{
    print("Handle No Called");
    final TextEditingController reasonController = TextEditingController();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NewButton(buttonText: "Cancel", onTap: ()=>Navigator.pop(context)),
              NewButton(buttonText: "Submit", onTap: () {
                if(reasonController.text.isEmpty) Get.snackbar("Oops!", "You have to specify the reason",backgroundColor: Color(0xFF159757).withOpacity(0.4));
                else updateAvailability("Not Available", reasonController.text.trim());
              }),
            ],
          )
        ],
        content: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              ListTile(
                title: Text("Enter your reason", textAlign: TextAlign.left, style: TextStyle(fontSize: 25),),
                subtitle: Text("Your reason will be only accepted by admin", textAlign: TextAlign.left,),
              ),
              Divider(color: Color(0xFF159757),),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Enter Reason",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
              )
            ],
          ),
        ),
      );
    });
  }

}
