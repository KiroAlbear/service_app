import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/test_feature_bloc.dart';
import '../blocs/test_feature_event.dart';
import '../blocs/test_feature_state.dart';

class TestFeaturePage extends StatefulWidget {
  const TestFeaturePage({super.key});

  @override
  State<TestFeaturePage> createState() => _TestFeaturePageState();
}

class _TestFeaturePageState extends State<TestFeaturePage> {
  final TextEditingController _testController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<TestFeatureBloc>(context).add(getTestFeatureEvent(1));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestFeatureBloc, TestFeatureState>(
      builder: (context, state) {
        return SizedBox();
      },
    );
  }
}
