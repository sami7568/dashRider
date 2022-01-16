
import 'dart:ui';
import 'package:dashdriver/AllScreen/loginScreen.dart';
import 'package:dashdriver/AllScreen/notapprove.dart';
import 'package:dashdriver/AllWidgets/progressDialog.dart';
import 'package:dashdriver/configMaps.dart';
import 'package:dashdriver/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  static const String idScreen = "registration";

  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController nameTextEditingController= TextEditingController();
  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();
  TextEditingController phoneTextEditingController= TextEditingController();
  TextEditingController carModeltextEditingController=TextEditingController();
  TextEditingController carNumbertextEditingController=TextEditingController();
  TextEditingController carColortextEditingController=TextEditingController();
  TextEditingController confirmPassTextEditingController=TextEditingController();
String? stcard="Upload";
String dLicence = "Upload";
  FilePickerResult? uploadlicence;
  FilePickerResult? uploadcard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30.0,),
              Row(
                children: const [
                  Text("D",style:TextStyle(color: Color(0xff00ACA4),fontFamily: "Brand Bolt",fontSize: 50,fontWeight: FontWeight.bold)),
                  Text("Driver",style:TextStyle(color: Colors.black,fontFamily: "Brand Bolt",fontSize: 18,)),
                ],
              ),
              const Text(
                "Registration",
                style: TextStyle(fontSize: 45,fontFamily: "Brand Bolt",fontWeight: FontWeight.bold),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType:TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Name",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10.0,),
                    DropdownButton<String>(
                      hint: const Text("Type of Vehicle"),
                      alignment: Alignment.bottomCenter,
                      //value: rideType,
                      isExpanded: true,
                      items:const [
                        DropdownMenuItem(child: Text('MVP'),value: "mvp",),
                        DropdownMenuItem(child: Text('BASIC'),value: "basic",),
                        DropdownMenuItem(child: Text('Bike'),value: "bike",),
                      ],
                      onChanged: (val){
                        setState(() {
                          rideType=val!;
                        });
                      },
                    ),
                    //const SizedBox(height: 10.0,),
                    TextField(
                      controller: carModeltextEditingController,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Modle of vehicle",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10.0,),
                    TextField(
                      controller: carColortextEditingController,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Color of Vehicle",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10.0,),
                    TextField(
                      controller: carNumbertextEditingController,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Plate No of Vehicle",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    //  const SizedBox(height: 10.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Mobile number",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Center(child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text("Driving Licence",style: TextStyle(fontSize: 16),),
                            const SizedBox(height: 10.0,),
                            Container(
                              decoration:  BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.black),
                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 0, horizontal: 50)),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontSize: 15))),
                                onPressed: ()async{
                                  final result = await FilePicker.platform.pickFiles(type: FileType.image);
                                  if (result != null) {
                                    String fileName = result.files.first.name;
                                    setState(() {
                                      dLicence = fileName;
                                      uploadlicence = result;
                                    });
                                  }
                                },
                                child: Text(dLicence),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                              const Text("Student Card",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),),
                            const SizedBox(height: 10.0,),
                            Container(
                              decoration:  BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.black),
                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 0, horizontal: 50)),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontSize: 15))),
                                onPressed: ()async{
                                  final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.image);
                                  if (result != null) {
                                    String fileName = result.files.first.name;
                                    setState(() {
                                      stcard = fileName;
                                      uploadcard = result;
                                    });
                                   }
                                },
                                child: Text(stcard!),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                    // const SizedBox(height: 10.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    TextField(
                      obscureText: true,
                      controller: confirmPassTextEditingController,
                      decoration: const InputDecoration(
                        fillColor: Color(0x225C0D0D),
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0,),
                    RaisedButton(
                      color: const Color(0xff00ACA4),
                      child: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "REGISTER",
                            style:  TextStyle(fontFamily: "Brand Bolt", fontSize: 18.0,color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: (){
                       validateData(context);
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: const Center(child:Text(
                    "Already have an account? Login here",
                    style:TextStyle(color: Colors.black)
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  //validate form data
  validateData(BuildContext context){
    if(!emailTextEditingController.text.contains("@")){
      displayToastMessage("Email address is not correct", context);
      return;
    }
    if(nameTextEditingController.text.length<=3){
      displayToastMessage("name must be at least 3 characters", context);
      return;
    }
    else if(rideType=="notSelected"){
      displayToastMessage("Please Select Vehicle type", context);
      return;
    }
    else if(carModeltextEditingController.text.isEmpty){
      displayToastMessage("Car Model is mandatory", context);
      return;
    }
    else if(carColortextEditingController.text.isEmpty){
      displayToastMessage("Car Color is mandatory", context);
      return;
    }
    else if(carNumbertextEditingController.text.isEmpty){
      displayToastMessage("Plate Number is mandatory", context);
      return;
    }
    else if(phoneTextEditingController.text.isEmpty){
      displayToastMessage("Phone Number is mandatory", context);
      return;
    }
    else if (uploadlicence!.names.isEmpty && uploadlicence!.names.isEmpty ) {
      displayToastMessage("Please Select Licence/Student Card Image", context);
      return;
    }
    else if(passwordTextEditingController.text.length<6){
      displayToastMessage("Password is too short must be at least 6 characters", context);
      return;
    }
    else if(confirmPassTextEditingController.text.isEmpty){
      displayToastMessage("Confirm Password is mandatory", context);
      return;
    }
    else if(passwordTextEditingController.text != confirmPassTextEditingController.text){
      displayToastMessage("Password and Confirm password are not same", context);
      return;
    }
    else{
      registerNewUser(context);
    }
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  //register new user
  void registerNewUser(BuildContext context)async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering Please Wait",);
        }
    );

    final  User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error :"+ errMsg.toString(), context);
    })).user;

    if(firebaseUser !=null){
      Map userDataMap= {
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "phone":phoneTextEditingController.text.trim(),
        "password":passwordTextEditingController.text.trim(),
        "car_color":carColortextEditingController.text,
        "car_number":carNumbertextEditingController.text,
        "car_model":carModeltextEditingController.text,
        "ride_type":rideType,
        "approve":"false",
        "history":"null",
      };
      currentfirebaseUSer = firebaseUser;
      driversRef.child(firebaseUser.uid).set(userDataMap);

     /* final  finalName = base64Encode(uploadlicence!.paths);
*/
/*
      Uint8List? fileBytes = uploadlicence!.files.first.bytes;
      String fileName = uploadlicence!.files.first.name;
      await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes!);

      Uint8List? fileBytes1 = uploadcard!.files.first.bytes;
      String fileName1 = uploadcard!.files.first.name;
      await FirebaseStorage.instance.ref('uploads/$fileName1').putData(fileBytes1!);
*/


      displayToastMessage("Congratulations your account is created", context);
      Navigator.pushNamed(context, NotApproved.idScreen);
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("New User Account has not been created", context);
    }
  }
}

//show a toast message
displayToastMessage(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}
/*
String? imageUrlDownload;
ImagePicker _picker = ImagePicker();
XFile? image;
File? imageFile;
void selectCameraImage() async {
  image = await _picker.pickImage(source: ImageSource.camera);
  setState(() {
    imageFile = File(image!.path);
  });
  Navigator.pop(context);
}
void selectGalleryImage() async {
  image = await _picker.pickImage(source: ImageSource.gallery);
  setState(() {
    imageFile = File(image!.path);
  });
  Navigator.pop(context);
}
Future uploadImage() async {
  final destination = 'users/images/$image';
  task2 = FirebaseStorage.instance.ref(destination);
  if(image == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Please Upload your Picture")));
    setState(() {
      circular = false;
    });
  }
  await task2!.putFile(File(image!.path));
  imageUrlDownload = await task2!.getDownloadURL();
  print('Download-link: $imageUrlDownload');
}*/
