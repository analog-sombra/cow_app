import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/market_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String getYears(String date) {
  final now = DateTime.now();
  final birthDate = DateTime.parse(date);
  final difference = now.difference(birthDate);
  final years = (difference.inDays / 365).floor();
  return years.toString();
}

class CowHome extends HookConsumerWidget {
  const CowHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> isLoading = useState(false);

    final marketControllerW = ref.watch(marketController);
    final marketcows = marketControllerW.marketcows;

    Future<void> init() async {
      isLoading.value = true;
      await marketControllerW.getAllMarketCowByUser(context);

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
                "My Cow",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
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
          : CustomMaterialIndicator(
              onRefresh: () async {
                await init(); // Fetch fresh data
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      if (marketcows.isEmpty) ...[
                        Center(
                          child: Text(
                            "No Cows Available",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
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
                  ),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
