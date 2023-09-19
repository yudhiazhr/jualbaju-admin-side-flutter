class Clothes {
  String? product_id;
  /* int? product_id; */
  String? product_brand;
  String? product_name;
  double? product_rating;
  List<String>? product_size;
  int? product_price;
  int? product_stock;
  String? product_description;
  String? product_image;

  Clothes({
    this.product_id,
    this.product_brand,
    this.product_name,
    this.product_rating,
    this.product_size,
    this.product_price,
    this.product_stock, 
    this.product_description,
    this.product_image,
    
  });

  Clothes.copy(Clothes other) {
    product_id = other.product_id;
    product_name = other.product_name;
    product_brand = other.product_brand;
    product_price =other.product_price;
    product_rating = other.product_rating;
    product_size = List<String>.from(other.product_size ?? []);
    product_stock = other.product_stock;
    product_description = other.product_description;
    product_image = other.product_image;
  }

  factory Clothes.fromJson(Map<String, dynamic> json) =>Clothes(
    /* product_id: int.parse(json["product_id"]), */
    product_id: json["product_id"],
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