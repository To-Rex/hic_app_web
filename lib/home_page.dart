import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hic_app/users_page.dart';
import 'add_user_page.dart';
import 'controllers/get_controller.dart';
import "dart:html" as html;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    final stream = _getController.supabase
        .from('people')
        .stream(primaryKey: ['id'])
        .execute();

    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const Icon(Icons.menu, color: Colors.white),
          title: Text('Insonlarni Tekshirish', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.filter_list, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => UsersPage());
              },
              icon: const Icon(Icons.supervised_user_circle, color: Colors.white),
            ),
          ],
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        ),
                        child: Text(
                          'jami insonlar: ${snapshot.data?.length}',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: Text(
                          'Tanishlar: ${snapshot.data?.where((item) => item['uid'] != null).length}',
                          style: TextStyle(color: Colors.green, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: Text(
                          'Notanishlar: ${snapshot.data?.where((item) => item['uid'] == null).length}',
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: Text(
                          'Ayollar: ${snapshot.data?.where((item) => item['gender'] == 'Female').length}',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                        ),
                        child: Text(
                          'Erkaklar: ${snapshot.data?.where((item) => item['gender'] == 'Male').length}',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ]
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data?[index];
                        final imageBase64 = item?['image'];
                        final createdAt = item?['created_at'];
                        Uint8List? imageBytes;

                        if (imageBase64 != null) {
                          imageBytes = base64Decode(imageBase64);
                        }
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black87.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 5.0),
                                Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                      color: item?['uid'] != null ? Colors.green : Colors.red,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: imageBytes != null
                                        ? Image.memory(
                                      imageBytes,
                                      fit: BoxFit.cover,
                                      width: 50.0,
                                      height: 50.0,
                                    )
                                        : const Icon(
                                      Icons.person,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${item?['camera']} - Camera', style: const TextStyle(color: Colors.white)),
                                    Text('${item?['gender']} - ${item?['uid'] != null ? 'Tanish' : 'NoTanish'}', style: TextStyle(color: item?['uid'] != null ? Colors.green : Colors.red)),
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 20.0),
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      '${item?['age']} yosh',
                                      style: const TextStyle(color: Colors.white),
                                    )
                                ),
                                const Spacer(),
                                Text(
                                  _formatDate(createdAt),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.download, color: Colors.white),
                                  onPressed: () {
                                    _downloadImage(item);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteItem(item);
                                  },
                                ),
                              ],
                            )
                        );
                      },
                    )
                  )
                ]
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          shape: const CircleBorder(),
          onPressed: () {
            Get.to(() => AddUserPage());
          },
          child: const Icon(Icons.add, color: Colors.white),
        )
    );
  }

  // Function to delete an item
  void _deleteItem(Map<String, dynamic>? item) async {
    // Show confirmation dialog before deleting
    Get.defaultDialog(
      title: "Delete Item",
      middleText: "Are you sure you want to delete this item?",
      confirm: ElevatedButton(
        onPressed: () async {
          await _getController.supabase.from('people').delete().eq('id', item?['id']);
          Get.back();
        },
        child: const Text('Delete'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancel'),
      ),
    );
  }

  // Function to download and save the image locally
  void _downloadImage(Map<String, dynamic>? item) {
    try {
      final imageBase64 = item?['image'];

      if (imageBase64 == null) {
        Get.snackbar('Error', 'Image not found.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Decode the Base64 string to Uint8List
      Uint8List imageBytes = base64Decode(imageBase64);

      // Convert bytes to a Blob and trigger download on the web
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element to trigger the download
      html.AnchorElement(href: url)
        ..setAttribute('download', 'image_${item?['id']}.png')
        ..click();

      // Cleanup
      html.Url.revokeObjectUrl(url);

      // Notify the user
      Get.snackbar('Success', 'Image downloaded successfully.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download image: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Function to format the date
  String _formatDate(String? createdAt) {
    if (createdAt == null) return 'N/A';
    final parsedDate = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // Format time as HH:mm:ss
    final formattedTime =
        '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}';

    if (parsedDate.year == now.year &&
        parsedDate.month == now.month &&
        parsedDate.day == now.day) {
      return 'Bugun $formattedTime';
    } else if (parsedDate.year == yesterday.year &&
        parsedDate.month == yesterday.month &&
        parsedDate.day == yesterday.day) {
      return 'Kecha $formattedTime';
    } else {
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} $formattedTime';
    }
  }

}
