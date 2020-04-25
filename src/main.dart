import 'dart:io';

typedef void Handler(HttpRequest request);

main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);
  var map = {
    ["/", "/home", "/index"]: home,
    ["/error"]: error
  };
  var handlers = {
    for (var entry in map.entries) for (var path in entry.key) path: entry.value
  };
  print(handlers);
  await for (HttpRequest request in server) {
    print("${request.method} ${request.uri}");
    if (handlers.containsKey(request.uri.toString()))
      handlers[request.uri.toString()](request);
    else
      handlers["/error"](request);
  }
}

void home(HttpRequest request) async {
  request.response.write("<h1>Welcome to AroMatic</h1>");
  await request.response.close();
}

void error(HttpRequest request) async {
  request.response.write("<h1>An error occured</h1>");
  await request.response.close();
}
