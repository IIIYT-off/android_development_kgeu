
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

addTokenToStorage(String token) async{
  final storage = new FlutterSecureStorage();
  await storage.write(key: 'token', value: token);
}

getTokenFromStorage() async{
  final storage = new FlutterSecureStorage();
  return await storage.read(key: 'token');
}

removeTokenFromStorage()async{
  final storage = new FlutterSecureStorage();
  await storage.delete(key: 'token');
}