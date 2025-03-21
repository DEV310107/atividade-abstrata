import 'dart:io';

enum Priority { //define as prioridades
  alta,
  media,
  baixa,
}

class Task { //cria a classe Task pedindo no problema
  final int id;
  final String name;
  final DateTime data;

  
  Task(this.id, this.name, this.data);// Construtor da classe Task
}

class TaskPriority extends Task {
  Priority priority;
  TaskPriority(super.id, super.name, super.data, this.priority);
}

class TaskDTO {
  int id;
  String name;
  Priority priority;
  DateTime data;

  TaskDTO(this.id, this.name, this.priority, this.data);
}

abstract class TaskRepository {
  Task add(TaskDTO taskDTO);
  Task remove(int id);
  Task update(int id);
  Task findByid(int id);
  Task findByName(String name);
  List<Task> getAllTasks();
  List<Task> getTasksByPriority();
}

class TaskRepositoryFromList implements TaskRepository {
  List<Task> tasks = [];
  
  @override
  Task add(TaskDTO taskDTO) {
    final task = TaskPriority(taskDTO.id, taskDTO.name, taskDTO.data, taskDTO.priority);
    tasks.add(task);
    return task;
  }
  
  @override
  Task findByName(String name) {
    return tasks.firstWhere((task) => task.name == name, orElse: () => throw Exception('Task not found'));
  }
  
  @override
  Task findByid(int id) {
    return tasks.firstWhere((task) => task.id == id, orElse: () => throw Exception('Task not found'));
  }
  
  @override
  List<Task> getAllTasks() {
    return tasks;
  }
  
  @override
  List<Task> getTasksByPriority() {
    tasks.sort((a, b) {
      if (a is TaskPriority && b is TaskPriority) {
        return a.priority.index.compareTo(b.priority.index);
      }
      return 0;
    });
    return tasks;
  }
  
  @override
  Task remove(int id) {
    final task = findByid(id);
    tasks.remove(task);
    return task;
  }
  
  @override
  Task update(int id) {
    final task = findByid(id);
    // Update logic here
    return task;
  }
}

void main() {
  final repository = TaskRepositoryFromList();

  while (true) {
    print('Escolha uma opção:');
    print('1. Adicionar tarefa');
    print('2. Remover tarefa');
    print('3. Atualizar tarefa');
    print('4. Buscar tarefa por ID');
    print('5. Buscar tarefa por nome');
    print('6. Listar todas as tarefas');
    print('7. Listar tarefas por prioridade');
    print('8. Sair');

    final choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        print('Digite o ID da tarefa:');
        final id = int.parse(stdin.readLineSync()!);
        print('Digite o nome da tarefa:');
        final name = stdin.readLineSync()!;
        print('Digite a prioridade da tarefa (alta, media, baixa):');
        final priorityInput = stdin.readLineSync()!;
        final priority = Priority.values.firstWhere((e) => e.toString().split('.').last == priorityInput);
        print('Digite a data da tarefa (yyyy-mm-dd):');
        final dateInput = stdin.readLineSync()!;
        final data = DateTime.parse(dateInput);
        final taskDTO = TaskDTO(id, name, priority, data);
        repository.add(taskDTO);
        print('Tarefa adicionada com sucesso!');
        break;
      case 2:
        print('Digite o ID da tarefa a ser removida:');
        final id = int.parse(stdin.readLineSync()!);
        repository.remove(id);
        print('Tarefa removida com sucesso!');
        break;
      case 3:
        print('Digite o ID da tarefa a ser atualizada:');
        final id = int.parse(stdin.readLineSync()!);
        // Implementar lógica de atualização
        repository.update(id);
        print('Tarefa atualizada com sucesso!');
        break;
      case 4:
        print('Digite o ID da tarefa:');
        final id = int.parse(stdin.readLineSync()!);
        final task = repository.findByid(id);
        print('Tarefa encontrada: ${task.name}');
        break;
      case 5:
        print('Digite o nome da tarefa:');
        final name = stdin.readLineSync()!;
        final task = repository.findByName(name);
        print('Tarefa encontrada: ${task.name}');
        break;
      case 6:
        final tasks = repository.getAllTasks();
        for (var task in tasks) {
          print('Tarefa: ${task.name}');
        }
        break;
      case 7:
        final tasks = repository.getTasksByPriority();
        tasks.forEach((task) {
          if (task is TaskPriority) {
            print('Tarefa: ${task.name}, Prioridade: ${task.priority}');
          }
        });
        break;
      case 8:
        print('Saindo...');
        return;
      default:
        print('Opção inválida!');
    }
  }
}