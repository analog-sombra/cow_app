import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gaay/components/doctorpopover.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/medical_controller.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

enum MEDICALSTATUS { TODAY, PENDING, COMPLETED }

class DoctorHome extends HookConsumerWidget {
  const DoctorHome({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> isLoading = useState(false);

    Size size = MediaQuery.of(context).size;

    ValueNotifier<int> toggleValue = useState<int>(0);
    ValueNotifier<MEDICALSTATUS> status =
        useState<MEDICALSTATUS>(MEDICALSTATUS.TODAY);

    final userControllerW = ref.watch(userController);
    final medicalControllerW = ref.watch(medicalController);
    final user = userControllerW.user;
    final cows = medicalControllerW.cows;

    Future<void> init() async {
      isLoading.value = true;
      await userControllerW.getUser(context);

      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    Future<void> initcows() async {
      if (!context.mounted) return;
      await medicalControllerW.getDoctorMedicalRequest(
          context, status.value.name);
    }

    useEffect(() {
      initcows();
      return null;
    }, [status.value]);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: isLoading.value
          ? null
          : user == null
              ? null
              : AppBar(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.white, // To blend with the background
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
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            textScaler: TextScaler.linear(1),
                            style: TextStyle(
                              fontSize: 16,
                              height: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "નમસ્તે ${user["alias"]}",
                            textScaler: TextScaler.linear(1),
                            style: TextStyle(
                              fontSize: 24,
                              height: 1,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      DcotorPopMenuButton()
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(100),
                    child: Column(
                      children: [
                        FlutterToggleTab(
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
                          width: (size.width - 150) / 3,
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
                              title: "Today",
                            ),
                            DataTab(
                              title: "Pending",
                            ),
                            DataTab(
                              title: "Completed",
                            ),
                          ],
                          // radiusStyle: true,
                          selectedLabelIndex: (index) {
                            toggleValue.value = index;
                            status.value = MEDICALSTATUS.values[index];
                          },
                          isScroll: false,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Text(
                                DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(DateTime.now().toString())),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
      body: CustomMaterialIndicator(
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
                      for (var cow in cows)
                        TreatmentsCard(
                          id: cow["id"],
                          photo: cow["cow"]["photocover"],
                          name: cow["cow"]["cowname"],
                          type: cow["reason"],
                          date: cow["date"],
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class TreatmentsCard extends HookConsumerWidget {
  final int id;
  final String photo;
  final String name;
  final String type;
  final String date;

  const TreatmentsCard({
    super.key,
    required this.photo,
    required this.name,
    required this.id,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.cowtreatment,
          pathParameters: {"id": id.toString()},
        );
      },
      child: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: url + photo,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ગાયનું નામ : $name",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                      Text(
                        "Request Type - $type",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(1),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xfffeefd2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Date - ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(date))}",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
