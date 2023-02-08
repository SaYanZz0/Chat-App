import 'package:chat/src/services/encryption/encryption_service.impl.dart';
import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IEncryption sut;
  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = EncryptionService(encrypter);
  });

  test('it encryptes plain text', () {
    const text = 'this is what we gonna encrypte';
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
    final enc = sut.encrypt(text);
    expect(base64.hasMatch(enc), true);
  });

  test('it decrypte the plain  text', () {
    const text = 'The is our text';
    final encrypted = sut.encrypt(text);
    final decrypted = sut.decrypt(encrypted);
    expect(decrypted, text);
  });
}
