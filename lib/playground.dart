import 'dart:async';

import 'package:http/http.dart' as http;

main(var args) {
//  var google = getGoogleHomePage();
//  print("${(google == null)} 'second instance");
  getAllNames();
  countTo100().then((res) {
    var va = res;
    print(va.reversed);
    print(va.toString());
  });

  getGoogleHomePage().then((response) {
    print(response == null);
  });
  var happ = ["joy", "ikotun", "egbe"];
  print(happ.toString());

//  var d = await countTo100();
//  await d.sort();
//  print( await d);
//  print(await d.length);

  print("happy and last on the list");
}

Future<void> getAllNames() {
  return Future.delayed(Duration(seconds: 1), () {
    return print(["Ayo", "Jero", "Ajani", "Abubakar"].toString());
  });
}

Future<dynamic> getGoogleHomePage() async {
  const url = "http://www.goole.com";
  var response = await http.get(url);
  var finishedResponse = response.body.toString();
  return finishedResponse;
}

Future<List<int>> countTo100() async {
  Completer<List<int>> b = Completer();
  List<int> numArray = [];
  for (int i = 0; i < 100; i++) {
    numArray.add(i + 1);
  }
  Timer(Duration(seconds: 17), (){
    b.complete(numArray);
  });
  return b.future;
}
