import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import '../../core/config/imgbb_config.dart';
import 'base_product_repository.dart';


class StorageRepository implements BaseStorageRepository {
  @override
  Future<String?> uploadProductImage(File imageFile) async {
    try {
      // نجهّز الرابط + مفتاح API
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=${ImgbbConfig.apiKey}');

      // نجهّز الطلب لإرسال الصورة
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ));

      // نرسل الطلب
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final data = json.decode(resBody);

      // إذا نجح الرفع ✅
      if (response.statusCode == 200) {
        return data['data']['url']; // نرجع رابط الصورة
      } else {
        print('❌ فشل رفع الصورة: ${data['error']['message']}');
        return null;
      }
    } catch (e) {
      print('⚠️ استثناء أثناء الرفع: $e');
      return null;
    }
  }
}
