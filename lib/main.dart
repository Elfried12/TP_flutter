import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste des Étudiants',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Map<String, String>> students = [];

  void _addStudent(Map<String, String> student) {
    setState(() {
      students.add(student);
    });
    Navigator.pop(context);
  }

  void _removeStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
      ),
      body: students.isEmpty
          ? const Center(
              child: Text(
                'Aucun étudiant ajouté',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${students[index]['nom']} ${students[index]['prenom']}'),
                  subtitle: Text(students[index]['email']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailScreen(
                          student: students[index],
                          onDelete: () => _removeStudent(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(onAddStudent: _addStudent),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

class AddStudentScreen extends StatefulWidget {
  final Function(Map<String, String>) onAddStudent;

  const AddStudentScreen({super.key, required this.onAddStudent});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String prenom = '';
  String email = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onAddStudent({
        'nom': nom,
        'prenom': prenom,
        'email': email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvel Étudiant'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  onSaved: (value) => nom = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Veuillez entrer un nom' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  onSaved: (value) => prenom = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Veuillez entrer un prénom' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Adresse mail'),
                  onSaved: (value) => email = value!,
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez entrer une adresse mail'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentDetailScreen extends StatelessWidget {
  final Map<String, String> student;
  final VoidCallback onDelete;

  const StudentDetailScreen({super.key, required this.student, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'Étudiant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom : ${student['nom']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Prénom : ${student['prenom']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email : ${student['email']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(labelText: 'Commentaires'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 19, 7, 32)),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
