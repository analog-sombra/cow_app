import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gaay/state/loan_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class LoanPage extends HookConsumerWidget {
  const LoanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    AnimationController controller = useAnimationController(
      duration: const Duration(seconds: 1),
    );

    final opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8), // Start slightly off-screen at the bottom
      end: Offset.zero, // End at its original position
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    ValueNotifier<bool> isLoading = useState(false);

    final loanControllerW = ref.watch(loanController);
    final loan = loanControllerW.loan;

    Future<void> init() async {
      isLoading.value = true;
      await loanControllerW.getUserLoan(context);
      isLoading.value = false;
    }

    useEffect(() {
      controller.forward();
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
          : SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (loan == null) ...[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "No loan found for this user",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Image.asset(
                        "assets/2461929.jpg",
                        fit: BoxFit.cover,
                        height: size.height * 0.4,
                        width: size.width,
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 0,

                    //   // top: size.height * 0.1,
                    //   // left: size.width * 0.2,
                    //   child: CachedNetworkImage(
                    //     imageUrl: url + loan["cow"]["photocover"],
                    //     fit: BoxFit.cover,
                    //     alignment: Alignment.topCenter,
                    //     placeholder: (context, url) =>
                    //         Center(child: CircularProgressIndicator()),
                    //     errorWidget: (context, url, error) => Icon(Icons.error),
                    //     height: size.height * 0.4,
                    //     width: size.width,
                    //   ),
                    //   // child: Image.asset(
                    //   //   "assets/cow.png",
                    //   //   fit: BoxFit.contain,
                    //   //   height: size.height * 0.2,
                    //   //   width: size.width * 0.6,
                    //   // ),
                    // ),
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
                        child: SingleChildScrollView(
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // SizedBox(height: 20),
                                  // Center(
                                  //   child: Text(
                                  //     loan["cow"]["cowname"],
                                  //     style: TextStyle(
                                  //       fontSize: 24,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Opacity(
                                      opacity: opacityAnimation.value,
                                      child: SlideTransition(
                                        position: slideAnimation,
                                        child: Text(
                                          "Loan Information",
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
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      // borderRadius: BorderRadius.circular(20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Container(
                                            //   padding: const EdgeInsets.symmetric(
                                            //     horizontal: 10,
                                            //     vertical: 10,
                                            //   ),
                                            //   decoration: BoxDecoration(
                                            //     color: Color(0xffccebcc),
                                            //   ),
                                            //   child: Text(
                                            //     "Details",
                                            //     textAlign: TextAlign.center,
                                            //     style: TextStyle(
                                            //       fontSize: 20,
                                            //       fontWeight: FontWeight.w400,
                                            //     ),
                                            //   ),
                                            // ),
                                            CowTableData(
                                              status: "Loan Id",
                                              title: loan["loan_id"].toString(),
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Loan amount",
                                              title: "Rs. ${loan["amount"]}/-",
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Loan Start Date",
                                              title: DateFormat('d-MM-yyyy')
                                                  .format(DateTime.parse(
                                                      loan["start_date"])),
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "Loan End Date",
                                              title: DateFormat('d-MM-yyyy')
                                                  .format(DateTime.parse(
                                                      loan["end_date"])),
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "EMI Amount",
                                              title:
                                                  loan["emi_amount"].toString(),
                                              isBorder: true,
                                            ),
                                            CowTableData(
                                              status: "EMI Date",

                                              // title: "5th Day of Month",
                                              // i want dynamic title like this
                                              title:
                                                  "${DateFormat('d').format(DateTime.parse(loan["emi_date"]))}th Day of Month",
                                              isBorder: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
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
                ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
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
                fontSize: 18,
                color: Colors.black.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
