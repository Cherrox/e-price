import 'dart:io';
import 'package:e_price/env.dart';
import 'package:e_price/src/helpers/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

final _clientId = Env.GOOGLE_CLOUD_ID;
const _scopes = ['https://www.googleapis.com/auth/drive.file'];

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = new http.Client();
  GoogleAuthClient(this._headers);
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleDriveHelper {
  String folderName = "EPrice";
  //Get Authenticated Http Client

  Future<Map<String, String>?> loginToDrive() async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount? account = await googleSignIn.signIn();
    return await account?.authHeaders;
  }

  Future<String?> uploadToDrive(
      File file1, Map<String, String> headers, String fileName) async {
    var client = GoogleAuthClient(headers);
    var ga = drive.DriveApi(client);

    var query =
        "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    var searchResult = await ga.files.list(q: query, spaces: 'drive');

    var EPriceFolderId = "";

    // Si la carpeta existe, retornamos su ID
    if (searchResult.files != null && searchResult.files!.isNotEmpty) {
      EPriceFolderId = searchResult.files!.first.id!;
    } else {
      var folder = drive.File();
      folder.name = "$folderName";
      folder.mimeType = "application/vnd.google-apps.folder";

      // La carpeta creada se almacena en `createdFolder` y obtenemos su ID
      final createdFolder = await ga.files.create(folder);
      EPriceFolderId = createdFolder.id!;
    }

    print("EPriceFolderId: $EPriceFolderId");

    query =
        "name = 'Stocks' and mimeType = 'application/vnd.google-apps.folder' and trashed = false and '$EPriceFolderId' in parents";
    searchResult = await ga.files.list(q: query, spaces: 'drive');

    var folderId = "";

    // Si la carpeta existe, retornamos su ID
    if (searchResult.files != null && searchResult.files!.isNotEmpty) {
      folderId = searchResult.files!.first.id!;
    } else {
      var folder = drive.File();
      folder.name = "Stocks";
      folder.mimeType = "application/vnd.google-apps.folder";
      folder.parents = [EPriceFolderId];

      // La carpeta creada se almacena en `createdFolder` y obtenemos su ID
      final createdFolder = await ga.files.create(folder);
      folderId = createdFolder.id!;
    }

    drive.File fileToUpload = drive.File();
    //pre defined string variable for the file name
    fileToUpload.name = fileName;
    fileToUpload.parents = [folderId];

    try {
      await ga.files.create(
        fileToUpload,
        uploadMedia: drive.Media(file1.openRead(), file1.lengthSync()),
      );
      return null;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
