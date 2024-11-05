import 'dart:developer';

import 'package:fic12_fe/data/models/request/order_request_model.dart';
import 'package:fic12_fe/data/models/response/category_response_model.dart';
import 'package:fic12_fe/data/models/response/product_response_model.dart';
import 'package:fic12_fe/presentation/home/models/order_item.dart';
import 'package:fic12_fe/presentation/order/models/order_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSource {
  ProductLocalDataSource._init();

  static final ProductLocalDataSource instance = ProductLocalDataSource._init();

  final String tableProducts = 'products';

  static Database? _database;

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filepath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT,
        price INTEGER,
        stock INTEGER,
        image TEXT,
        category TEXT,
        category_id INTEGER,
        is_best_seller INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_method TEXT,
        total_item INTEGER,
        nominal INTEGER,
        id_kasir INTEGER,
        nama_kasir TEXT,
        is_sync INTEGER DEFAULT 0,
        transaction_time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE draft_orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_item INTEGER,
        nominal INTEGER,
        transaction_time TEXT,
        table_number INTEGER,
        draft_name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE draft_order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_draft_order INTEGER,
        id_product INTEGER,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pos2.db');
    return _database!;
  }

  //===========================ORDER===========================
  Future<int> saveOrder(OrderModel order) async {
    final db = await instance.database;
    int id = await db.insert('orders', order.toMapForLocal());
    for (var orderItem in order.orders) {
      await db.insert('order_items', orderItem.toMapForLocal(orderId: id));
    }
    log('ID: $id, Data: ${order.toString()}');
    return id;
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await instance.database;
    final result = await db.query('orders', orderBy: 'id DESC');
    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }

  Future<List<OrderModel>> getOrderByIsSync() async {
    final db = await instance.database;
    final result = await db.query('orders', where: 'is_sync = 0');

    // Log untuk menampilkan data yang didapat dari database
    log('Data Log:');
    result.forEach((order) {
      log(order.toString()); // Menampilkan setiap order dalam bentuk Map
    });

    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }

  Future<List<OrderItemModel>> getOrderItemByOrderIdLocal(int orderId) async {
    final db = await instance.database;
    final result = await db.query('order_items', where: 'id_order = $orderId');

    // Log untuk menampilkan data yang didapat dari database
    log('Data Berdasarkan Id:');
    result.forEach((orderItem) {
      log(orderItem.toString()); // Menampilkan setiap item dalam bentuk Map
    });
    return result.map((e) => OrderItem.fromMapLocal(e)).toList();
  }

  Future<int> updateIsSyncOrderById(int id) async {
    final db = await instance.database;
    return await db.update('orders', {'is_sync': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  //===========================PRODUCT===========================
  Future<void> removeAllProduct() async {
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  Future<void> insertAllProduct(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(tableProducts, product.toLocalMap());
    }

    // Log the retrieved data
    final List<Map<String, dynamic>> allProducts =
        await db.query(tableProducts);
    log('Data in LocalStorage: $allProducts');
  }

  Future<Product> insertProduct(Product product) async {
    final db = await instance.database;
    log("${product.toMap()}");
    int id = await db.insert(tableProducts, product.toMap());
    return product.copyWith(id: id);
  }

  Future<List<Product>> getAllProduct() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  //===========================CATEGORY===========================
  Future<void> insertAllCategories(List<Category> categories) async {
    final db = await instance.database;
    for (var category in categories) {
      await db.insert('categories', category.toLocal());
    }
  }

  Future<void> removeAllCategories() async {
    final db = await instance.database;
    await db.delete('categories');
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');

    return result.map((e) => Category.fromLocal(e)).toList();
  }
}
