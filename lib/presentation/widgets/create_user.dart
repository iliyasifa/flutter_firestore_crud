import 'package:flutter/material.dart';
import '../../services/models/user_model.dart';
import '../../services/remote_data_source/firestore_helper.dart';

class CreateWidget extends StatelessWidget {
  final TextEditingController userNameController;

  final TextEditingController ageController;

  const CreateWidget({
    Key? key,
    required this.userNameController,
    required this.ageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: userNameController,
          decoration: const InputDecoration(
            labelText: 'username',
            border: OutlineInputBorder(),
            hintText: 'enter username',
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: ageController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'age',
            hintText: 'enter your age',
          ),
        ),
        const SizedBox(height: 10),
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
