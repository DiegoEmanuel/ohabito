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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, _) {
          final habits = provider.getDayHabits(widget.day + 1, widget.month.id);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
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
                ProgressIndicadorWidget(listTask: habits),
                const SizedBox(height: 20),
                Expanded(
                  child: habits.isEmpty
                      ? Center(
                          child: Text(
                            "Você ainda não está acompanhando nenhum hábito.\nComece registrando um!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.greyLight,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: habits.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            return Dismissible(
                              key: ValueKey(habit.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              onDismissed: (direction) async {
                                try {
                                  await provider.deleteHabit(habit.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Hábito excluído com sucesso'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao excluir hábito'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.greyDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        value: habit.isFinished,
                                        onChanged: (value) {
                                          final updatedHabit = HabitModel(
                                            id: habit.id,
                                            description: habit.description,
                                            date: habit.date,
                                            isFinished: !habit.isFinished,
                                          );
                                          provider.updateHabit(updatedHabit);
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
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        habit.description,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              habit.isFinished ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
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
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
