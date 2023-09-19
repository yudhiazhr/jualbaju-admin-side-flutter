import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../api_connection/api_connection.dart';
import '../../users/model/order.dart';
import '../userPreferences/current_user.dart';
import 'admin_all_orders.dart';
import 'admin_orders_detail.dart';


class adminAllHistoryOrders extends StatelessWidget
{
  final currentOnlineUser = Get.put(CurrentUser());


 Future<List<Order>> getAllOrdersList() async
  {
    List<Order> ordersList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.adminAllHistoryOrders),
          body:
          {

          }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true)
        {
          (responseBodyOfCurrentUserOrdersList['allOrdersData'] as List).forEach((eachOrderData)
          {
            ordersList.add(Order.fromJson(eachOrderData));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return ordersList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.to(()=> AdminGetAllOrdersScreen());
          },
        ),
        title: Text("ARRAXYS", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: ListTile(
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shopping_bag, color: Colors.black, size: 18,),
                SizedBox(width: 5,),
                Text("History Orders", style: TextStyle(color: Colors.black, fontSize: 16),)
              ],
            ),
            ),
          ),
          Expanded(
            child: displayOrdersList(context),
          ),
        ],
      ),
    );
  }

  Widget displayOrdersList(context)
  {
    return FutureBuilder(
      future: getAllOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot)
      {

        if(dataSnapshot.connectionState == ConnectionState.waiting)
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(color: Colors.black,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if(dataSnapshot.data == null)
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                    "No orders found yet...",
                  style: TextStyle(color: Colors.black,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if(dataSnapshot.data!.length > 0)
        {
          List<Order> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index)
            {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index)
            {
              Order eachOrderData = orderList[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Get.to(() => AdminOrdersDetailScreen(
                          clickedOrderInfo: eachOrderData,
                        ));
                      },
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade500,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Success",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade50,fontSize: 14),
                                      ),
                                    ),
                                    
                                  ),
                                  SizedBox(width: 110),
                                  Text(
                                      "See detail",
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                    ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 18,),
                          ],
                        ),
                        
                      ),
                    ),
                    
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => AdminOrdersDetailScreen(
                              clickedOrderInfo: eachOrderData,
                            ));
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID # " + eachOrderData.order_id.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Total Amount: ",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "\I\D\R. " + eachOrderData.totalAmount!.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 191, 54, 12),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //date
                              //time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //date
                                  Text(
                                    DateFormat("dd MMMM, yyyy").format(eachOrderData.dateTime!),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  //time
                                  Text(
                                    DateFormat("hh:mm a").format(eachOrderData.dateTime!),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              
                            ],
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Nothing to show...",
                  style: TextStyle(color: Colors.black,),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
