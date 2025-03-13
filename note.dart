// دفتر یادداشت کد Flutter - برنامه نرخ ارز
// توضیح کلی: این کد یه اپلیکیشن Flutter برای نشون دادن نرخ ارز آزاد با زبان فارسی و طراحی قشنگه. از یه API داده می‌گیره و توی یه لیست با امکان تازه کردن نشون می‌ده.

// وارد کردن پکیج‌های مورد نیاز
import 'package:basics/Model/Currrncy.dart'; // چرا؟ برای مدل داده ارزها که بفهمیم هر ارز چه اطلاعاتی داره (فک کنم باید `Currency.dart` باشه، اشتباه تایپیه)
import 'package:flutter/cupertino.dart'; // چرا؟ برای آیکونای قشنگ مثل دکمه تازه کردن که شبیه iOS باشه
import 'package:flutter/material.dart'; // چرا؟ برای ساختن ظاهر برنامه با چیزای متریال مثل نوار بالا و بدنه
import 'package:flutter_localizations/flutter_localizations.dart'; // چرا؟ برای اینکه برنامه فارسی بشه و متناش راست‌چین باشن
import 'package:http/http.dart' as http; // چرا؟ برای گرفتن داده از API
import 'dart:convert'
    as convert; // چرا؟ برای اینکه داده JSON رو به چیزی که بشه باهاش کار کرد تبدیل کنیم
import 'dart:developer'as developer;

// نقطه شروع برنامه
void main() {
  // چرا؟ برای اینکه برنامه از اینجا شروع بشه
  runApp(MyApp()); // چرا؟ برای اینکه برنامه اصلیمون (`MyApp`) رو اجرا کنیم
}

// ویجت اصلی برنامه (Stateless)
class MyApp extends StatelessWidget {
  // چرا؟ برای تنظیمات اصلی برنامه که قراره ثابت بمونن
  @override
  Widget build(BuildContext context) {
    // چرا؟ برای ساختن ظاهر اولیه برنامه
    return MaterialApp(
      // چرا؟ برای راه انداختن یه اپ متریال با تم و اینجور چیزا
      title:
          'Localizations Sample App', // چرا؟ برای اینکه یه اسم به برنامه بدیم (فعلاً یه چیز نمونه‌ست)
      localizationsDelegates: [
        // چرا؟ برای اینکه فارسی رو تو برنامه فعال کنیم
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', '')
      ], // چرا؟ برای اینکه فقط فارسی رو ساپورت کنه و راست‌چین بشه
      theme: ThemeData(
        // چرا؟ برای تنظیم فونت و استایلای کلی برنامه
        fontFamily:
            'Dana', // چرا؟ برای اینکه فونت قشنگ Dana رو همه‌جا استفاده کنیم
        textTheme: TextTheme(
          // چرا؟ برای تنظیم مدلای مختلف متن تو برنامه
          displayLarge: TextStyle(
              fontFamily: 'Dana',
              fontSize: 16,
              fontWeight:
                  FontWeight.w700), // چرا؟ برای متنای بزرگ و پررنگ مثل عنوانا
          bodyMedium: TextStyle(
              fontFamily: 'Dana',
              fontSize: 13,
              fontWeight: FontWeight.w300), // چرا؟ برای متنای معمولی و سبک
          displayMedium: TextStyle(
              fontFamily: 'Dana',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w300), // چرا؟ برای متن سفید تو سرستون‌ها
          displaySmall: TextStyle(
              fontFamily: 'Dana',
              fontSize: 14,
              color: Colors.red,
              fontWeight:
                  FontWeight.w700), // چرا؟ برای تغییرات منفی با رنگ قرمز
          headlineLarge: TextStyle(
              fontFamily: 'Dana',
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w700), // چرا؟ برای تغییرات مثبت با رنگ سبز
        ),
      ),
      debugShowCheckedModeBanner:
          false, // چرا؟ برای اینکه بنر دیباگ رو نبینیم و برنامه شیک باشه
      home: Home(), // چرا؟ برای اینکه صفحه اصلی برنامه `Home` باشه
    );
  }
}

