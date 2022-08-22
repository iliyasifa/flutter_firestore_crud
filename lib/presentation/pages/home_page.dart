import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_crud/data/models/user_model.dart';
import '../widgets/create_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<UserModel>? userDetails;
  bool isLoadedData = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    ageController.dispose();
    searchController.dispose();
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
    final List<UserModel> suggestions = userDetails!.where((user) {
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

  void getUsersButton() async {
    await getData();
    setState(() {
      isLoadedData = true;
    });
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
              CreateWidget(
                userNameController: userNameController,
                ageController: ageController,
              ),
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
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: userDetails!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                              title: Text(userDetails![index].userName),
                              subtitle: Text(userDetails![index].age),
                            ),
                          );
                        },
                      ),
                    )
                  : ElevatedButton(
                      onPressed: getUsersButton,
                      child: const Text('get data'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
