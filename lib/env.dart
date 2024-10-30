// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'GOOGLE_CLOUD_ID', obfuscate: true)
    static String GOOGLE_CLOUD_ID = _Env.GOOGLE_CLOUD_ID;
}