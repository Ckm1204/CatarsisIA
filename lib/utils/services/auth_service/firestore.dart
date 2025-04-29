import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllCollection({required String nameCollection}) async {
    List<Map<String, dynamic>> data = [];
    CollectionReference collectionReference = db.collection(nameCollection);
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (var item in querySnapshot.docs) {
      data.add(item.data() as Map<String, dynamic>);
    }
    return data;
  }
}
