import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String firstName;
  final String fatherName;
  final String grandfatherName;

  const ListItem({
    super.key,
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isExpanded = false;

  int stock = 156;
  int reserved = 42;
  int onOrder = 50;
  int damaged = 4;

  static const String morningServiceText = 'قداس';
  static const String communionText = 'تناول';
  static const String serviceText = 'اجتماع';
  static const String confessionText = 'اعتراف';

  void increment(String field) {
    setState(() {
      switch (field) {
        case morningServiceText:
          stock++;
          break;
        case 'تناول':
          reserved++;
          break;
        case 'اجتماع':
          onOrder++;
          break;
        case 'اعتراف':
          damaged++;
          break;
      }
    });
  }

  void decrement(String field) {
    setState(() {
      switch (field) {
        case 'قداس':
          if (stock > 0) stock--;
          break;
        case 'تناول':
          if (reserved > 0) reserved--;
          break;
        case 'اجتماع':
          if (onOrder > 0) onOrder--;
          break;
        case 'اعتراف':
          if (damaged > 0) damaged--;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffCBD5E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "${widget.firstName} ${widget.fatherName} ${widget.grandfatherName}",
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
                height: 1.25,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: const Color(0xff64748B),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        const SizedBox(height: 18),
        const Divider(height: 1, color: Color(0xffE5E7EB)),
        const SizedBox(height: 18),

        CounterRow(
          label: morningServiceText,
          value: stock,
          valueColor: const Color(0xff004FD6),
          onMinus: () => decrement(morningServiceText),
          onPlus: () => increment(morningServiceText),
        ),

        CounterRow(
          label: communionText,
          value: reserved,
          valueColor: const Color(0xff64748B),
          onMinus: () => decrement(communionText),
          onPlus: () => increment(communionText),
        ),

        CounterRow(
          label: serviceText,
          value: onOrder,
          valueColor: const Color(0xffB45309),
          onMinus: () => decrement(serviceText),
          onPlus: () => increment(serviceText),
        ),

        CounterRow(
          label: confessionText,
          value: damaged,
          valueColor: const Color(0xffDC2626),
          onMinus: () => decrement(confessionText),
          onPlus: () => increment(confessionText),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Saved: $stock, $reserved, $onOrder, $damaged');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC3C7CA),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CounterRow extends StatelessWidget {
  const CounterRow({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final Color valueColor;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 0.9,
              fontWeight: FontWeight.w800,
              color: Color(0xff1E293B),
            ),
          ),
          Container(
            height: 44,
            width: 142,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE5E7EB),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _CircleButton(icon: Icons.add_rounded, onTap: onPlus),
                Expanded(
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: valueColor,
                      ),
                    ),
                  ),
                ),
                _CircleButton(icon: Icons.remove_rounded, onTap: onMinus),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xffDDE3E8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: Color(0xff0F172A)),
      ),
    );
  }
}
