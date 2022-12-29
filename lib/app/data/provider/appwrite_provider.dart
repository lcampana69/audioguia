import 'dart:async';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appWriteModels;
import '../../utils/tools.dart';

//***************************************************************************
class AppWriteProvider {
  static late Storage _appWriteStorage;
  static late Databases _appWriteDB;
  static late Client _appWriteClient;

  static Client get appWriteClient => _appWriteClient;
  static bool debug = true;

  static set appWriteClient(Client value) {
    _appWriteClient = value;
    _appWriteStorage = Storage(value);
    _appWriteDB = Databases(value);
  }

  static late appWriteModels.Account _appWriteUserAccount;

  static appWriteModels.Account get appWriteUserAccount => _appWriteUserAccount;

  static set appWriteUserAccount(appWriteModels.Account value) {
    _appWriteUserAccount = value;
  }

  static bool _isLoggedIn = false;

  static bool get isLoggedIn => _isLoggedIn;

  static set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  static late String _appWrtiteError;

  static String get appWriteError => _appWrtiteError;

  static set appWriteError(String value) {
    _appWrtiteError = value;
  }

  static late appWriteModels.Session? _appWriteSession;

  static appWriteModels.Session? get appWriteSession => _appWriteSession;

  static set appWriteSession(appWriteModels.Session? value) {
    _appWriteSession = value;
  }

  //****************************************************************************
  static String getUserName() {
    if (appWriteSession != null) return appWriteUserAccount!.name;
    return '';
  }

  //****************************************************************************
  static Future<bool> createAccount(String name, String email,
      String password) async {
    try {
      appWriteError = "";
      isLoggedIn = false;
      final appWriteUserAccount = await Account(appWriteClient).create(
          userId: ID.unique(), email: email, password: password, name: name);
      isLoggedIn = await createSession(email, password);
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(createAccount)");
    }
    return isLoggedIn;
  }

//****************************************************************************
  static Future<bool> getAccount() async {
    try {
      appWriteError = "";
      appWriteUserAccount = await Account(appWriteClient).get();
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getAccount)");
      return false;
    }
  }

//****************************************************************************
  static Future<bool> createSession(String email, String password) async {
    try {
      appWriteError = "";
      isLoggedIn = false;
      appWriteSession = await Account(appWriteClient)
          .createEmailSession(email: email, password: password);
      if (await getAccount()) isLoggedIn = true;
    } on AppwriteException catch (e) {
      appWriteSession = null;
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(createSession)");
    }
    return isLoggedIn;
  }

//****************************************************************************
  static Future<bool> deleteSession() async {
    try {
      appWriteError = "";
      await Account(appWriteClient).deleteSession(sessionId: 'current');
      isLoggedIn = false;
      appWriteSession = null;
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(deleteSession)");
      return false;
    }
  }

//****************************************************************************
  static Future<bool> getSession() async {
    try {
      appWriteError = "";
      appWriteSession =
      await Account(appWriteClient).getSession(sessionId: 'current');
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      appWriteSession = null;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getSession)");
      return false;
    }
  }

  //****************************************************************************
  static Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      appWriteError = "";
      return (await Account(appWriteClient).getPrefs()).data;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getUserPreferences)");
      return null;
    }
  }

  //****************************************************************************
  static Future<bool> setUserPreferences(
      Map<String, dynamic> preferences) async {
    try {
      appWriteError = "";
      await Account(appWriteClient).updatePrefs(prefs: preferences);
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(setUserPreferences)");
      return false;
    }
  }

//Storage
//****************************************************************************
  static Future<List<appWriteModels.File>> getListFiles(
      {required String bucket, String name = ''}) async {
    try {
      List<appWriteModels.File> output=[];
      const pageLen=25;
      var cont=0;
      while(true) {
        var result =
        await _appWriteStorage.listFiles(bucketId: bucket,
            search: name,
            queries: [Query.limit(pageLen), Query.offset(cont*pageLen)]);
        if(result.files.length>0){
          output.addAll(result.files);
          cont++;
        }else break;
      }
      return output;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getListFiles)");
      return [];
    }
  }

//****************************************************************************
  static Future<Uint8List> getFile(String bucket, String idFile) async {
    try {
      return await _appWriteStorage.getFileDownload(
          bucketId: bucket, fileId: idFile);
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getFile)");
      return Uint8List.fromList([]);
    }
  }

//****************************************************************************
  static Future<String> fileExists(String bucket, String fileName) async {
    try {
      final result =
      await _appWriteStorage.listFiles(bucketId: bucket, search: fileName);
      return result.files[0].$id;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(fileExists)");
      return '';
    }
  }

  //****************************************************************************
  static Future<bool> deleteFile(String bucket, String fileName,) async {
    try {
      final result =
      await _appWriteStorage.listFiles(bucketId: bucket, search: fileName);
      if (result.files.length > 0) {
        await _appWriteStorage.deleteFile(
            bucketId: bucket, fileId: result.files[0].$id);
      } else
        return false;
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(deleteFile)");
      return false;
    }
  }

//****************************************************************************
  static Future<String> putFile(String bucket, String path, String fileName,
      {Function(double)? onProgress, List<String>? permissions}) async {
    try {
      await deleteFile(bucket, fileName,);
      final result = await _appWriteStorage.createFile(
          bucketId: bucket,
          fileId: ID.unique(),
          permissions: permissions,
          file: InputFile(path: path + fileName, filename: fileName),
          onProgress: (progress) {
            onProgress!(progress.progress);
          }
      );
      return result.$id;
    } on Exception catch (e) {
      appWriteError = e.toString();
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getFile)");
      return '';
    }
  }


//DB
//****************************************************************************
  static Future<Map<String, dynamic>> getDocument(String dataBase,
      String collection, String document) async {
    try {
      final result =
      await _appWriteDB.getDocument(databaseId: dataBase, collectionId: collection, documentId: document);
      return result.data;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(getDocument)");
      return {};
    }
  }

//****************************************************************************
  static Future<List<appWriteModels.Document>> listDocuments(String dataBase,
      String collection,) async{
    try {
      final result=await _appWriteDB.listDocuments(databaseId: dataBase, collectionId: collection) as appWriteModels.DocumentList;
      return result.documents;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(listDocuments)");
      return [];
    }
  }

  //****************************************************************************
  static Future<String> createDocument(String dataBase,
      String collection,Map<dynamic, dynamic> data,{List<String>? permissions}) async{
    try {
      final result=await _appWriteDB.createDocument(databaseId: dataBase, collectionId: collection,
          documentId: ID.unique(), data: data,permissions: permissions);
      return result.$id;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(createDocument)");
      return '';
    }
  }

  //****************************************************************************
  static Future<bool> updateDocument(String dataBase,
      String collection,String document,Map<dynamic, dynamic> data,{List<String>? permissions}) async{
    try {
      final result=await _appWriteDB.updateDocument(databaseId: dataBase, collectionId: collection,
          documentId: document, data: data,permissions: permissions);
      return result.$id==document;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(updateDocument)");
      return false;
    }
  }

  //****************************************************************************
  static Future<bool> deleteDocument(String dataBase,
      String collection,String document) async{
    try {
      final result=await _appWriteDB.deleteDocument(databaseId: dataBase, collectionId: collection,
          documentId: document);
      return true;
    } on AppwriteException catch (e) {
      appWriteError = e.message!;
      if (AppWriteProvider.debug)
        Tools.snackBar(appWriteError + "(deleteDocument)");
      return false;
    }
  }
}