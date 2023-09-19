class User {
  /* int user_id; */
  String user_name;
  String user_email;
  String user_password;
  String user_street_address;
  String user_city;
  String user_state;
  String user_zipcode;
  String user_country;
  String user_id_phone_number;

  User (
    /* this.user_id, */
    this.user_name,
    this.user_email,
    this.user_password,
    this.user_street_address,
    this.user_city,
    this.user_state,
    this.user_zipcode,
    this.user_country,
    this.user_id_phone_number,

  );

  factory User.fromJson(Map<String, dynamic> json) => User (
    /* int.parse(json['user_id']), */
    json['user_name'],
    json['user_email'],
    json['user_password'],
    json['user_street_address'],
    json['user_city'],
    json['user_state'],
    json['user_zipcode'],
    json['user_country'],
    json['user_id_phone_number'],
  );
 
  Map<String, dynamic> toJson() => {
    /* 'user_id': user_id.toString(), */
    'user_name': user_name,
    'user_email': user_email,
    'user_password': user_password,
    'user_street_address':user_street_address,
    'user_city':user_city,
    'user_state':user_state,
    'user_zipcode':user_zipcode,
    'user_country':user_country,
    'user_id_phone_number':user_id_phone_number,
    };
}