import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  String collectionPath;

  late final CollectionReference<Map<String, dynamic>> _fb;

  FirebaseService({
    required this.collectionPath,
  }) {
    _fb = FirebaseFirestore.instance.collection(collectionPath);
  }

  /// Add a doc to the [collectionPath] specified in the class constructor
  Future<void> addDoc(Map<String, dynamic> data) async {
    await _fb.add(data);
  }

  /// Gets the fields of a doc by it's [path]
  Future<Map<String, dynamic>?> getDocData(String path) async {
    final data = await _fb.doc(path).get();

    // add the id to the map so it can be used as path
    final docData = data.data();
    docData?['id'] = data.id;

    return docData;
  }

  /// Get all the doc available in the collection path
  Future<List<Map<String, dynamic>?>> getCollectionDocs() async {
    final list = <Map<String, dynamic>?>[];

    final data = await _fb.get();
    for (var doc in data.docs) {
      // add the id to the map so it can be used as path
      final docData = doc.data();
      docData['id'] = doc.id;
      list.add(docData);
    }

    return list;
  }

  /// Update the doc fields - in the provided [path] - that specified in [data]
  Future<void> updateDocData(String path, Map<String, dynamic> data) async {
    await _fb.doc(path).update(data);
  }

  /// Delete the doc and it's subcollections
  Future<void> deleteDoc(String path) async {
    await _fb.doc(path).delete();
  }
}
