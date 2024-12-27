
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sangeet/app/constants/hive_table_constant.dart';
import 'package:sangeet/features/authentication/data/model/auth_hive_model.dart';

final hiveServiceProvider = Provider((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register Adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  Future<void> register(AuthHiveModel user) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }
  //
  // Future<List<AuthHiveModel>> getAllStudents() async {
  //   var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.studentBox);
  //   var students = box.values.toList();
  //   box.close();
  //   return students;
  // }
  //
  // //Login
  Future<AuthHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere((element) =>
    element.email == email && element.password == password);
    box.close();
    return user;
  }
}