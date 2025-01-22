import 'package:flutter/material.dart';
import 'package:ohabito/src/features/dayTasks/widgets/progress_widget.dart';
import 'package:ohabito/src/features/newTask/new_task_page.dart';
import 'package:ohabito/src/models/month_model.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';

import '../../../core/colors/colors.dart';
import '../../models/habit_model.dart';
import 'controller/day_tasks_controller.dart';

class DayTasksPage extends StatefulWidget {
  const DayTasksPage({
    super.key,
    required this.month,
    required this.day,
    required this.listTask,
    this.isNew = false,
  });
  final int day;
  final MonthModel month;
  final List<HabitModel> listTask;
  final bool isNew;
  @override
  State<DayTasksPage> createState() => _DayTasksPageState();
}

class _DayTasksPageState extends State<DayTasksPage> {
  DayTasksController controller = DayTasksController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<HabitProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getNameDay(
                    DateTime(2023, 1, 5, 14, 30, 0).year,
                    widget.month.id,
                    widget.day,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.greyLight,
                  ),
                ),
                Text(
                  '${(widget.isNew ? widget.day : widget.day + 1).toString().padLeft(2, '0')}/${widget.month.id.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 36,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                ProgressIndicadorWidget(listTask: widget.listTask),
                const SizedBox(height: 20),
                Expanded(
                  child: widget.listTask.isEmpty
                      ? Text(
                          "You are not tracking any ohabito yet, start by registering one.",
                          style: TextStyle(color: AppColors.greyLight, fontSize: 16),
                        )
                      : ListView.builder(
                          itemCount: widget.listTask.length,
                          itemBuilder: (context, index) {
                            final habit = widget.listTask[index];
                            return Dismissible(
                              key: Key(habit.id),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                provider.deleteHabit(habit.id);
                                setState(() {
                                  widget.listTask.removeAt(index);
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    value: habit.isFinished,
                                    onChanged: (value) {
                                      setState(() {
                                        habit.isFinished = !habit.isFinished;
                                      });
                                      provider.updateHabit(habit);
                                    },
                                    checkColor: AppColors.white,
                                    activeColor: AppColors.green,
                                    fillColor: WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (habit.isFinished) {
                                          return AppColors.green;
                                        }
                                        return AppColors.greyLight;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      habit.description,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton:
          (widget.isNew ? widget.day : widget.day + 1) == DateTime(2023, 1, 5, 14, 30, 0).day &&
                  widget.month.id == DateTime(2023, 1, 5, 14, 30, 0).month
              ? FloatingActionButton(
                  backgroundColor: AppColors.purple3,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewTaskPage(),
                      ),
                    ).then(
                      (value) {
                        if (value != null) {
                          setState(() {
                            widget.listTask.add(value);
                          });
                        }
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
