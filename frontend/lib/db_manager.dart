import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBManager{
  //싱글톤 형식으로 생성
  DBManager._privateConstructor();
  static final DBManager instance = DBManager._privateConstructor();

  // 데이터베이스 객체 저장
  static Database? _database;
  // 데이터베이스 객체를 받아오고 null 이면 초기화
  Future<Database> get database async => _database ??= await _initDatabase();

  // 데이터베이스 객체 초기화
  Future<Database> _initDatabase() async {
    // 앱의 문서 디렉토리를 받아옴
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // chatting.db 의 경로를 설정
    String path = join(documentsDirectory.path, 'matching.db');
    // db를 열고 없으면 생성
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // 테이블 생성 함수
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE matching(
      oppIds text
    )
    ''');
  }
}