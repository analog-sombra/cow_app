import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/user_controller.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:gaay/utils/const.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePage extends HookConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final userControllerW = ref.watch(userController);

    ValueNotifier<bool> isLoading = useState(false);

    ValueNotifier<List<dynamic>> foodCourse = useState<List<dynamic>>([]);
    ValueNotifier<List<dynamic>> healthCourse = useState<List<dynamic>>([]);
    ValueNotifier<List<dynamic>> medicineCourse = useState<List<dynamic>>([]);

    // final course = userControllerW.course;

    Future<void> init() async {
      isLoading.value = true;

      await userControllerW.getAllLearn(context);

      final course = userControllerW.course;
      // filter all data by type FOOD HEALTH MEDICINE add in respective list
      for (var i = 0; i < course.length; i++) {
        if (course[i]["type"] == "FOOD") {
          foodCourse.value = [...foodCourse.value, course[i]];
        } else if (course[i]["type"] == "HEALTH") {
          healthCourse.value = [...healthCourse.value, course[i]];
        } else if (course[i]["type"] == "MEDICINE") {
          medicineCourse.value = [...medicineCourse.value, course[i]];
        }
      }

      isLoading.value = false;
    }

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
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
                    Stack(
                      children: [
                        Image.asset(
                          "assets/weather.jpg",
                          width: size.width,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: size.width,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.2),
                                Colors.black.withValues(alpha: 0.4),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Text(
                            "જ્ઞાન કેન્દ્ર",
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "ગાય માટે પોષણ અને ખોરાક",
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var i = 0; i < foodCourse.value.length; i++) ...[
                            CowCard(
                              title: foodCourse.value[i]["title"],
                              cover: foodCourse.value[i]["cover"],
                              link: foodCourse.value[i]["link"],
                            ),
                          ]
                          // CowCard(
                          //   title: "ગાય માટે શ્રેષ્ઠ આહાર સૂત્ર",
                          //   url: ,
                          //   link: "https://www.youtube.com/watch?v=qGWFsTSD6Ro",
                          // ),
                          // CowCard(
                          //     title: "તમારી ગીર ગાયને દિવસભર ખાવા માટે શું આપવું",
                          //     url: "assets/mcow2.jpeg",
                          //     link:
                          //         "https://www.youtube.com/watch?v=GMyMQbHGbPM"),
                          // CowCard(
                          //     title: "શિયાળામાં ખાસ ગાયનું ભોજન",
                          //     url: "assets/mcow3.jpeg",
                          //     link:
                          //         "https://www.youtube.com/watch?v=LKju8Hs8zqY"),
                          // CowCard(
                          //   title: "ગીર ગયા પાલન ની સંપૂર્ણ શિક્ષણ",
                          //   url: "assets/mcow4.jpeg",
                          //   link: "https://www.youtube.com/watch?v=j72V3pO4XM8",
                          // ),
                          // CowCard(
                          //   title: "ગીર ગાય ની શ્રેષ્ઠ ચારા મિશ્રણ",
                          //   url: "assets/mcow9.jpeg",
                          //   link: "https://www.youtube.com/watch?v=qGWFsTSD6Ro",
                          // ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: 200,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "પ્રથમ મદદ: તાત્કાલિક સેવાઓ",
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < healthCourse.value.length;
                              i++) ...[
                            CowCard(
                              title: healthCourse.value[i]["title"],
                              cover: healthCourse.value[i]["cover"],
                              link: healthCourse.value[i]["link"],
                            ),
                          ]
                          // CowCard(
                          //   title:
                          //       "ઢોરમાં ગઠ્ઠો ચામડીનો રોગ (LSD) - આયુર્વેદિક અને હર્બલ સારવાર - પ્રાથમિક સારવાર",
                          //   url: "assets/mcow4.jpeg",
                          //   link: "https://www.youtube.com/watch?v=Yxg-EXAZfU4",
                          // ),
                          // CowCard(
                          //   title: "ગાય અથવા ઢોરના પેટમાં ગેસની સારવાર",
                          //   url: "assets/mcow6.jpeg",
                          //   link: "https://www.youtube.com/watch?v=VByn_NWJILM",
                          // ),
                          // CowCard(
                          //   title: "ઢોરમાં બ્લોટ ઈમરજન્સી",
                          //   url: "assets/mcow7.jpeg",
                          //   link: "https://www.youtube.com/watch?v=rtFPuy8ktPA",
                          // ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: 200,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "ગાયની બીમારીઓ: પ્રારંભ અને ઉપચાર",
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < medicineCourse.value.length;
                              i++) ...[
                            CowCard(
                              title: medicineCourse.value[i]["title"],
                              cover: medicineCourse.value[i]["cover"],
                              link: medicineCourse.value[i]["link"],
                            ),
                          ]
                          // CowCard(
                          //   title: "અનિદ્રા પેટ | આર્યુવેદિક ઉપચાર",
                          //   url: "assets/mcow8.jpeg",
                          //   link: "https://www.youtube.com/watch?v=DUc8WesxN8E",
                          // ),
                          // CowCard(
                          //   title: "પશુ ત્વચા રોગ ફંગલ ચેપ સારવાર",
                          //   url: "assets/mcow9.jpeg",
                          //   link: "https://www.youtube.com/watch?v=KcpSZQ3UjHY",
                          // ),
                          // CowCard(
                          //   title:
                          //       "નૈતિક ડેરી ફાર્મિંગના સંદર્ભમાં સૌથી વધુ પૂછાતા 5 પ્રશ્નોના જવાબ આપવામાં આવ્યા છે",
                          //   url: "assets/mcow10.jpeg",
                          //   link: "https://www.youtube.com/watch?v=zuR4jC74i20",
                          // ),
                          // CowCard(
                          //   title:
                          //       "ગાય બોવાઇન કોલોસ્ટ્રમ ખીરા | દૂધ અને આરોગ્ય વધારવા માટે શ્રેષ્ઠ ટોનિક",
                          //   url: "assets/mcow1.jpeg",
                          //   link: "https://www.youtube.com/watch?v=TMmvBqPkJlM",
                          // ),
                          // CowCard(
                          //   title: "પ્રોલેપ્સ સમસ્યાની આયુર્વેદિક સારવાર",
                          //   url: "assets/mcow2.jpeg",
                          //   link: "https://www.youtube.com/watch?v=oUYd5pjBTs8",
                          // ),
                          // CowCard(
                          //   title: "જાણો ગાયના પંચગવ્યના ફાયદા",
                          //   url: "assets/mcow3.jpeg",
                          //   link: "https://www.youtube.com/watch?v=hYszvUuGMqU",
                          // ),
                          // CowCard(
                          //   title: "ગીર ગાયના વાછરડા/વચ્ચાની સંભાળ",
                          //   url: "assets/mcow4.jpeg",
                          //   link: "https://www.youtube.com/watch?v=Cpp63k6i2D8",
                          // ),
                          // CowCard(
                          //   title: "ગીર ગૌશાળા",
                          //   url: "assets/mcow4.jpeg",
                          //   link: "https://www.youtube.com/watch?v=biGe_2kk_QA",
                          // ),
                          // CowCard(
                          //   title: "વાસ્તવિક ગીર ગાય કેવી રીતે ઓળખવી",
                          //   url: "assets/mcow6.jpeg",
                          //   link: "https://www.youtube.com/watch?v=4YjdWEOPRbg",
                          // ),
                          // CowCard(
                          //   title: "લૂઝ મોશન ગીર ગાય - શ્રેષ્ઠ ઉકેલ",
                          //   url: "assets/mcow7.jpeg",
                          //   link: "https://www.youtube.com/watch?v=6bNzWdN524U",
                          // ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: 200,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
    );
  }
}

class CowCard extends HookConsumerWidget {
  final String title;
  final String cover;
  final String link;
  const CowCard({
    super.key,
    required this.title,
    required this.cover,
    required this.link,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        if (!await launchUrl(Uri.parse(link))) {
          if (!context.mounted) return;
          erroralert(context, "Error", "Could not launch $link");
        }
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.symmetric(horizontal: 10),
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: url + cover,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      width: 120,
                      height: 100,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                Positioned(
                  child: Container(
                    width: 120,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 40,
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              title,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                height: 1,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
