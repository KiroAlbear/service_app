import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/core/routes/routes.dart';
import 'package:service/core/services/google_sheets_service.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';
import 'package:service/features/home/blocs/home_bloc.dart';
import 'package:service/features/home/blocs/home_event.dart';
import 'package:service/features/home/blocs/home_state.dart';

import '../../core/services/secure_storage/secure_storage_keys.dart';
import '../../core/services/secure_storage/secure_storage_values.dart';
import '../../core/utils/app_utils.dart';
import '../../core/widgets/verse_widget.dart';
import '../models/month_values.dart';
import 'widgets/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingChild(
    HomeListLoadingState? loadingState,
    MonthServiceValues child,
  ) {
    if (loadingState == null) return false;

    return child.firstName == loadingState.firstName &&
        child.fatherName == loadingState.fatherName &&
        child.grandfatherName == loadingState.grandfatherName;
  }

  Future<void> _refreshChildrenRows() async {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    homeBloc.add(getChildrenRowsEvent());

    await homeBloc.stream.firstWhere(
      (state) => state is HomeSuccessState || state is HomeErrorState,
    );
  }

  Widget _buildChildrenRowsSliver(HomeState state) {
    if (state is HomeSuccessState || state is HomeListLoadingState) {
      final childrenRows = state is HomeSuccessState
          ? state.childrenRows
          : (state as HomeListLoadingState).childrenRows;
      final loadingState = state is HomeListLoadingState ? state : null;

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return const Text(
                  "قائمة المخدومين",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                );
              }

              if (index.isOdd) {
                return const SizedBox(height: 10);
              }

              final child = childrenRows[(index - 2) ~/ 2];

              return ListItem(
                firstName: child.firstName,
                fatherName: child.fatherName,
                grandfatherName: child.grandfatherName,
                morningService: child.morningService,
                communion: child.communion,
                service: child.service,
                confession: child.confession,
                isLoading: _isLoadingChild(loadingState, child),
              );
            },
            childCount: childrenRows.isEmpty ? 1 : childrenRows.length * 2 + 1,
          ),
        ),
      );
    }

    if (state is HomeLoadingState) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(
            constraints: BoxConstraints(minHeight: 50, minWidth: 50),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(getChildrenRowsEvent());
    });
  }

  Future<void> _logOut() async {
    await GoogleSheetsService.getInstance().signOut();
    await SecureStorageManager.getInstance().setValue(
      SecureStorageKeys.isLoggedIn,
      SecureStorageValues.falseValue,
    );
    await SecureStorageManager.getInstance().deleteValue(
      SecureStorageKeys.sheetName,
    );
    await SecureStorageManager.getInstance().deleteValue(
      SecureStorageKeys.servantName,
    );

    if (!mounted) {
      return;
    }

    Routes.navigateToScreen(
      Routes.loginScreen,
      NavigationType.goNamed,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f8fe),
      appBar: AppBar(backgroundColor: const Color(0xfff3f8fe)),
      drawer: Drawer(
        backgroundColor: const Color(0xfff3f8fe),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: _logOut,
              ),
            ],
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: _refreshChildrenRows,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FutureBuilder(
                      future: SecureStorageManager.getInstance().getValue(
                        SecureStorageKeys.servantName,
                      ),
                      builder: (context, snapshot) {
                        return Text(
                          " اهلا ${snapshot.data.toString()} ",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    VerseWidget(
                      verse:
                          '"أَيْضًا إِذَا سِرْتُ فِي وَادِي ظِلِّ الْمَوْتِ لَا أَخَافُ شَرًّا، لأَنَّكَ أَنْتَ مَعِي. عَصَاكَ وَعُكَّازُكَ هُمَا يُعَزِّيَانِنِي."',
                      verseLocation: 'المزامير 23: 4',
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              BlocConsumer<HomeBloc, HomeState>(
                bloc: BlocProvider.of<HomeBloc>(context),
                listener: (context, state) {
                  if (state is HomeErrorState) {
                    AppUtils.showAppToast(
                      context: context,
                      message: state.errorMessage,
                    );
                  }
                },
                builder: (context, state) => _buildChildrenRowsSliver(state),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
