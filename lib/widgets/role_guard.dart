import 'package:flutter/material.dart';

class RoleGuard extends StatelessWidget {
  final String? role;
  final List<String> allowed;
  final Widget child;

  const RoleGuard({
    super.key,
    required this.role,
    required this.allowed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (role != null &&
        allowed.any((item) => item.toLowerCase() == role!.toLowerCase())) {
      return child;
    }
    return const SizedBox.shrink();
  }
}

