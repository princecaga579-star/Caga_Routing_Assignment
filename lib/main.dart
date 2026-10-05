import 'package:flutter/material.dart';

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
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> students = const [
    {'name': 'Prince Caga', 'course': 'BSIT', 'age': 20},
    {'name': 'Jane Smith', 'course': 'BSCS', 'age': 22},
    {'name': 'John Doe', 'course': 'BSBA', 'age': 25},
    {'name': 'Emily Davis', 'course': 'BSN', 'age': 28},
    {'name': 'Michael Brown', 'course': 'BSEd', 'age': 30},
    {'name': 'Albert Johnson', 'course': 'BSCE', 'age': 34},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(student['name']),
              subtitle: Text('${student['course']} - Age: ${student['age']}'),
              trailing: const Icon(Icons.arrow_forward_ios),

              // ROUTING
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailsPage(
                      name: student['name'],
                      course: student['course'],
                      age: student['age'],
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
  final String course;
  final int age;

  const StudentDetailsPage({
    super.key,
    required this.name,
    required this.course,
    required this.age,
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
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text('Course: $course', style: const TextStyle(fontSize: 18)),

                Text('Age: $age', style: const TextStyle(fontSize: 18)),

                const SizedBox(height: 20),

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
