import 'package:hilton_masale/models/cart_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();

  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE orders ( 
  productId  INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  productName VARCHAR,
  rate float,
  imageUrl VARCHAR
  inStock INTEGER DEFAULT 1
  )
  ''');
  }

  Future<void> create(CartModel item) async {
    final db = await instance.database;

    Map<String, dynamic> data = {
      'productId': item.productId,
      'quantity': item.quantity,
      'productName': item.productName,
      'rate': item.rate,
      'imageUrl': item.productImage
    };
    await db.insert('orders', data);
  }

  Future<List<CartModel>> getListOfItemsInCart() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query('orders');

    return result.map((json) => CartModel.fromJson(json)).toList();
  }

  Future<int> update(CartModel note) async {
    final db = await instance.database;

    return db.update(
      'orders',
      note.toJson(),
      where: 'productId = ?',
      whereArgs: [note.productId],
    );
  }

  Future<int> delete(int productId) async {
    final db = await instance.database;

    return await db.delete(
      'orders',
      where: 'productid = ?',
      whereArgs: [productId],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
