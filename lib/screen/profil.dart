import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File handling

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Initialize controllers for name and email fields
  TextEditingController _nameController = TextEditingController(text: "Rizky");
  TextEditingController _emailController = TextEditingController(text: "rizky@gmail.com");

  // Placeholder for profile picture URL or image
  String _profileImageUrl = 'https://www.example.com/profile_picture.jpg';

  // Image Picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery (works on mobile and desktop)
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // If an image is picked, use the local image path or network URL
        _profileImageUrl = pickedFile.path;
      });
    }
  }

  // Save changes (this is a basic implementation, you can implement actual saving to SharedPreferences or a backend)
  void _saveProfile() {
    final name = _nameController.text;
    final email = _emailController.text;

    // In a real app, you'd save these changes to a database or SharedPreferences
    // Here, we simply display a confirmation message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile Updated"),
          content: Text("Name: $name\nEmail: $email"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: GestureDetector(
                onTap: _pickImage,  // Tap to pick an image
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImageUrl.startsWith('http')
                      ? NetworkImage(_profileImageUrl)  // Use NetworkImage correctly
                      : FileImage(File(_profileImageUrl)),  // Use FileImage correctly
                  child: _profileImageUrl == 'https://www.example.com/profile_picture.jpg'
                      ? const Icon(Icons.camera_alt, color: Colors.white)
                      : null,  // Show camera icon if no image is set
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name TextField
            const Text(
              "Name:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: "Enter your name",
              ),
            ),
            const SizedBox(height: 10),

            // Email TextField
            const Text(
              "Email:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _emailController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 30),

            // Save Profile Button
           
            // Keluar Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle keluar functionality, e.g., navigate back
                  Navigator.pop(context);  // Just an example to navigate back
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,  // Button color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  "Keluar",  // Ganti Log Out dengan Keluar
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
