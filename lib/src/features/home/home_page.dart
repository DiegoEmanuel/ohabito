
import 'package:flutter/material.dart';
import 'package:ohabito/core/colors/colors.dart';
import 'package:ohabito/core/months/months.dart';
import 'package:ohabito/src/features/dayTasks/day_tasks_page.dart';
import 'package:ohabito/src/features/home/controller/home_controller.dart';
import 'package:ohabito/src/features/home/widgets/days_week_widget.dart';
import 'package:ohabito/src/features/home/widgets/head_habits.dart';

import 'package:ohabito/src/features/home/widgets/squares_widget.dart';
import 'package:ohabito/src/models/month_model.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MonthModel month;
  HomeController homeController = HomeController();

  @override
  void initState() {
    super.initState();
    month =
        listMonths.where((element) => element.id == DateTime(2023, 1, 5, 14, 30, 0).month).first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>()
        ..setCurrentMonth(month)
        ..fetchHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<HabitProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SquaresLine(),
                  Headohabito(month: month, homeController: homeController),
                  const SizedBox(height: 30),
                  const DaysWeekWidget(),
                  if (provider.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 7,
                        children: List.generate(month.days, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DayTasksPage(
                                      day: index,
                                      month: month,
                                      listTask: homeController.getDaysFilter(index, month),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: homeController.frequencyBackgroundColor(index, month),
                                  border: Border.all(
                                    width: index + 1 == DateTime(2023, 1, 5, 14, 30, 0).day + 2
                                        ? 5
                                        : 3,
                                    color: index + 1 == DateTime(2023, 1, 5, 14, 30, 0).day
                                        ? Colors.white
                                        : homeController.frequencyBorderColor(index, month),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
