import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphqldemo/service/create_user.dart';
import 'package:graphqldemo/service/get_user.dart';
import 'package:graphqldemo/snackbar.dart';
import 'package:graphqldemo/service/update_user.dart';

class AddUpdateUserScreen extends StatefulWidget {
  const AddUpdateUserScreen({Key? key}) : super(key: key);
  static const routeName = "addUpdateUser";
  @override
  State<AddUpdateUserScreen> createState() => _AddUpdateUserState();
}

class _AddUpdateUserState extends State<AddUpdateUserScreen> {
  // that's all for api call now let's see ui
  //  it's simple 3 field and one button to submit

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  String name = '';
  String email = '';
  String job = '';
  String? _userId;
  Map<String, dynamic>? _user;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userId = ModalRoute.of(context)?.settings.arguments as String?; // id passing from main screen 

      if (_userId != null) { // if i am getting id then it's for update so 
      //  
        loadData(_userId ?? '');
      }
    });
    _nameController.addListener(() {
      setState(() {
        name = _nameController.text.trim();
      });
    });
    _emailController.addListener(() {
      setState(() {
        email = _emailController.text.trim();
      });
    });
    _jobController.addListener(() {
      setState(() {
        job = _jobController.text.trim();
      });
    });
    super.initState();
  }

  loadData(String id) async {
    //  using that id to fetch data as we see just how to read single data is same
    _user = await getUser(id: int.tryParse(id)); // getUser takes' int so convert string to int
    if (_user != null && _user!.isNotEmpty) { // after getting data i am assigning data to textfield 
      _nameController.text = _user?['name'] ?? '';
      _emailController.text = _user?['email'] ?? '';
      _jobController.text = _user?['job_title'] ?? '';
    }
  }


// that's all now let's see this in action
//  let's refresh 
//  we got our data
//  now let's see how did we displayed this

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user != null ? "Update User" : "Add User"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Enter name",
                  label: Text(
                    "Name",
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z.' ]")),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Enter email",
                  label: Text(
                    "Email",
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: TextField(
                controller: _jobController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Enter job",
                  label: Text(
                    "Job",
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z.' ]")),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: allowToSubmit()
                    ? () async {
                      //  once you filled all data it will validate email and 
                      // NOTE: i am using same screen for create and update so you are going to see both code here
                        FocusScope.of(context).requestFocus(FocusNode());
                        var reg = RegExp(
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                        if (!reg.hasMatch(email)) {
                          snackBar("Invalid email", context);
                          return;
                        }
                        if (_user != null) { // if _user is not null it means it's update so here 
                          var res = await updateUser( // et's see update api call
                            id: _user?['id'],
                            email: email,
                            job: job,
                            name: name,
                          ); // we call update api
                          if (res) { // on reponse true 
                            snackBar("User updated", context);
                            Navigator.of(context).pop(); // close screen
                          } else {
                            snackBar("Failed to update user", context);
                            //  it got updated
                          }
                        } else {
                          //  i am passing values to createUser method which we just saw
                          var res = await createUser(
                              email: email, job: job, name: name);
                          if (res) {// in return it will be true or false
                            snackBar("User created", context); 
                            Navigator.of(context).pop();// after successful create close this screen
                          } else {
                            snackBar("Failed to create user", context);
                          }
                        }
                      }
                    : null,
                child: Text(_user != null ? "Update" : "Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool allowToSubmit() {
    return name.isNotEmpty && email.isNotEmpty && job.isNotEmpty;
  }
}
