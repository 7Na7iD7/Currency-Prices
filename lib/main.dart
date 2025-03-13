import 'package:basics/Model/Currrncy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizations Sample App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), // Farsi
      ],
      theme: ThemeData(
        fontFamily: 'Dana',
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Dana',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Dana',
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Dana',
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));
    developer.log(value.body, name: "main");

    if (currency.isEmpty && value.statusCode == 200) {
      _showSnackBar(context, "بروزرسانی اطلاعات با موفقیت انجام شد");
      developer.log(value.body,
          name: "getResponse", error: convert.jsonDecode(value.body));

      List jsonList = convert.jsonDecode(value.body);

      if (jsonList.isNotEmpty) {
        setState(() {
          currency = jsonList
              .map((data) => Currency(
            id: data["id"],
            title: data["title"],
            price: data["price"],
            changes: data["changes"],
            status: data["status"],
          ))
              .toList();
        });
      }
    }
    return value;
  }

  void intStte() {
    super.initState();
    developer.log("intState", name: "wlifeCycle");
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    developer.log("didUpdateWidget", name: "wlifeCycle");
  }

  @override
  void deactivate() {
    super.deactivate();
    developer.log("deactivate", name: "wlifeCycle");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    developer.log("didChangeDependencies", name: "wlifeCycle");
  }

  @override
  void dispose() {
    super.dispose();
    developer.log("dispose", name: "wlifeCycle");
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: currency.length,
          itemBuilder: (BuildContext context, int position) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: MyItem(position, currency),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            if (index % 9 == 0) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Add(),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        )
            : const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getResponse(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Image.asset("assets/images/icon.png"),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "قیمت بروز سکه و ارز",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/images/menu.png"),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/q.png"),
                  SizedBox(width: 8),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.displayLarge,
                textDirection: Directionality.of(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromARGB(255, 130, 130, 130),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("نام آزاد ارز",
                          style: Theme.of(context).textTheme.displayMedium),
                      Text("قیمت",
                          style: Theme.of(context).textTheme.displayMedium),
                      Text("تغییر",
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/2,
                child: listFutureBuilder(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/16,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height/16,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color.fromARGB(255, 202, 193, 255),
                            ),
                          ),
                          onPressed: () {
                            currency.clear();
                            listFutureBuilder(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh_bold,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              "بروزرسانی",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                      Text(" آخرین بروزرسانی: ${_getTime()}"),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTime() {
    return DateTime.now().toString().substring(11, 16);
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class MyItem extends StatelessWidget {
  final int position;
  final List<Currency> currency;

  MyItem(this.position, this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.grey,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(getFarsiNumber(currency[position].title ?? ""),
              style: Theme.of(context).textTheme.bodyMedium),
          Text(getFarsiNumber(currency[position].price ?? ""),
              style: Theme.of(context).textTheme.bodyMedium),
          Text(
            getFarsiNumber(currency[position].changes ?? ""),
            style: currency[position].status == "n"
                ? Theme.of(context).textTheme.displaySmall
                : Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(1000),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.grey,
          ),
        ],
      ),
      child: Center(
        child:
        Text("تبلیغات", style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }
}

String getFarsiNumber(String number) {
  const en = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  const fa = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });

  return number;
}