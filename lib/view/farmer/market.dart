import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/market_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String getYears(String date) {
  final now = DateTime.now();
  final birthDate = DateTime.parse(date);
  final difference = now.difference(birthDate);
  final years = (difference.inDays / 365).floor();
  return years.toString();
}

class MarketPage extends HookConsumerWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> toggleValue = useState<int>(0);

    ValueNotifier<bool> isLoading = useState(false);

    final marketControllerW = ref.watch(marketController);
    final marketcows = marketControllerW.marketcows;

    Future<void> init() async {
      isLoading.value = true;
      await marketControllerW.getUserCows(context);

      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
      appBar: isLoading.value
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white, // To blend with the background
              centerTitle: true,
              title: Text(
                "પશુ બાઝાર",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: FlutterToggleTab(
                  unSelectedBackgroundColors: [
                    Color(0xffeaf4f5),
                    Color(0xffeaf4f5),
                    Color(0xffeaf4f5),
                  ],
                  marginSelected: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  borderRadius: 20,
                  width: 80,
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  unSelectedTextStyle: TextStyle(
                      color: Color(0xff3e897f),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  selectedIndex: toggleValue.value,
                  selectedBackgroundColors: [
                    Color(0xff3e897f),
                    Color(0xff3e897f),
                    Color(0xff3e897f),
                    Color(0xff3e897f),
                  ],
                  // minWidth: 100.0,

                  dataTabs: [
                    DataTab(
                      title: "Cow",
                    ),
                    DataTab(
                      title: "Food",
                    ),
                    DataTab(
                      title: "Medicine",
                    ),
                  ],
                  // radiusStyle: true,
                  selectedLabelIndex: (index) {
                    toggleValue.value = index;
                  },
                  isScroll: false,
                ),
              ),
            ),
      body: isLoading.value
          ? Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    if (toggleValue.value == 0) ...[
                      for (var cow in marketcows) ...[
                        MarketCowCard(
                          id: cow["cow"]["id"],
                          photo: cow["cow"]["photocover"],
                          name: cow["cow"]["cowname"],
                          price: cow["price"].toString(),
                          age: getYears(cow["cow"]["birthdate"]),
                          location: "Silvasa",
                          milk: cow["cow"]["daily_milk_produce"].toString(),
                          biyat: cow["cow"]["noofcalves"].toString(),
                        ),
                      ],
                    ],
                    if (toggleValue.value == 1) ...[
                      MarketMedicineCard(
                        id: 1,
                        url: "assets/food/1.jpg",
                        name: "FAT15000 - Premium Kacchi Binola Khal - 40 Kg",
                        price: "1590 (39.75/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 2,
                        url: "assets/food/2.jpg",
                        name: "Binola Khal - 44 Kg",
                        price: "1445 (32.84/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 3,
                        url: "assets/food/3.jpg",
                        name: "FAT11000 - Binola Khal - 40 Kg",
                        price: "1530 (38.25/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 4,
                        url: "assets/food/4.jpg",
                        name: "Premium Chana Churi - 50 Kg",
                        price: "2230 (44.60/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 5,
                        url: "assets/food/5.jpg",
                        name: "Rajdhani Chana Churi - 50 Kg",
                        price: "2255 (45.10/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 6,
                        url: "assets/food/6.jpg",
                        name: "Soya Chilka - 40 Kg",
                        price: "1010 (25.25/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 7,
                        url: "assets/food/7.jpg",
                        name: "Baarik Chokar - 40 Kg",
                        price: "1245 (31.13/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 8,
                        url: "assets/food/8.jpg",
                        name: "Sarso Ki Khal - 40 Kg",
                        price: "1290 (32.75/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 9,
                        url: "assets/food/9.jpg",
                        name: "Santulit 8000 pellet - 50 Kg",
                        price: "1295 (25.90/Kg)",
                      ),
                      MarketMedicineCard(
                        id: 10,
                        url: "assets/food/10.jpg",
                        name: "Ganga jamuna Chana Churi - 50 Kg",
                        price: "2250 (45.00/Kg)",
                      ),
                    ],
                    if (toggleValue.value == 2) ...[
                      MarketMedicineCard(
                        id: 1,
                        url: "assets/medicine/1.jpg",
                        name: "Masti Aid Plus",
                        price: "340",
                      ),
                      MarketMedicineCard(
                        id: 2,
                        url: "assets/medicine/2.jpg",
                        name: "Heat Bolus for cows (10 Bolus)",
                        price: "199",
                      ),
                      MarketMedicineCard(
                        id: 3,
                        url: "assets/medicine/3.jpg",
                        name: "Caliber (Calcium Supplement) 5 Ltr",
                        price: "725",
                      ),
                      MarketMedicineCard(
                        id: 4,
                        url: "assets/medicine/4.jpg",
                        name: "Mastasol Targeting Mastitis",
                        price: "330",
                      ),
                      MarketMedicineCard(
                        id: 5,
                        url: "assets/medicine/5.png",
                        name: "Calci - 15000 - 5 Ltr",
                        price: "695",
                      ),
                      MarketMedicineCard(
                        id: 6,
                        url: "assets/medicine/6.jpg",
                        name: "Poshak Tatwa - 0.3 Kg",
                        price: "230",
                      ),
                      MarketMedicineCard(
                        id: 7,
                        url: "assets/medicine/7.jpg",
                        name: "Pachak Tatwa - 0.2 Kg",
                        price: "160",
                      ),
                      MarketMedicineCard(
                        id: 8,
                        url: "assets/medicine/8.jpg",
                        name: "Livtherapy Ayurvedic Syrup -  0.2 Kg",
                        price: "165",
                      ),
                      MarketMedicineCard(
                        id: 9,
                        url: "assets/medicine/9.png",
                        name: "Deworming Tablets (10 Tablets)",
                        price: "130",
                      ),
                      MarketMedicineCard(
                        id: 10,
                        url: "assets/medicine/10.jpg",
                        name: "Calup Gel (Calcium) 300g - 0.9 Kg",
                        price: "625",
                      ),
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}

class TopCowCard extends HookConsumerWidget {
  final String url;
  final String name;
  const TopCowCard({
    super.key,
    required this.url,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              url,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class MarketCowCard extends HookConsumerWidget {
  final int id;
  final String photo;
  final String name;
  final String price;
  final String age;
  final String location;
  final String milk;
  final String biyat;
  const MarketCowCard({
    super.key,
    required this.id,
    required this.photo,
    required this.name,
    required this.price,
    required this.age,
    required this.location,
    required this.milk,
    required this.biyat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.6),
            spreadRadius: 4,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                // add only top border
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: url + photo,
                  height: 200,
                  width: size.width,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(6),
                    // left red border only
                    border: Border(
                      left: BorderSide(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Text(
                    "VERIFIED",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xfffdfeb9),
                    borderRadius: BorderRadius.circular(6),
                    // left red border only
                    border: Border(
                      left: BorderSide(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Text(
                    "Added 1 WEEK(S) AGO",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "\u{20B9} $price",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Biyat: $biyat",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "Age: $age Yr",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Milk : $milk/day",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(RouteNames.payment);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.message_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Buy / Book Now",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MarketMedicineCard extends HookConsumerWidget {
  final int id;
  final String url;
  final String name;
  final String price;

  const MarketMedicineCard({
    super.key,
    required this.id,
    required this.url,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.6),
            spreadRadius: 4,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            // add only top border
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              url,
              width: size.width,
              height: 200,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textScaler: TextScaler.linear(1),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(
                      "\u{20B9} $price",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "Buy / Book Now",
                            textScaler: TextScaler.linear(1),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          // Spacer(),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
