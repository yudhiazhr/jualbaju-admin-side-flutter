import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api_connection/api_connection.dart';
import '../../users/model/order.dart';
import 'package:http/http.dart' as http;

import 'admin_all_orderInDelivery.dart';


class AdminOrdersDetailScreen extends StatefulWidget
{
  final Order? clickedOrderInfo;

  AdminOrdersDetailScreen({this.clickedOrderInfo,});

  @override
  State<AdminOrdersDetailScreen> createState() => _AdminOrdersDetailScreenState();
}



class _AdminOrdersDetailScreenState extends State<AdminOrdersDetailScreen>
{

  RxString _status = "new".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelInDelivery)
  {
    _status.value = parcelInDelivery;
  }

  showDialogForParcelConfirmation() async
  {
    if(widget.clickedOrderInfo!.status == "new")
    {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            "Have you sent this parcel?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: ()
              {
                Get.back(result: "yesConfirmed");
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );

      if(response == "yesConfirmed")
      {
        updateStatusValueInDatabase();
      }
    }
  }

  updateStatusValueInDatabase() async
  {
    try
    {
      var response = await http.post(
        Uri.parse(API.adminUpdateIndelivery),
        body:
        {
          "order_id": widget.clickedOrderInfo!.order_id.toString(),
        }
      );

      if(response.statusCode == 200)
      {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if(responseBodyOfUpdateStatus["success"] == true)
        {
          updateParcelStatusForUI("In Delivery");
        }
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateParcelStatusForUI(widget.clickedOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Detail Orders", style: const TextStyle( color: Colors.black),),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            if (status == 'new') {
              Get.back();
            } else {
              Get.to(() =>adminAllOrderInDelivery());
            }
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Material(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Obx(() => status == "new" 
                          ? Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.yellow.shade700,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "In Delivery",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.help_outline, color: Colors.redAccent,size: 16,)
                                ],
                              ),
                              
                            )
                          : Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green.shade500,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "In Delivery",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.check_circle_outline, color: Colors.greenAccent,size: 16,)
                                ],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Purchase date",style: TextStyle(color: Colors.grey.shade700),),
                    Text(DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.clickedOrderInfo!.dateTime!),)
                  ],
                ),
              ),
              const SizedBox(height: 5,),

              //display items belongs to clicked order
              displayClickedOrderItems(),

              const SizedBox(height: 5,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shipping Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Courier",style: TextStyle(color: Colors.grey.shade700),),
                      SizedBox(width: 90,),
                      Text(widget.clickedOrderInfo!.deliverySystem!),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shipment Address",style: TextStyle(color: Colors.grey.shade700),),
                      SizedBox(width: 20,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.clickedOrderInfo!.user_name!,style: TextStyle(fontWeight: FontWeight.bold,),),
                            Text(widget.clickedOrderInfo!.user_id_phone_number!,),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(widget.clickedOrderInfo!.user_street_address!+", "),
                                Text(widget.clickedOrderInfo!.user_city!+", "),
                                Text(widget.clickedOrderInfo!.user_state!+", "),
                                Text(widget.clickedOrderInfo!.user_zipcode!+", "),
                                Text(widget.clickedOrderInfo!.user_country!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Payment Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Method",style: TextStyle(color: Colors.grey.shade700),),
                      Text("Debit/Credit Online (VISA)"),
                    ],
                  ),
                  SizedBox(height: 10,),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Text("\I\D\R\. "+widget.clickedOrderInfo!.totalAmount!.toStringAsFixed(0),style: TextStyle(color: Colors.deepOrange.shade900,fontWeight: FontWeight.bold,fontSize: 16),),
                    ],
                  ),
                  
                ]),
            ),
            SizedBox(height: 20,)



            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(right: 50, left: 60, top: 15),
          child: InkWell(
            onTap: ()
              {
                if(status == "new")
                {
                  showDialogForParcelConfirmation();
                }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Processing",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Obx(()=>
                          status == "new"
                              ? const Icon(Icons.help_outline, color: Colors.redAccent,)
                              : const Icon(Icons.check_circle_outline, color: Colors.greenAccent,)
                      ),
                    ],
                  ),
                ),
              ),
                height: 70,
                width: double.infinity,
                decoration:BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                ),
        ),
                    /* Material(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: ()
                {
                  if(status == "new")
                  {
                    showDialogForParcelConfirmation();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        "Received",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Obx(()=>
                          status == "new"
                              ? const Icon(Icons.help_outline, color: Colors.redAccent,)
                              : const Icon(Icons.check_circle_outline, color: Colors.greenAccent,)
                      ),
                    ],
                  ),
                ),
              ),
            ), */
  );
    
  }
  displayClickedOrderItems()
  {
    List<String> clickedOrderItemsInfo = widget.clickedOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index)
      {
        Map<String, dynamic> itemInfo = jsonDecode(clickedOrderItemsInfo[index]);

        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [

              // image
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    child: Container(
                      color: Colors.white,
                      height: 130,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          // image
                          Container(
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(itemInfo["product_image"]),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Text(
                                    itemInfo["product_brand"],
                                    maxLines: 1,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                  ),

                                  Text(
                                    itemInfo["product_name"],
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(height: 5),

                                  Row(
                                    children: [
                                      Text(
                                        "Size: " + itemInfo["cart_size"].replaceAll("[", "").replaceAll("]", ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        "Qty: " + itemInfo["cart_quantity"].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\I\D\R\. " + itemInfo["totalAmount"].toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900),
                                      ),
                                      Text(
                                        itemInfo["cart_quantity"].toString() + " x " + itemInfo["product_price"].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
