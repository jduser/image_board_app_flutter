import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


Future<Widget> getImage(String imageUrl) async {
  http.Response response = await http.get(imageUrl);                                      
  
  if (response.statusCode == 200) {
    return Image.network(imageUrl);
  } else {
    return Icon(Icons.broken_image);
  }
}


Image getFullImage(String imageUrl) {

  return Image.network(imageUrl, 
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(),
          );
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Icon(Icons.broken_image);
      },
  );
}
