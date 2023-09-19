class Order
{
  int? order_id;
  String? user_id_phone_number;
  String? selectedItems;
  String? deliverySystem;
  double? totalAmount;
  String? status;
  DateTime? dateTime;
  String? user_street_address;
  String? user_city;
  String? user_state;
  String? user_zipcode;
  String? user_country;
  String? user_name;

  Order({
    this.order_id,
    this.user_id_phone_number,
    this.selectedItems,
    this.deliverySystem,
    this.totalAmount,
    this.status,
    this.dateTime,
    this.user_name,
    this.user_street_address,
    this.user_city,
    this.user_state,
    this.user_zipcode,
    this.user_country,
  });

  Map<String, dynamic> toJson() => {
        'order_id': order_id.toString(),
        'user_id_phone_number':user_id_phone_number.toString(),
        'order_selectedItems': selectedItems,
        'order_deliverySystem': deliverySystem,
        'order_totalAmount': totalAmount!.toStringAsFixed(0),
        'order_status': status,
        'dateTime' : dateTime.toString(),
        'user_street_address' : user_street_address,
        'user_city' : user_city,
        'user_state' : user_state,
        'user_zipcode': user_zipcode,
        'user_country': user_country,
        'user_name': user_name,
      };

    factory Order.fromJson(Map<String, dynamic> json) => Order(
    order_id: int.parse(json['order_id']) ,
    user_id_phone_number: json['user_id_phone_number'] ,
    selectedItems: json['order_selectedItems'] ,
    deliverySystem: json['order_deliverySystem'] ,
    totalAmount: double.parse(json['order_totalAmount']),
    status: json['order_status'] ,
    dateTime: DateTime.parse(json['dateTime']),
    user_street_address: json['user_street_address'] ,
    user_city: json['user_city'] ,
    user_state: json['user_state'] ,
    user_zipcode: json['user_zipcode'] ,
    user_country: json['user_country'] ,
    user_name: json['user_name'] ,
  );
}
