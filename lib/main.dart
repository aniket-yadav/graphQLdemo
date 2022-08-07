import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqldemo/screen/add_user_screen.dart';
import 'package:graphqldemo/service/delete_user.dart';
import 'package:graphqldemo/screen/display_user_screen.dart';
import 'package:graphqldemo/service/get_all_users.dart';
import 'package:graphqldemo/snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphQL CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: const Color(0xFFf8f8f8),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: MaterialStateProperty.all(const Color(0xFFFFFFFF)),
            textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF),
                  );
                } else if (states.contains(MaterialState.disabled)) {
                  return const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF),
                  );
                } else {
                  return const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFFFFFF),
                  );
                }
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color(0xFF1769aa);
                } else if (states.contains(MaterialState.disabled)) {
                  return const Color(0xFFa6d5fa);
                }
                return const Color(0xFF2196f3);
              },
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Color(0xFF404040),
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: Color(0x66404040),
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            borderSide: const BorderSide(
              color: Color(0x70707066),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            borderSide: const BorderSide(
              color: Color(0x70707066),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            borderSide: const BorderSide(
              color: Color(0x70707066),
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'GraphQL CRUD'),
      routes: {
        AddUpdateUserScreen.routeName: (_) => const AddUpdateUserScreen(),
        DisplayUser.routeName: (_) => const DisplayUser(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

/*

Hey everyone, today we are going to see CRUD operation in graphql api
here we are goining to add/read/update/delete user

i have already made a video on what is graphql  so ,let's jump on directly 
let's see create
so to create we use mutate type of call let's see it's api call then ui


now let's see how to get single data , how to to fetch one user using userid

okay that's complete - create read all, single, now let's see update /edit
now last if delete let check that

with this our crud operation is complete
thanks for watching

*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ) 
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           
            Navigator.of(context).pushNamed(AddUpdateUserScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List>(  // in my main screen i am using future builder , if you don't know about future builder don't worry i'll do a separate video for that
            future: getAllUsers(), // that data goes to this future builder
             // which this method return ie. getAllUsers method/
            //  for now it's use future value i.e. value whic you  get after api call or after some processing
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) { 
                //  here value from api i.e list of user i am showing with list view
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder( //
                      itemCount: snapshot.data?.length, // snapshot.data container value 
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1100000D),
                                blurRadius: 16,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                "# ${snapshot.data?[index]['id']}",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                snapshot.data?[index]['name'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              //  we got 3 action view, edit/update , delete
                              IconButton(
                                onPressed: () {
                                  //  this is view button
                                  //  on click of this we are opening a new screen
                                  //  here i am using named routes 
                                  Navigator.of(context).pushNamed(
                                      DisplayUser.routeName, //let's see 
                                      arguments: snapshot.data?[index]['id']); // and passing id as argument
                                },
                                icon: const Icon(
                                  Icons.launch_outlined,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  //  on click of edit we are passing id to add user screen  , which we are going to add and update in single screen
                                  Navigator.of(context).pushNamed(
                                      AddUpdateUserScreen.routeName,
                                      arguments: snapshot.data?[index]['id']); // let's see how we handle this
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () async {
                                  //  on click of delete 
                                  //  calling delete user with id
                                  var res = await deleteUser(
                                      id: int.parse(
                                          snapshot.data?[index]['id']));
                                  if (res) { // on response if true 
                                    snackBar("User deleted", context);
                                    setState(() {}); // this is to refresh data
                                    //  okay let's check 

                                  } else {
                                    snackBar("Failed to delete", context);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container();
            }));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
