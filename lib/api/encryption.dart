import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:cryptography/dart.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/string_ext.dart';
import 'package:jwk/jwk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyModule {
  static const publicIndex = "publicKey";
  static const privateIndex = "privateKey";

  static void generateKeys() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey(publicIndex)) return; // generate only once

    // Generate keys
    final algorithm = crypto.Cryptography.instance.x25519();

    final keyPair = await algorithm.newKeyPair();
    final public = await keyPair.extractPublicKey();

    // Serialize keys
    final publicBytes = public.bytes;
    final publicString = jsonEncode(publicBytes);

    final privateBytes = await keyPair.extractPrivateKeyBytes();
    final privateString = jsonEncode(privateBytes);

    // Store keys in sharedPrefs
    await sharedPrefs.setString(publicIndex, publicString);
    await sharedPrefs.setString(privateIndex, privateString);

    // Push key to server
    await Constants.api.storeKey(publicString);
  }

  static Future<String> retrievePublicKey() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final public = sharedPrefs.getString(publicIndex);

    if (public.isNullOrEmpty) throw Exception('Key is empty');

    return public!;
  }

  static Future<String> _retrievePrivateKey() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final private = sharedPrefs.getString(privateIndex);

    if (private.isNullOrEmpty) throw Exception('Key is empty');

    return private!;
  }
}

class CryptoKey {
  final crypto.SecretKey _key;
  final _aesGcm = DartAesGcm(nonceLength: 12, secretKeyLength: 32);

  CryptoKey._(this._key);

  /// Generates a [CryptoKey] object from the given public key of the
  /// corresponding user and the private key of the current user.
  static Future<CryptoKey> generate(String public) async {
    final algorithm = crypto.Cryptography.instance.x25519();

    // Deserialize remote public key
    final pubBytes =
        (jsonDecode(public) as List<dynamic>).map((e) => e as int).toList();
    final pubKey = crypto.SimplePublicKey(
      pubBytes,
      type: algorithm.keyPairType,
    );

    // Retrieve and deserialize private keyPair
    final private =
        (jsonDecode(await KeyModule._retrievePrivateKey()) as List<dynamic>)
            .map((e) => e as int)
            .toList();
    final keyPair = crypto.SimpleKeyPairData(
      private,
      publicKey: pubKey,
      type: algorithm.keyPairType,
    );

    // Derive key
    final key = await algorithm.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: pubKey,
    );

    // Return CryptoKey object
    return CryptoKey._(key);
  }

  Future<Uint8List> encrypt(String message) async {
    final raw = Uint8List.fromList(message.codeUnits);
    final box = await _aesGcm.encrypt(raw, secretKey: _key);
    return box.concatenation();
  }

  Future<String> decrypt(Uint8List bytes) async {
    final box = crypto.SecretBox.fromConcatenation(
      bytes,
      nonceLength: 12,
      macLength: 16,
    );
    final raw = await _aesGcm.decrypt(box, secretKey: _key);
    return String.fromCharCodes(raw);
  }
}

/// I had to add this class even though it's unused in the client side, so dio
/// and retrofit won't yell at me. Please don't use it;
class PublicKey {
  String id;
  String jwk;

  PublicKey(this.id, this.jwk);

  factory PublicKey.fromJson(Map<String, dynamic> json) =>
      PublicKey(json['id']!, json['jwk']!);

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'jwk': jwk};
}
