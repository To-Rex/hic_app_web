import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_user_page.dart';
import 'controllers/get_controller.dart';
import 'dart:html' as html;

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    final stream = _getController.supabase.from('users').stream(primaryKey: ['id']).execute();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Tanish Insonlar', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.supervised_user_circle, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final item = snapshot.data?[index];
                var imageBase64 = item?['image'];
                final createdAt = item?['created_at'];
                Uint8List? imageBytes;

                // Check if imageBase64 is not null and clean it if necessary
                if (imageBase64 != null && imageBase64.isNotEmpty) {
                  if (imageBase64.startsWith('data:image')) {
                    final commaIndex = imageBase64.indexOf(',');
                    if (commaIndex != -1) {
                      imageBase64 = imageBase64.substring(commaIndex + 1);
                    }
                  }

                  try {
                    imageBytes = base64Decode(imageBase64);
                  } catch (e) {
                    print('Error decoding image: $e');
                  }
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
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        margin: const EdgeInsets.only(right: 10.0),
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
                          Text(
                            '${item?['name']} ${item?['surname']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${item?['phone']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${item?['region']} ${item?['district']},',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),

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
                        icon: const Icon(Icons.edit, color: Colors.green),
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
                  ),
                );
              },
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
      ),
    );
  }

  // Function to format the date
  String _formatDate(String? createdAt) {
    if (createdAt == null) return 'N/A';
    final parsedDate = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

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

  // Function to delete an item
  void _deleteItem(Map<String, dynamic>? item) async {
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

      Uint8List imageBytes = base64Decode(imageBase64);
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'image_${item?['id']}.png')
        ..click();
      html.Url.revokeObjectUrl(url);

      Get.snackbar('Success', 'Image downloaded successfully.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download image: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
