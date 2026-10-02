import 'dart:convert';
import 'package:flutter/material.dart';
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
      title: 'API Activity',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> exercises = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  // Retrieve data from API
  Future<void> fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        // Decode the API response
        final data = jsonDecode(response.body);

        // English exercise information
        final englishExercises = [
          {
            'id': 1,
            'title': 'Push Ups',
            'body':
                'A bodyweight exercise that works the chest, shoulders, and triceps.',
          },
          {
            'id': 2,
            'title': 'Squats',
            'body': 'An exercise that strengthens the legs and glutes.',
          },
          {
            'id': 3,
            'title': 'Lunges',
            'body':
                'An exercise that improves leg strength, balance, and coordination.',
          },
          {
            'id': 4,
            'title': 'Plank',
            'body':
                'A core exercise that strengthens the abdominal and back muscles.',
          },
          {
            'id': 5,
            'title': 'Jumping Jacks',
            'body':
                'A cardio exercise that helps improve endurance and coordination.',
          },
        ];

        setState(() {
          exercises = englishExercises;
          isLoading = false;
        });

        // Prevent unused variable warning
        print('API data received: ${data.length} records');
      } else {
        setState(() {
          errorMessage = 'Failed to load data.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Data'), centerTitle: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            )
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(child: Text('${exercise['id']}')),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                exercise['body'],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
