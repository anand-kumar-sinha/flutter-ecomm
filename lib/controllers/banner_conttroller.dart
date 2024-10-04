import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerConttroller extends GetxController {
  RxList<String> bannerUrl = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannerUrl();
  }

  Future<void> fetchBannerUrl() async {
    try {
      QuerySnapshot bannerSnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

          if(bannerSnapshot.docs.isNotEmpty){
            bannerUrl.value = bannerSnapshot.docs.map((doc) => doc['ImageUrl'] as String).toList();
          }
    } catch (e) {
      print('error $e');
    }
  }
}
