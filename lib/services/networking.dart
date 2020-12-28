import 'package:http/http.dart' as http;
import 'dart:convert';

class BinDetails {
  BinDetails({this.url});
  String url;
  Future getCardMetadata() async {
    try {
      http.Response response = await http.get(
        url,
        headers: {
          'Accept-Version': '3',
        },
      );
      if (response.statusCode == 200) {
        String data = response.body;
        print(jsonDecode(data));
        return jsonDecode(data);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
