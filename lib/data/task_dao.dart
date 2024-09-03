
import 'package:primeiro_projeto/data/database.dart';
import 'package:sqflite/sqlite_api.dart';

import '../components/task.dart';

class TaskDao {
  static const String _tableName = 'tasks_v2'; // Nova tabela
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';
  static const String _level = 'level';

  static const String tableSql = 'CREATE TABLE $_tableName ('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT, '
      '$_level INTEGER)';

  save(Task tarefa) async {
    print('Iniciando o save: ');

    final Database bancoDeDados = await getDatabase();
    var itemExists = await find(tarefa.nameTask);
    Map<String, dynamic> taskMap = toMap(tarefa);

    if(itemExists.isEmpty){
      print('A tarefa não existia.');
      return await bancoDeDados.insert(_tableName, taskMap);
    } else {
      print('A tarefa já existia!');
      return await bancoDeDados.update(_tableName, taskMap, where: '$_name = ?', whereArgs: [tarefa.nameTask]);
    }
  }

  Map<String, dynamic> toMap(Task tarefa){
    print('Convertendo tarefa em Map: ');

    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nameTask;
    mapaDeTarefas[_difficulty] = tarefa.difficulty;
    mapaDeTarefas[_image] = tarefa.image;
    mapaDeTarefas[_level] = tarefa.level;

    print('Mapa de Tarefas: $mapaDeTarefas');

    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    print('Acessando o findAll: ');

    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(_tableName);

    print('Procurando dados no banco de dados... encontrado: $result');

    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    print('Convertendo to List:');

    final List<Task> tarefas = [];
    for(Map<String, dynamic> linha in mapaDeTarefas){
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty], level: linha[_level]);
      tarefas.add(tarefa);
    }

    print('Lista de Tarefas: $tarefas');

    return tarefas;
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando o find: ');

    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
        _tableName,
        where: '$_name = ?',
        whereArgs: [nomeDaTarefa],
    );

    print('Tarefa encontrada: ${toList(result)}');

    return toList(result);
  }

  delete(String nomeTarefa) async {
    print('Deletando tarefa: $nomeTarefa');

    final Database bancoDeDados = await getDatabase();
    return bancoDeDados.delete(_tableName, where: '$_name = ?', whereArgs: [nomeTarefa]);
  }
}