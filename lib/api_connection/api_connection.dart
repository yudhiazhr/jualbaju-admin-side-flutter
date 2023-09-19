class API
{
  static const hostConnect = "https://arraxysworld.000webhostapp.com/api_pi_app/";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin"; // admin
  static const hostItem = "$hostConnect/items_product"; // admin
  static const hostClothes = "$hostConnect/clothes";
  static const hostCart = "$hostConnect/cart";
  static const hostOrder = "$hostConnect/order";

  //user
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";
  static const updateDataUser = "$hostConnectUser/update_data_user.php";


  //admin
  static const adminLogin = "$hostConnectAdmin/login.php";
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php";
  static const adminAllHistoryOrders = "$hostConnectAdmin/readAdminHistoryOrders.php";
  static const adminAllOrdersInDelivery = "$hostConnectAdmin/read_indelivery_orders_admin.php";
  static const adminUpdateIndelivery = "$hostConnectAdmin/admin_update_Indelivery.php";

  

  //Item
  static const uploadNewProduct = "$hostItem/upload.php"; // admin
  static const searchItems = "$hostItem/search.php";
  static const updateProduct = "$hostItem/update_product.php";
  static const deleteProduct = "$hostItem/delete_product.php";

  static const updateStockProduct = "$hostItem/update_stock.php";


  //clothes
  static const getTrendingMostPopularClothes = "$hostClothes/trending.php";
  static const getAllClothes = "$hostClothes/newest.php";

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteSelectedItemsFromCartList = "$hostCart/delete.php";
  static const updateItemInCartList = "$hostCart/update.php";

  //order
  static const addOrder = "$hostOrder/addOrder.php";
  static const readOrders = "$hostOrder/readOrder.php";
  static const updateStatusOrders = "$hostOrder/updateStatusOrder.php";
  static const readHistoryOrders = "$hostOrder/readHistoryOrder.php";
  static const readInDeliveryOrders = "$hostOrder/readInDeliveryOrder.php";



}