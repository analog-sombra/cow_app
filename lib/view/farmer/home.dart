import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/components/popover.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    ValueNotifier<bool> isLoading = useState(false);

    final userControllerW = ref.watch(userController);
    final cowControllerW = ref.watch(cowController);
    final user = userControllerW.user;
    final cows = cowControllerW.cows;

    Future<void> init() async {
      isLoading.value = true;
      await userControllerW.getUser(context);
      if (!context.mounted) return;
      await cowControllerW.getUserCows(context);
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLoading.value
          ? null
          : user == null
              ? null
              : AppBar(
                  elevation: 0,
                  backgroundColor:
                      Colors.transparent, // To blend with the background
                  centerTitle: true,
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: url + user["photo"],
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          width: 30,
                          height: 30,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "નમસ્તે ${user["alias"]}",
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                          fontSize: 22,
                          height: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      PopMenuButton()
                    ],
                  ),
                ),
      body: CustomMaterialIndicator(
        // backgroundColor: Colors.red,
        // color: Colors.white,
        onRefresh: () async {
          await init(); // Fetch fresh data
        },
        child: SafeArea(
          child: isLoading.value
              ? Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(20),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/health.jpg"),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "29\u2103",
                              style: TextStyle(height: 1, fontSize: 28),
                              textScaler: TextScaler.linear(1),
                            ),
                            Text(
                              "Sunny",
                              style: TextStyle(height: 1, fontSize: 28),
                              textScaler: TextScaler.linear(1),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardInfo(
                                  title: "Humidity",
                                  status: "Good",
                                ),
                                CardInfo(
                                  title: "Soil Moisture",
                                  status: "Good",
                                ),
                                CardInfo(
                                  title: "Preciptation",
                                  status: "Low",
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Color(0xfffaf5f1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "મારી ગાય",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (cows.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "કોઈ ગાય મળી નથી",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textScaler: TextScaler.linear(1),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children: [
                                  for (var cow in cows)
                                    CowCard(
                                      id: cow["id"],
                                      photo: cow["photocover"],
                                      name: cow["cowname"],
                                      cowstatus: cow["cowstatus"],
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CardInfo extends HookConsumerWidget {
  final String title;
  final String status;
  const CardInfo({
    super.key,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textScaler: TextScaler.linear(1),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Text(
            status,
            textScaler: TextScaler.linear(1),
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}

class CowCard extends HookConsumerWidget {
  final int id;
  final String photo;
  final String name;
  final String cowstatus;
  const CowCard({
    super.key,
    required this.photo,
    required this.name,
    required this.id,
    required this.cowstatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.details,
          pathParameters: {"id": id.toString()},
        );
      },
      child: Container(
        width: (size.width * 0.53) - 40,
        height: (size.height * 0.22),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: cowstatus == "ALIVE"
                ? Colors.green
                : cowstatus == "DEAD"
                    ? Colors.red
                    : Colors.orange,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: url + photo,
                height: 105,
                // width: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w400,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ],
        ),
      ),
    );
  }
}
