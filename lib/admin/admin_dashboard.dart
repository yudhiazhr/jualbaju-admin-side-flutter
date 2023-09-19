import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../api_connection/api_connection.dart';
import '../users/model/clothes.dart';
import '../widgets/mybutton.dart';
import '../widgets/mytextformfield.dart';
import '../widgets/mytextformfield_ver2.dart';
import 'package:http/http.dart' as http;

import 'admin_all_orders.dart';
import 'admin_login.dart';

class AdminDashboard extends StatefulWidget {

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  final ImagePicker _picker = ImagePicker ();
  XFile? pickedImageXFile;

  var _formKey = GlobalKey<FormState>();
  var productIdController = TextEditingController();
  var brandController = TextEditingController();
  var nameProductController = TextEditingController();
  var ratingController = TextEditingController();
  var sizeController = TextEditingController();
  var priceController = TextEditingController();
  var stockController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";

  captureWithCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  selectImageFromGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(() => pickedImageXFile);

  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
      context: context, 
      builder: (context) {
        return SimpleDialog(
          title: Text("Choose Image", style: TextStyle(fontWeight: FontWeight.bold,),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Capture with camera", style: TextStyle(color: Colors.grey.shade700,),),
              onPressed: () {
                captureWithCamera();
              },
            ),
            SimpleDialogOption(
              child: Text("Select from gallery", style: TextStyle(color: Colors.grey.shade700,),),
              onPressed: () {
                selectImageFromGallery();
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,),),
              onPressed: () {
                Get.back();
              },
            )
          ],
        );
      });
  }

  Widget defaultScreen() {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        
        leading: IconButton(
          onPressed: () {
            Get.to(() => AdminGetAllOrdersScreen());
          }, 
        icon: Icon(Icons.card_giftcard_rounded, color: Colors.black,),),
        
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black,),
            onPressed: () {
              Get.to(() => AdminLoginScreen());
            }, ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
                padding: EdgeInsets.only(left: 25, right: 20, top: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Hi admin", style: TextStyle(fontSize: 26),),
                    Text("Please confirm & deliver new orders now", style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
          ),         
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 10 ,right: 10, top: 10),
          width: double.infinity,
          child: Column(
            children: [
              
              allItemWidget(context)

            ],
          ),
        ),
      ),
    bottomNavigationBar: Container(
        padding: EdgeInsets.only(right: 30, left: 20, top: 15),
                    child: ListTile(
                    leading: Icon(Icons.my_library_add_outlined, color: Colors.white,),
                    title: Text("Add new items",style: TextStyle(fontSize: 20,color: Colors.white),),
                    onTap: () { 
                      showDialogBoxForImagePickingAndCapturing();
                    },
                    trailing: Container(
                      width: 30 , height: 30,
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                    ),
                  ),
                      height: 70,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                        
                      ),
                      ),
    );
  }

  //uploadProduct methods
  uploadProductImage() async {
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image")
    );

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "5b682ab74361a91";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    saveProductInfoToDatabase();
  }

  saveProductInfoToDatabase () async {

    List<String> sizeList = sizeController.text.split(','); //S,M, L, X, XL

    try {
      var response = await http.post(
        Uri.parse(API.uploadNewProduct),
        body: {
          /* 'product_id' : '1', */
          'product_id' : productIdController.text.trim().toString(),
          'product_brand' : brandController.text.trim().toString(),
          'product_name' : nameProductController.text.trim().toString(),
          'product_rating' : ratingController.text.trim().toString(),
          'product_size' : sizeList.toString(),
          'product_price' : priceController.text.trim().toString(),
          'product_stock' : stockController.text.trim().toString(),
          'product_description' : descriptionController.text.trim().toString(),
          'product_image' : imageLink.toString(),
        },
      );

      if(response.statusCode == 200)
      {
        var resBodyOfUploadProduct= jsonDecode(response.body);

        if(resBodyOfUploadProduct['success'] == true)
        {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile=null;
            brandController.clear();
            nameProductController.clear();
            ratingController.clear();
            sizeController.clear();
            priceController.clear();
            stockController.clear();
            descriptionController.clear();
          });

          Get.to(()=> AdminDashboard());
        }
        else
        {
          Fluttertoast.showToast(msg: "Item not uploaded. Error, Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
  }

  Widget uploadProductFromScreen() {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),
          onPressed: () {
           setState(() {
            pickedImageXFile=null;
            brandController.clear();
            nameProductController.clear();
            ratingController.clear();
            sizeController.clear();
            priceController.clear();
            stockController.clear();
            descriptionController.clear();
          });

          Get.to(()=> AdminDashboard());
          }, 
        ),
        title: Text("Uploading item", style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
        children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    width: 400,
                    child: Card(
                      child: Container(
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                             image: FileImage(
                                File(pickedImageXFile!.path), 
                              ),
                              fit: BoxFit.contain
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                MyTextFormField(
                  controller: productIdController, 
                  name: "Product ID", 
                  prefixIcon: Icon(Icons.branding_watermark_outlined, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product Id" : null,
                  onSaved: (value) {
                  productIdController.text = value!;
                  }),
                  SizedBox(height: 10,),

                MyTextFormField(
                  controller: brandController, 
                  name: "Brand", 
                  prefixIcon: Icon(Icons.branding_watermark_outlined, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product brand" : null,
                  onSaved: (value) {
                  brandController.text = value!;
                  }),
                  SizedBox(height: 10,),

                MyTextFormField(
                  controller: nameProductController, 
                  name: "Name product", 
                  prefixIcon: Icon(Icons.title_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write name product" : null,
                  onSaved: (value) {
                  nameProductController.text = value!;
                  }),
                SizedBox(height: 10,),

                MyTextFormField(
                  controller: ratingController, 
                  name: "Rating", 
                  prefixIcon: Icon(Icons.title_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write rating product" : null,
                  onSaved: (value) {
                  ratingController.text = value!;
                  }),
                SizedBox(height: 10,),

                MyTextFormField(
                  controller: sizeController, 
                  name: "Size", 
                  prefixIcon: Icon(Icons.tag_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product size" : null,
                  onSaved: (value) {
                  sizeController.text = value!;
                  }),
                  SizedBox(height: 10,),

                MyTextFormField(
                  controller: priceController, 
                  name: "Price", 
                  prefixIcon: Icon(Icons.numbers_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product price" : null,
                  onSaved: (value) {
                  priceController.text = value!;
                  }),
                  SizedBox(height: 10,),

                MyTextFormField(
                  controller: stockController, 
                  name: "Stock", 
                  prefixIcon: Icon(Icons.production_quantity_limits_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product stock" : null,
                  onSaved: (value) {
                  stockController.text = value!;
                  }),
                  SizedBox(height: 10,),

                MyTextFormFieldVer2(
                  controller: descriptionController, 
                  name: "Description", 
                  prefixIcon: Icon(Icons.description_rounded, color: Colors.black,), 
                  validator: (value) => value == "" ? "Please write product description" : null,
                  onSaved: (value) {
                  descriptionController.text = value!;
                  }),
              ],
            ),
          ),
          MyButton(name: "Upload", 
          onPressed: () {
            if(_formKey.currentState!.validate())
              {
                Fluttertoast.showToast(msg: "Uploading ...");
                 uploadProductImage();
              }
          }),
          SizedBox(height: 20,)
        ],
      )
      ),
      
    ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadProductFromScreen();
  }

  Future<List<Clothes>> getAllClothItems() async
  {
    List<Clothes> allClothItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getAllClothes)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if(responseBodyOfAllClothes["success"] == true)
        {
          (responseBodyOfAllClothes["clothItemsData"] as List).forEach((eachRecord)
          {
            allClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allClothItemsList;
  }

  Widget allItemWidget(context)
  {
    return FutureBuilder(
      future: getAllClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null)
          {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if(dataSnapShot.data!.length > 0)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                Clothes eachClothItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: ()
                  {
                    /* Get.to(() => ProductDetailScreen(itemInfo: eachClothItemRecord)); */

                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: Card(
                          child: Container(
                            color: Colors.grey.shade100,
                            height: 130,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    
                                    Container(
                                      width: 150,
                                      padding: EdgeInsets.only(left: 15,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                            Text(eachClothItemRecord.product_brand!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),),
                                            Text(eachClothItemRecord.product_name!, style: TextStyle( fontSize: 17,),),
                                          SizedBox(height: 10,),
                                        Text("\I\D\R\. " + eachClothItemRecord.product_price.toString(), 
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900,),
                                            ),
                                            
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.redAccent,),
                                                  onPressed: () {
                                                    Get.dialog(
                                                      AlertDialog(
                                                        title: Text("Delete Product"),
                                                        content: Text("Are you sure you want to delete this product?"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("cancel"),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text("delete", style: TextStyle(color: Colors.red),),
                                                            onPressed: () {
                                                              deleteProduct(eachClothItemRecord.product_id!).then((isDeleted) {
                                                                if (isDeleted) {
                                                                  setState(() {
                                                              dataSnapShot.data!.remove(eachClothItemRecord);
                                                            });
                                                          }
                                                        });
                                                        Get.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );  
                                            },
                                          ),

                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  Clothes editedClothes = Clothes.copy(eachClothItemRecord);
                                                  return AlertDialog(
                                                    title: Text("Edit Product"),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Brand"),
                                                            controller: TextEditingController(text: editedClothes.product_brand),
                                                            onChanged: (value) {
                                                              editedClothes.product_brand = value;
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Name"),
                                                            controller: TextEditingController(text: editedClothes.product_name),
                                                            onChanged: (value) {
                                                              editedClothes.product_name = value;
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Price"),
                                                            controller: TextEditingController(text: editedClothes.product_price?.toString() ?? ''),
                                                            onChanged: (value) {
                                                              if (value.isNotEmpty) {
                                                                editedClothes.product_price = int.tryParse(value);
                                                              } else {
                                                                editedClothes.product_price = null;
                                                              }
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Rating"),
                                                            controller: TextEditingController(text: editedClothes.product_rating?.toString() ?? ''),
                                                            onChanged: (value) {
                                                              if (value.isNotEmpty) {
                                                                editedClothes.product_rating = double.tryParse(value);
                                                              } else {
                                                                editedClothes.product_rating = null;
                                                              }
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Size"),
                                                            controller: TextEditingController(text: editedClothes.product_size?.join(', ') ?? ''),
                                                            onChanged: (value) {
                                                              if (value.isNotEmpty) {
                                                                editedClothes.product_size = value.split(',').map((size) => size.trim()).toList();
                                                              } else {
                                                                editedClothes.product_size = null;
                                                              }
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Stock"),
                                                            controller: TextEditingController(text: editedClothes.product_stock?.toString() ?? ''),
                                                            onChanged: (value) {
                                                              if (value.isNotEmpty) {
                                                                editedClothes.product_stock = int.tryParse(value);
                                                              } else {
                                                                editedClothes.product_stock = null;
                                                              }
                                                            },
                                                          ),
                                                          TextField(
                                                            decoration: InputDecoration(labelText: "Product Description"),
                                                            controller: TextEditingController(text: editedClothes.product_description),
                                                            onChanged: (value) {
                                                              editedClothes.product_description = value;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("Save"),
                                                        onPressed: () {
                                                          updateProduct(editedClothes).then((isUpdated) {
                                                            if (isUpdated) {
                                                              setState(() {
                                                                
                                                              });
                                                            }
                                                            Navigator.of(context).pop();
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                    Container(
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(eachClothItemRecord.product_image!)),
                                        )
                                    ),
                                    
                                    ]
                                  ),
                                  
                            ),
                          ),
                        ),
                        
                    ],
                  ), 
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        }
    );
  }

   // update_product
  Future<bool> updateProduct(Clothes clothes) async {
  try {
    var res = await http.post(
      Uri.parse(API.updateProduct),
      body: {
          "product_id": clothes.product_id,
          "product_name": clothes.product_name,
          "product_brand": clothes.product_brand,
          "product_rating": clothes.product_rating.toString(),
          "product_size": clothes.product_size.toString(),
          "product_price": clothes.product_price.toString(),
          "product_stock": clothes.product_stock.toString(),
          "product_description": clothes.product_description,
      },
    );

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);

      if (responseBody["success"] == true) {
        Fluttertoast.showToast(msg: "Update product successful");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to update product");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      return false;
    }
  } catch (errorMessage) {
    print("Error: $errorMessage");
    Fluttertoast.showToast(msg: "Error: $errorMessage");
    return false;
  }
}

  Future<bool> deleteProduct(String product_id) async {
  try {
    var res = await http.post(
      Uri.parse(API.deleteProduct), 
      body: {
        "product_id": product_id, // Add the key-value pair here
      },
    );

    if (res.statusCode == 200) {
      var responseBody = jsonDecode(res.body);

      if (responseBody["success"] == true) {
        Fluttertoast.showToast(msg: "Product deleted successfully");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to delete product");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      return false;
    }
  } catch (errorMessage) {
    print("Error: $errorMessage");
    Fluttertoast.showToast(msg: "Error: $errorMessage");
    return false;
  }
}

}