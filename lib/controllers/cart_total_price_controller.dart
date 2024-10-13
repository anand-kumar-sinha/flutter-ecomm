import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartTotalPriceController extends GetxController {
  RxDouble fullPrice = 0.0.obs;
  RxDouble salePrice = 0.0.obs;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    fetchProductPrice();
    super.onInit();
  }

  void fetchProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    double sum = 0.0;
    double sum2 = 0.0;

    var dat;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data != null && data.containsKey('productFullPrice')) {
        sum += double.parse(data['productFullPrice']);
      }
      if (data != null && data.containsKey('productSalePrice')) {
        sum2 += double.parse(data['productSalePrice']);
      }
    }
    fullPrice.value = sum;
    salePrice.value = sum2;
  }
}
