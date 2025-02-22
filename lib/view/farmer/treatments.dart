import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class TreatmentsPage extends HookConsumerWidget {
  const TreatmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> isLoading = useState(false);

    final cowControllerW = ref.watch(cowController);
    final cows = cowControllerW.cows;

    useEffect(() {
      Future<void> init() async {
        isLoading.value = true;
        await cowControllerW.getUserCows(context);
        isLoading.value = false;
      }

      init();

      return null;
    }, []);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: isLoading.value
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white, // To blend with the background
              centerTitle: true,
              title: Text(
                "આરોગ્ય",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
      body: SafeArea(
        child: isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    for (var cow in cows)
                      TreatmentsCard(
                        id: cow["id"],
                        photo: cow["photocover"],
                        name: cow["cowname"],
                        vaccine: cow["last_vaccine_date"].toString(),
                        milk: cow["daily_milk_produce"].toString(),
                        doctor: cow["last_treatment_date"].toString(),
                      ),
                  ],
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
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}

class TreatmentsCard extends HookConsumerWidget {
  final int id;
  final String photo;
  final String name;
  final String vaccine;
  final String milk;
  final String doctor;

  const TreatmentsCard({
    super.key,
    required this.photo,
    required this.name,
    required this.id,
    required this.vaccine,
    required this.milk,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: url + photo,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 80,
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "ગાયનું નામ : $name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    Text(
                      "છેલ્લી રસીકરણ તારીખ : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(vaccine))}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    Text(
                      "દૂધ ઉત્પદન : ${milk}L/Day",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    Text(
                      "આગામી ડૉક્ટર મુલાકાત : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(doctor))}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await treatmentAlert(context,ref,id);
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xff02cdfd),
                            Color(0xff347fd3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "ડૉક્ટરનો સંપર્ક કરો",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      context.pushNamed(RouteNames.details,
                          pathParameters: {"id": id.toString()});
                    },
                    child: Container(
                      // width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xff02cdfd),
                            Color(0xff347fd3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "વધુ વિગતો જુઓ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
