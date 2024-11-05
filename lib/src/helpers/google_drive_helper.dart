import 'dart:io';
import 'package:e_price/env.dart';
import 'package:e_price/src/helpers/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

final _clientId = Env.GOOGLE_CLOUD_ID;
const _scopes = ['https://www.googleapis.com/auth/drive.file'];

class GoogleDriveHelper {
  final storage = SecureStorage();
  //Get Authenticated Http Client

  Future<http.Client?> getHttpClient() async {
    try {
      //Get Credentials
      // var credentials = await storage.getCredentials();
      // if (credentials == null) {
      //   //Needs user authentication
      //   var authClient = await clientViaUserConsent(
      //     ClientId(_clientId),
      //     _scopes,
      //     (url) {
      //       //Open Url in Browser
      //       print("LaunchUrl: ${url}");
      //       launch(url);
      //     },
      //   );
      //   //Save Credentials
      //   await storage.saveCredentials(authClient.credentials.accessToken,
      //       authClient.credentials.refreshToken!);
      //   return authClient;
      // } else {
      //   print(credentials["expiry"]);
      //   //Already authenticated
      //   return authenticatedClient(
      //     http.Client(),
      //     AccessCredentials(
      //         AccessToken(credentials["type"], credentials["data"],
      //             DateTime.tryParse(credentials["expiry"])!),
      //         credentials["refreshToken"],
      //         _scopes),
      //   );
      // }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

// check if the directory forlder is already available in drive , if available return its id
// if not available create a folder in drive and return id
//   if not able to create id then it means user authetication has failed
  Future<String?> _getFolderId(ga.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "EPrice";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        print("Sign-in first Error");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> uploadFileToGoogleDrive(File file) async {
    try {
      var client = await getHttpClient();
      if (client == null) {
        return "Error con el http cliente";
      }
      var drive = ga.DriveApi(client);
      String? folderId = await _getFolderId(drive);
      if (folderId == null) {
        print("Sign-in first Error");
      } else {
        ga.File fileToUpload = ga.File();
        fileToUpload.parents = [folderId];
        fileToUpload.name = p.basename(file.absolute.path);
        var response = await drive.files.create(
          fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
        );
        print(response);
      }
      return null;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
