import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/data/models/user_model.dart';
import 'package:flutter_firestore_crud/data/remote_data_source/firestore_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode ageFocusNode = FocusNode();
  FocusNode createButtonFocusNode = FocusNode();
  late String queryString;
  late List<UserModel> userDetails;

  bool isLoadedData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final data = await userCollection.get();
    final docList = data.docs;
    final users = docList.map((e) => UserModel.fromSnapshot(e)).toList();

    userDetails = users;
  }

  void searchUserDetails(String query) {
    final List<UserModel> suggestions = userDetails.where((user) {
      final userName = user.userName.toLowerCase();
      final userAge = user.age.toLowerCase();
      final queryString = query.toLowerCase();
      return userName.contains(queryString) || userAge.contains(queryString);
    }).toList();

    setState(() {
      userDetails = suggestions;
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter firestore'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // createForm(),
              Container(
                padding: const EdgeInsets.all(14.0),
                height: 70,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search by username',
                    contentPadding: const EdgeInsets.only(top: 20),
                  ),
                  onChanged: searchUserDetails,
                ),
              ),
              const SizedBox(height: 10),
              isLoadedData
                  ? ElevatedButton(
                      onPressed: () async {
                        await getData();
                        setState(() {
                          isLoadedData = false;
                        });
                      },
                      child: const Text('get data'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: userDetails.length,
                        itemBuilder: (context, index) {
                          final user = userDetails;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                title: Text(user[index].userName),
                                subtitle: Text(user[index].age),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createForm() {
    return Column(
      children: [
        TextFormField(
          controller: userNameController,
          decoration: const InputDecoration(
            labelText: 'username',
            border: OutlineInputBorder(),
            hintText: 'enter username',
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(ageFocusNode);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(createButtonFocusNode);
          },
          controller: ageController,
          focusNode: ageFocusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'age',
            hintText: 'enter your age',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            debugPrint('create data');
            FirestoreHelper.create(
              UserModel(
                userName: userNameController.text,
                age: ageController.text,
              ),
            );
          },
          focusNode: createButtonFocusNode,
          child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
