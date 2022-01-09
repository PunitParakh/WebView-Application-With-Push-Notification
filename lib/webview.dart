
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class Webpage extends StatefulWidget{
  @override
  State<Webpage> createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  late WebViewController _controll;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  bool _hasInternet = false;
  

  @override
  void initState() {
    InternetConnectionChecker().onStatusChange.listen((event) { 
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() => _hasInternet = hasInternet);
    });
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        var value = await _controll.canGoBack();
        if(value)
        {
          _controll.goBack(); // perform webview back operation
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Stack(
          children: [ 
            Opacity(
                opacity: _hasInternet? 0.0:1.0,
                child: Material(
                  child: Container(
                    //decoration: BoxDecoration(color: Colors.white ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/no.png",
                        fit: BoxFit.fitHeight),
                        SizedBox(height: 20),
                        Text("Oops!",style: TextStyle(fontSize: 50,color: Colors.black,fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        Text("Please Check Your Internet Connection",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                        SizedBox(height: 100),
                        
                        ]
                      ),
                    ),
                  ),
                ),
              ),
            Opacity(
              opacity: _hasInternet?0.1:0.0,
              child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed:openwhatsapp,
                child: Image.asset("assets/whatsapp.png"),
                backgroundColor: Colors.green,
                ),
              //appBar: AppBar(title: const Text( 'Webview Back Button '),),
              body: WebView(
              initialUrl: 'https://ujwalbhavishya.com/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: ( webViewController) {
                _controll=webViewController;
                _controll.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
                _controll.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
                  
              },
              onProgress: (int progress) {
                  
                print("WebView is loading (progress : $progress%)");
                print("--------------------$notificationBody");
                _controll.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
                _controll.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
              },
              javascriptChannels: {
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
                _controll.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
                _controll.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                _controll.evaluateJavascript("document.getElementsByTagName('header')[0].style.display='none'");
                _controll.evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
              },
              gestureNavigationEnabled: true,
                ),
                      ),
            ),
          
          ]
        ),
      ),
    );


  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  openwhatsapp() async{
  var whatsapp ="+917385738599";
  var whatsappURl_android = "https://wa.me/$whatsapp?text=I'm%20interested";

    // if( await canLaunch(whatsappURl_android)){
      await launch(whatsappURl_android);
    // }else{
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: new Text("something went wrong")));

    // }


  

}
}