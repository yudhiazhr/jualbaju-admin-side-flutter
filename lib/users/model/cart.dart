import 'dart:convert';

class Cart {
  int? cart_id;
  String? cart_product_id;
  String? cart_user_id;
  int? cart_quantity;
  String? cart_size;

  String? product_brand;
  String? product_name;
  double? product_rating;
  List<String>? product_size;
  int? product_price;
  int? product_stock;
  String? product_description;
  String? product_image;

  Cart ({
    this.cart_id,
    this.cart_user_id,
    this.cart_product_id,
    this.cart_quantity,
    this.cart_size,
    
    this.product_brand,
    this.product_name,
    this.product_rating,
    this.product_size,
    this.product_price,
    this.product_stock, 
    this.product_description,
    this.product_image,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    cart_id: int.parse(json['cart_id']),
    /* cart_user_id: int.parse(json['cart_user_id']), */
    cart_user_id: json['cart_user_id'],
    /* cart_product_id: int.parse(json['cart_product_id']), */
    cart_product_id: json['cart_product_id'],
    cart_quantity: int.parse(json['cart_quantity']),
    cart_size: json['cart_size'],

    product_brand: json["product_brand"],
    product_name: json["product_name"],
    product_rating: double.parse(json["product_rating"]),
    product_size: json["product_size"].toString().split(", "),
    product_price: int.parse(json["product_price"]),
    product_stock: int.parse(json["product_stock"]),
    product_description: json["product_description"],
    product_image: json["product_image"],  
  );
}