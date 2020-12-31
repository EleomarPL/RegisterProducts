class Product {
  int id;
  String name;
  double price;
  String detail;
  int amount;

  Product({this.id, this.name, this.price, this.detail, this.amount});
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "detail": detail,
      "amount": amount,
    };
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    detail = map['detail'];
    amount = map['amount'];
  }
}