// ویجت صفحه اصلی (Stateful)
class Home extends StatefulWidget {
  // چرا؟ برای اینکه صفحه‌مون بتونه تغییر کنه و داده‌هاش عوض بشه
  @override
  State<Home> createState() =>
      _HomeState(); // چرا؟ برای اینکه حالت صفحه رو تعریف کنیم
}

class _HomeState extends State<Home> {
  // چرا؟ برای اینکه داده‌ها و رفتارای صفحه رو مدیریت کنیم
  List<Currency> currency =
      []; // چرا؟ برای اینکه لیست ارزهایی که از API می‌گیرم رو نگه دارم

  Future getResponse(BuildContext cntx) async {
    // چرا؟ برای اینکه داده‌ها رو از API بگیرم بدون اینکه برنامه قفل کنه
    var url =
        "http://sasansafari.com/flutter/api.php?access_key=flutter123456"; // چرا؟ برای اینکه بگم از کجا داده بگیرم
    var value = await http.get(
        Uri.parse(url)); // چرا؟ برای اینکه درخواست رو بفرستم و جوابش رو بگیرم
    developer.log(value.body,
        name: "main"); // چرا؟ برای اینکه ببینم API چی برگردونده و دیباگ کنم
    if (currency.isEmpty && value.statusCode == 200) {
      // چرا؟ برای اینکه اگه لیست خالیه و درخواست اوکی بود، برم جلو
      _showSnackBar(context,
          "بروزرسانی اطلاعات با موفقیت انجام شد"); // چرا؟ برای اینکه به کاربر بگم کار تموم شد
      List jsonList = convert.jsonDecode(
          value.body); // چرا؟ برای اینکه جواب JSON رو به لیست تبدیل کنم
      if (jsonList.isNotEmpty) {
        // چرا؟ برای اینکه مطمئن شم داده داریم
        setState(() {
          // چرا؟ برای اینکه برنامه بفهمه لیست عوض شده و صفحه رو تازه کنه
          currency = jsonList
              .map((data) => Currency(
                    // چرا؟ برای اینکه هر تکه داده رو به یه شیء `Currency` تبدیل کنم
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
    return value; // چرا؟ برای اینکه جواب رو برگردونم اگه لازم شد جای دیگه استفاده کنم
  }

  void intState() {
    // چرا؟ فکر کنم اشتباه تایپی باشه، باید `initState` باشه، برای دیباگ گذاشتم
    super.initState();
    developer.log("intState", name: "wlifeCycle");
  }

  @override
  void initState() {
    // چرا؟ برای اینکه وقتی صفحه بار میاد، کارای اولیه رو انجام بدم
    super.initState();
    getResponse(context); // چرا؟ برای اینکه همون اول داده‌ها رو از API بگیرم
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    // چرا؟ برای اینکه اگه ویجت آپدیت شد، بفهمم و دیباگ کنم
    super.didUpdateWidget(oldWidget);
    developer.log("didUpdateWidget", name: "wlifeCycle");
  }

  @override
  void deactivate() {
    // چرا؟ برای اینکه اگه صفحه غیرفعال شد، بفهمم و دیباگ کنم
    super.deactivate();
    developer.log("deactivate", name: "wlifeCycle");
  }

  @override
  void didChangeDependencies() {
    // چرا؟ برای اینکه تغییرات وابستگی‌ها رو ببینم و دیباگ کنم
    super.didChangeDependencies();
    developer.log("didChangeDependencies", name: "wlifeCycle");
  }

  @override
  void dispose() {
    // چرا؟ برای اینکه وقتی صفحه بسته شد، بفهمم و دیباگ کنم
    super.dispose();
    developer.log("dispose", name: "wlifeCycle");
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    // چرا؟ برای اینکه لیست رو با داده‌های API درست کنم
    return FutureBuilder(
      // چرا؟ برای اینکه داده‌ها رو وقتی آماده شدن نشون بدم
      builder: (context, snapshot) {
        // چرا؟ برای اینکه مشخص کنم چی نشون بدم وقتی داده هست یا نیست
        return snapshot.hasData // چرا؟ برای اینکه چک کنم داده داریم یا نه
            ? ListView.separated(
                // چرا؟ برای اینکه لیست رو با فاصله بین آیتما نشون بدم
                physics:
                    const BouncingScrollPhysics(), // چرا؟ برای اینکه اسکرول یه افکت قشنگ داشته باشه
                itemCount: currency
                    .length, // چرا؟ برای اینکه بگم چند تا آیتم تو لیست دارم
                itemBuilder: (BuildContext context, int position) {
                  // چرا؟ برای اینکه هر آیتم رو درست کنم
                  return Padding(
                    // چرا؟ برای اینکه یه کم فاصله دور آیتم باشه
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: MyItem(position,
                        currency), // چرا؟ برای اینکه هر ارز رو با ویجت خودش نشون بدم
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  // چرا؟ برای اینکه بین آیتما چیزایی مثل تبلیغ بذارم
                  if (index % 9 == 0) {
                    // چرا؟ برای اینکه هر 9 تا یه تبلیغ بذارم
                    return Padding(
                      // چرا؟ برای اینکه تبلیغ فاصله داشته باشه
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Add(), // چرا؟ برای اینکه ویجت تبلیغ رو نشون بدم
                    );
                  } else {
                    return SizedBox
                        .shrink(); // چرا؟ برای اینکه اگه تبلیغ نبود، هیچی نشون نده
                  }
                },
              )
            : const Center(
                child:
                    CircularProgressIndicator()); // چرا؟ برای اینکه وقتی داده نیست، لودینگ نشون بدم
      },
      future:
          getResponse(context), // چرا؟ برای اینکه بگم داده‌ها رو از کجا بگیرم
    );
  }

  @override
  Widget build(BuildContext context) {
    // چرا؟ برای اینکه ظاهر صفحه رو درست کنم
    return Scaffold(
      // چرا؟ برای اینکه یه ساختار اصلی با نوار بالا و بدنه داشته باشم
      backgroundColor: const Color.fromARGB(255, 243, 243,
          243), // چرا؟ برای اینکه پس‌زمینه یه رنگ خاکستری روشن باشه
      appBar: AppBar(
        // چرا؟ برای اینکه نوار بالای صفحه رو درست کنم
        elevation: 0, // چرا؟ برای اینکه سایه زیر نوار نباشه
        backgroundColor: Colors.white, // چرا؟ برای اینکه نوار سفید باشه
        actions: [
          // چرا؟ برای اینکه چیزایی که می‌خوام تو نوار باشه رو بذارم
          Image.asset(
              "assets/images/icon.png"), // چرا؟ برای اینکه یه آیکون کنار عنوان بذارم
          Align(
            // چرا؟ برای اینکه متن رو راست‌چین کنم
            alignment: Alignment.centerRight,
            child: Text("قیمت بروز سکه و ارز",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge), // چرا؟ برای اینکه عنوان برنامه رو نشون بدم
          ),
          Expanded(
            // چرا؟ برای اینکه منو رو سمت چپ ببرم
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                  "assets/images/menu.png"), // چرا؟ برای اینکه دکمه منو رو بذارم
            ),
          ),
          const SizedBox(width: 16), // چرا؟ برای اینکه یه فاصله بذارم آخر خط
        ],
      ),
      body: SingleChildScrollView(
        // چرا؟ برای اینکه بشه تو صفحه اسکرول کرد
        child: Padding(
          // چرا؟ برای اینکه دور محتوا یه کم فاصله باشه
          padding: const EdgeInsets.all(28.0),
          child: Column(
            // چرا؟ برای اینکه چیزا رو زیر هم بچینم
            children: [
              Row(
                // چرا؟ برای اینکه سوال و آیکونش رو کنار هم بذارم
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                      "assets/images/q.png"), // چرا؟ برای اینکه یه آیکون سوال بذارم
                  SizedBox(
                      width: 8), // چرا؟ برای اینکه بین آیکون و متن فاصله باشه
                  Text("نرخ ارز آزاد چیست؟",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge), // چرا؟ برای اینکه سوال رو نشون بدم
                ],
              ),
              SizedBox(height: 12), // چرا؟ برای اینکه یه فاصله عمودی بذارم
              Text(
                // چرا؟ برای اینکه توضیح سوال رو نشون بدم
                "نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.displayLarge,
                textDirection: TextDirection
                    .rtl, // چرا؟ برای اینکه متن فارسی راست‌چین باشه
              ),
              Padding(
                // چرا؟ برای اینکه سرستون‌ها فاصله داشته باشن
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  // چرا؟ برای اینکه سرستون‌ها رو تو یه کادر بذارم
                  width:
                      double.infinity, // چرا؟ برای اینکه کادر کل عرض رو بگیره
                  height: 35, // چرا؟ برای اینکه ارتفاعش مشخص باشه
                  decoration: const BoxDecoration(
                    // چرا؟ برای اینکه کادر رو قشنگ کنم
                    borderRadius: BorderRadius.all(Radius.circular(
                        100)), // چرا؟ برای اینکه گوشه‌ها گرد باشن
                    color: Color.fromARGB(255, 130, 130,
                        130), // چرا؟ برای اینکه رنگ خاکستری بذارم
                  ),
                  child: Row(
                    // چرا؟ برای اینکه سرستون‌ها رو کنار هم بچینم
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("نام آزاد ارز",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium), // چرا؟ برای اینکه عنوان اول رو نشون بدم
                      Text("قیمت",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium), // چرا؟ برای اینکه عنوان دوم رو نشون بدم
                      Text("تغییر",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium), // چرا؟ برای اینکه عنوان سوم رو نشون بدم
                    ],
                  ),
                ),
              ),
              SizedBox(
                // چرا؟ برای اینکه لیست یه فضای مشخص داشته باشه
                width: double.infinity,
                height: 350,
                child: listFutureBuilder(
                    context), // چرا؟ برای اینکه لیست ارزها رو اینجا نشون بدم
              ),
              Padding(
                // چرا؟ برای اینکه دکمه و زمان فاصله داشته باشن
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  // چرا؟ برای اینکه دکمه و زمان رو تو یه کادر بذارم
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      // چرا؟ برای اینکه کادر رو قشنگ کنم
                      color: const Color.fromARGB(255, 232, 232,
                          232), // چرا؟ برای اینکه رنگ خاکستری روشن باشه
                      borderRadius: BorderRadius.circular(
                          1000)), // چرا؟ برای اینکه گوشه‌ها کاملاً گرد باشن
                  child: Row(
                    // چرا؟ برای اینکه دکمه و زمان رو کنار هم بچینم
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // چرا؟ برای اینکه دکمه یه اندازه مشخص داشته باشه
                        height: 50,
                        child: TextButton.icon(
                          // چرا؟ برای اینکه دکمه با آیکون بذارم
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Color.fromARGB(
                                255,
                                202,
                                193,
                                255)), // چرا؟ برای اینکه دکمه رنگ بنفش کم‌رنگ داشته باشه
                          ),
                          onPressed: () {
                            // چرا؟ برای اینکه بگم دکمه چیکار کنه
                            currency
                                .clear(); // چرا؟ برای اینکه لیست رو خالی کنم قبل از تازه کردن
                            listFutureBuilder(
                                context); // چرا؟ برای اینکه لیست رو دوباره بار کنم
                          },
                          icon: const Icon(CupertinoIcons.refresh_bold,
                              color: Colors
                                  .black), // چرا؟ برای اینکه آیکون تازه کردن بذارم
                          label: Padding(
                            // چرا؟ برای اینکه متن دکمه فاصله داشته باشه
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text("بروزرسانی",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge), // چرا؟ برای اینکه بگم دکمه برای تازه کردنه
                          ),
                        ),
                      ),
                      Text(
                          "آخرین بروزرسانی: ${_getTime()}"), // چرا؟ برای اینکه زمان آخرین آپدیت رو نشون بدم
                      SizedBox(
                          width: 8), // چرا؟ برای اینکه یه فاصله آخر خط باشه
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
    // چرا؟ برای اینکه زمان رو نشون بدم
    return "20:45"; // چرا؟ برای اینکه فعلاً یه زمان ثابت بذارم (باید عوضش کنم به زمان واقعی)
  }

  void _showSnackBar(BuildContext context, String msg) {
    // چرا؟ برای اینکه پیام موفقیت رو نشون بدم
    ScaffoldMessenger.of(context).showSnackBar(
      // چرا؟ برای اینکه پیام تو یه نوار پایین صفحه بیاد
      SnackBar(
        content: Text(msg,
            style: Theme.of(context)
                .textTheme
                .headlineSmall), // چرا؟ برای اینکه متن پیام رو با استایل مشخص نشون بدم
        backgroundColor:
            Colors.green, // چرا؟ برای اینکه پیام رنگ سبز داشته باشه و بگه اوکیه
      ),
    );
  }
}

class MyItem extends StatelessWidget {
  // چرا؟ برای اینکه هر ارز رو تو یه ویجت جدا نشون بدم که تغییر نمی‌کنه
  final int position; // چرا؟ برای اینکه بفهمم کدوم ارز رو دارم نشون می‌دم
  final List<Currency> currency; // چرا؟ برای اینکه لیست ارزها رو داشته باشم

  MyItem(this.position,
      this.currency); // چرا؟ برای اینکه موقع ساخت ویجت، موقعیت و لیست رو بگیرم

  @override
  Widget build(BuildContext context) {
    // چرا؟ برای اینکه ظاهر هر ارز رو درست کنم
    return Container(
      // چرا؟ برای اینکه هر ارز تو یه کادر باشه
      width: double.infinity, // چرا؟ برای اینکه کادر کل عرض رو بگیره
      height: 50, // چرا؟ برای اینکه ارتفاعش مشخص باشه
      decoration: BoxDecoration(
        // چرا؟ برای اینکه کادر رو قشنگ کنم
        color: Colors.white, // چرا؟ برای اینکه رنگش سفید باشه
        borderRadius:
            BorderRadius.circular(1000), // چرا؟ برای اینکه گوشه‌ها گرد باشن
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ], // چرا؟ برای اینکه یه سایه کوچیک زیرش باشه
      ),
      child: Row(
        // چرا؟ برای اینکه اسم، قیمت و تغییرات رو کنار هم بچینم
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(currency[position].title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium), // چرا؟ برای اینکه اسم ارز رو نشون بدم
          Text(currency[position].price!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium), // چرا؟ برای اینکه قیمتش رو نشون بدم
          Text(
            // چرا؟ برای اینکه تغییرات رو نشون بدم
            currency[position].changes!,
            style: currency[position].status ==
                    "n" // چرا؟ برای اینکه چک کنم تغییرات منفیه یا نه
                ? Theme.of(context)
                    .textTheme
                    .displaySmall // چرا؟ اگه منفیه قرمز باشه
                : Theme.of(context)
                    .textTheme
                    .headlineLarge, // چرا؟ اگه مثبته سبز باشه
          ),
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  // چرا؟ برای اینکه تبلیغ رو تو یه ویجت جدا نشون بدم
  const Add({super.key}); // چرا؟ برای اینکه ویجت درست ساخته بشه

  @override
  Widget build(BuildContext context) {
    // چرا؟ برای اینکه ظاهر تبلیغ رو درست کنم
    return Container(
      // چرا؟ برای اینکه تبلیغ تو یه کادر باشه
      width: double.infinity, // چرا؟ برای اینکه کل عرض رو بگیره
      height: 50, // چرا؟ برای اینکه ارتفاعش مشخص باشه
      decoration: BoxDecoration(
        // چرا؟ برای اینکه کادر رو قشنگ کنم
        color: Colors.red, // چرا؟ برای اینکه تبلیغ قرمز باشه و جلب توجه کنه
        borderRadius:
            BorderRadius.circular(1000), // چرا؟ برای اینکه گوشه‌ها گرد باشن
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ], // چرا؟ برای اینکه یه سایه زیرش باشه
      ),
      child: Center(
        // چرا؟ برای اینکه متن وسط باشه
        child: Text("تبلیغات",
            style: Theme.of(context)
                .textTheme
                .displayMedium), // چرا؟ برای اینکه بگم این یه تبلیغه
      ),
    );
  }
}
