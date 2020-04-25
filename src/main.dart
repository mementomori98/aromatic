import 'dart:io';

typedef void Handler(HttpRequest request);

main() async {
  print('Application started...');
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 4040 : int.parse(portEnv);
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Server listening on port $port');

  var controller = getController();
  print('Got controller');
  await for (HttpRequest request in server) {
    print('In the request!');
    print("${request.method} ${request.uri}");
    request.response.headers.contentType =
        new ContentType("text", "html", charset: "utf-8");
    if (controller.containsKey(request.uri.toString()))
      controller[request.uri.toString()](request);
    else
      controller["/error"](request);
  }
}

Map<String, Function> getController() {
  var map = {
    ["/", "/home", "/index"]: home,
    ["/error"]: error
  };
  var handlers = {
    for (var entry in map.entries) for (var path in entry.key) path: entry.value
  };
  return handlers;
}

void home(HttpRequest request) async {
  request.response.write('<h1>Welcome to AroMatic</h1>');
  await request.response.close();
}

void error(HttpRequest request) async {
  request.response.write('<h1">An error occured</h1>');

  await request.response.close();
}
