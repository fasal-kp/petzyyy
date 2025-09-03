import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final id = const Uuid().v4();
final ref = FirebaseStorage.instance.ref().child('pets').child('$id.jpg');;--------------
