class Task {
  int id;
  String name;
  double price;
  String detail;
  int amount;

  Task(this.id, this.name, this.price, this.detail, this.amount);
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "detail": detail,
      "amount": amount,
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    detail = map['detail'];
    amount = map['amount'];
  }
}
