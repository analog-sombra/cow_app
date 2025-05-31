import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/state/cow_controller.dart';
import 'package:gaay/utils/const.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class CowTreatment extends HookConsumerWidget {
  final int id;
  const CowTreatment({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    String capitalize(String s) {
      if (s.isEmpty) return s;
      return s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    ValueNotifier<bool> isLoading = useState(false);

    final cowControllerW = ref.watch(cowController);
    final cow = cowControllerW.cow;
    Future<void> init() async {
      isLoading.value = true;
      await cowControllerW.getCow(context, id);
      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    AnimationController controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    final opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    useEffect(() {
      controller.forward();
      return null;
    }, []);

    ValueNotifier<int> toggleValue = useState<int>(0);

    // get years from date
    String getYears(String date) {
      final now = DateTime.now();
      final birthDate = DateTime.parse(date);
      final difference = now.difference(birthDate);
      final years = (difference.inDays / 365).floor();
      return years.toString();
    }

    return Scaffold(
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
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CachedNetworkImage(
                        imageUrl: url + cow["photocover"],
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: size.height * 0.4,
                        width: size.width,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: size.height * 0.6,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaler: TextScaler.linear(1),
                          ),
                          child: SingleChildScrollView(
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: TextScaler.linear(1)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Center(
                                          child: FlutterToggleTab(
                                            unSelectedBackgroundColors: [
                                              Color(0xffeaf4f5),
                                              Color(0xffeaf4f5),
                                              Color(0xffeaf4f5),
                                            ],
                                            marginSelected:
                                                EdgeInsets.symmetric(
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
                                                title: "Overview",
                                              ),
                                              DataTab(
                                                title: "Health",
                                              ),
                                              DataTab(
                                                title: "History",
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
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Opacity(
                                          opacity: opacityAnimation.value,
                                          child: SlideTransition(
                                            position: slideAnimation,
                                            child: Text(
                                              cow["cowname"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 38,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Opacity(
                                          opacity: opacityAnimation.value,
                                          child: SlideTransition(
                                            position: slideAnimation,
                                            child: Text(
                                              "${cow["breed"]["name"]} - ${capitalize(cow["sex"])} - ${getYears(cow["birthdate"])} yrs",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (toggleValue.value == 0) ...[
                                        SizedBox(height: 10),
                                        Opacity(
                                          opacity: opacityAnimation.value,
                                          child: SlideTransition(
                                            position: slideAnimation,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                              ),
                                              child: Text(
                                                "ગાયનું નામ ${cow["cowname"]}, ઉંમર ${getYears(cow["birthdate"])} છે અને તેનું વજન ${cow["weight"]} કિગ્રામ છે. છેલ્લી કૃમિનાશક તારીખ ${cow["cow_health_report"].length != 0 ? DateFormat('d-MM-yyyy').format(
                                                    DateTime.parse(cow[
                                                            "cow_health_report"][0]
                                                        [
                                                        "last_deworming_date"]),
                                                  ) : "-"} છે, અને છેલ્લું રસીકરણ ${cow["cow_health_report"].length != 0 ? DateFormat('d-MM-yyyy').format(
                                                    DateTime.parse(
                                                      cow["cow_health_report"]
                                                              [0]
                                                          ["last_vaccine_date"],
                                                    ),
                                                  ) : "-"} તારીખે કરવામાં આવી હતું.",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 10),
                                      if (toggleValue.value == 0) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.black
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            // borderRadius: BorderRadius.circular(20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffccebcc),
                                                    ),
                                                    child: Text(
                                                      "Details",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  CowTableData(
                                                    title: cow["cowtagno"],
                                                    status: "Ear Tag",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title: DateFormat(
                                                            'd-MM-yyyy')
                                                        .format(DateTime.parse(
                                                            cow["birthdate"])),
                                                    status: "Birth Date",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title: cow["noofcalves"]
                                                        .toString(),
                                                    status: "No. Of Calves",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        "${cow["weight"]} KG",
                                                    status: "Weight ",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_vaccine_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Last Vaccination",
                                                    isBorder: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (toggleValue.value == 1) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.black
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            // borderRadius: BorderRadius.circular(20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffccebcc),
                                                    ),
                                                    child: Text(
                                                      "Details",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_vaccine_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Last Vaccination",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_deworming_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "DeWorming Date",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "heat_period"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Heat Period",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_treatment_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Last Sickness",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_calf_birthdate"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Last Calvin Date",
                                                    isBorder: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (toggleValue.value == 2) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.black
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            // borderRadius: BorderRadius.circular(20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffccebcc),
                                                    ),
                                                    child: Text(
                                                      "Details",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "last_deworming_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Date of Deworming",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "food_and_mouth_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status:
                                                        "Foot & Mouth Disease",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "hemorrhagic_septicemia_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status:
                                                        "Hemorrhagic Septicemia",
                                                    isBorder: true,
                                                  ),
                                                  CowTableData(
                                                    title:
                                                        cow["cow_health_report"]
                                                                    .length !=
                                                                0
                                                            ? DateFormat(
                                                                    'd-MM-yyyy')
                                                                .format(
                                                                DateTime.parse(
                                                                  cow["cow_health_report"]
                                                                          [0][
                                                                      "black_quarter_date"],
                                                                ),
                                                              )
                                                            : "-",
                                                    status: "Black Quarter",
                                                    isBorder: true,
                                                  ),
                                                  if (cow["cow_health_report"]
                                                              [0][
                                                          "brucellossis_date"] !=
                                                      null) ...[
                                                    CowTableData(
                                                      title:
                                                          cow["cow_health_report"]
                                                                      .length !=
                                                                  0
                                                              ? DateFormat(
                                                                      'd-MM-yyyy')
                                                                  .format(
                                                                  DateTime
                                                                      .parse(
                                                                    cow["cow_health_report"]
                                                                            [0][
                                                                        "brucellossis_date"],
                                                                  ),
                                                                )
                                                              : "-",
                                                      status: "Brucellosis",
                                                      isBorder: true,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff3e897f),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            context.pushNamed(
                                              RouteNames.cowhealthform,
                                              pathParameters: {
                                                "id": id.toString()
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Add Treatment",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CowTableData extends HookConsumerWidget {
  final bool isBorder;
  final String title;
  final String status;
  const CowTableData({
    super.key,
    required this.title,
    required this.status,
    required this.isBorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xffccebcc),
                border: isBorder
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.2),
                      )
                    : null,
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textScaler: TextScaler.linear(1),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                border: isBorder
                    ? Border.all(
                        color: Colors.black.withValues(alpha: 0.2),
                      )
                    : null,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
                textScaler: TextScaler.linear(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
