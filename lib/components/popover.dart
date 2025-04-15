import 'package:flutter/material.dart';
import 'package:gaay/router/routername.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:popover/popover.dart';

class PopMenuButton extends StatelessWidget {
  const PopMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.more_vert,
        color: Colors.black,
        size: 30,
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => const ListItems(),
          onPop: () {},
          radius: 2,
          direction: PopoverDirection.bottom,
          width: 200,
          height: 300,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}

class ListItems extends HookConsumerWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text(
            "Menu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Divider(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                    color: Colors.black.withValues(alpha: 0.6), width: 1),
              ),
            ),
            icon: Icon(
              Icons.person,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              context.pushNamed(RouteNames.profile);
            },
            label: Text(
              "Profile",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                    color: Colors.black.withValues(alpha: 0.6), width: 1),
              ),
            ),
            icon: Text(
              "\u{20B9}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              context.pushNamed(RouteNames.loan);
            },
            label: Text(
              "Loan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                    color: Colors.black.withValues(alpha: 0.6), width: 1),
              ),
            ),
            icon: Icon(
              Icons.feedback,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              context.pop();
              context.pushNamed(RouteNames.feedback);
            },
            label: Text(
              "Feedback",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                    color: Colors.black.withValues(alpha: 0.6), width: 1),
              ),
            ),
            icon: Icon(
              Icons.help,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {
              context.pop();
              context.pushNamed(RouteNames.help);
            },
            label: Text(
              "Help",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () async {
              try {
                await logoutAlert(context, ref);
              } catch (e) {
                if (!context.mounted) return;
                erroralert(context, "Error", e.toString());
              }
            },
            label: Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
