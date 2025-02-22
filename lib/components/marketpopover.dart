import 'package:flutter/material.dart';
import 'package:gaay/utils/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:popover/popover.dart';

class MarketPopMenuButton extends StatelessWidget {
  final int cowid;
  const MarketPopMenuButton({super.key, required this.cowid});

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
          bodyBuilder: (context) => ListItems(
            cowid: cowid,
          ),
          onPop: () {
          },
          radius: 2,
          direction: PopoverDirection.bottom,
          width: 200,
          height: 120,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}

class ListItems extends HookConsumerWidget {
  final int cowid;
  const ListItems({super.key, required this.cowid});

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
            onPressed: () async {
              try {
                context.pop();
                await cowSellAlert(context, ref, cowid);
              } catch (e) {
                if (!context.mounted) return;
                erroralert(context, "Error", e.toString());
              }
            },
            label: Text(
              "Add To Market",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
