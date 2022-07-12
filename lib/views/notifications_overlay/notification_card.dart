import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: expand button
class NotificationCard extends StatefulWidget {
  final VoidCallback? onClose;
  final Duration persistFor;
  final String msg;

  const NotificationCard({
    Key? key,
    this.onClose,
    this.persistFor = const Duration(seconds: 5),
    required this.msg,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Opacity(
      opacity: _opacity,
      child: Card(
        color: Get.theme.colorScheme.onSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                width: 420,
                child: Text(
                  widget.msg,
                  style: const TextStyle(
                    height: 1,
                    fontSize: 15,
                    fontFamily: "Merriweather",
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.persistFor,
      upperBound: 1,
    )
      ..addListener(() {
        setState(() {
          _opacity = 1 - _controller.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.onClose != null) {
          widget.onClose!();
        }
      });
    _controller.animateTo(
      1,
      duration: widget.persistFor,
      curve: Curves.easeInQuint,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
