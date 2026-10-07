import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> students = [];
  bool isLoading = true;

  // Fetch students from API
  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        setState(() {
          students = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // Delete student from the list
  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text('No students to display'))
          : ListView.builder(
              itemCount: students.length,

              itemBuilder: (context, index) {
                final student = students[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),

                    title: Text(
                      student['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text('Email: ${student['email']}'),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),

                      onPressed: () {
                        deleteStudent(index);
                      },
                    ),

                    // ROUTING
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => StudentDetailsPage(
                            name: student['name'],
                            email: student['email'],
                            username: student['username'],
                            phone: student['phone'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// Student Details Page
class StudentDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final String username;
  final String phone;

  const StudentDetailsPage({
    super.key,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),

          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 50),
                ),

                const SizedBox(height: 20),

                Text(
                  name,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Username: $username',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text('Phone: $phone', style: const TextStyle(fontSize: 18)),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
